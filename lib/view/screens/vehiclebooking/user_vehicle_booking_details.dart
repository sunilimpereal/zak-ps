import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zak_mobile_app/models/ticket_summary.dart';
import 'package:zak_mobile_app/models/ticketrequest.dart';
import 'package:zak_mobile_app/models/userDetail.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/home_screen.dart';
import 'package:zak_mobile_app/view/screens/my_tickets_and_passes_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/ticket_view_model.dart';
import 'package:zak_mobile_app/view_models/vehicle_booking_view_model.dart';
import '../../../main.dart';

class UserVehicleInfo extends StatefulWidget {
  final TicketSummary summary;

  UserVehicleInfo({this.summary});
  @override
  _UserVehicleInfo createState() => _UserVehicleInfo();
}

class _UserVehicleInfo extends State<UserVehicleInfo> {
  String orderId;
  bool isLoading = false;

  TextEditingController _nameController, _cityController, _emailController;
  DateTime _selectedBookingDate;
  var _formKey = GlobalKey<FormState>();
  TicketViewModel ticketViewModel;
  TicketOrder order;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    ticketViewModel = TicketViewModel(accessToken);

    super.initState();
  }

  void _setUpRazorPay(TicketOrder order, String razorPayAPIKEY) {
    final razorPay = Razorpay();
    razorPay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final phoneNumber =
        Provider.of<AuthenticationViewModel>(context, listen: false)
            .phoneNumber;

    var options = {
      orderIDKey: order.orderId,
      key: razorPayAPIKEY,
      amountKey: order.amount,
      nameKey: zakKey,
      prefillKey: {contactKey: phoneNumber, emailKey: _emailController.text}
    };
    razorPay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final provider =
        Provider.of<VehicleBookingViewModel>(context, listen: false);
    setState(() {
      isLoading = false;
    });

    final responsee = await provider.getPaymentDetails(
        Provider.of<AuthenticationViewModel>(context, listen: false).token,
        response.orderId,
        paymentId: response.paymentId,
        signature: response.signature);
    if (responsee.didSucceed) {
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
          (Route<dynamic> route) => true);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isLoading = false;
    setState(() {});
    // ticketViewModel.getPaymentStatus(order);

    showSnackbar(_scaffoldKey, 'Could not finish payment!', () {});
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // TODO: Do something when an external wallet was selected
  }
  String generateTicketNumber() {
    String ticketNumber = widget.summary.zooName.substring(0, 3).toUpperCase();
    ticketNumber += userId;
    DateTime dateTime = DateTime.now();
    ticketNumber += (dateTime.month + 1).toString();

    ticketNumber += (dateTime.day.toString());
    ticketNumber += (dateTime.microsecond.toString()).padLeft(3, "0");
    return ticketNumber;
  }

  @override
  Widget build(BuildContext context) {
    void makeBooking(VehicleBookingViewModel provider) async {
      setState(() {
        isLoading = true;
      });
      // showCircularIndicator(context);
      _formKey.currentState.validate();
      final userDetails = UserVehicleModel(
          date: provider.selectedDate.toString(),
          email: _emailController.text,
          name: _nameController.text,
          quantity: provider.selectedQuantity.toString(),
          vehicleId: provider.selectedVehicle.id);
      final response = await provider.doBooking(
          Provider.of<AuthenticationViewModel>(context, listen: false).token);

      if (response.didSucceed) {
        orderId = json.decode(response.object)['order_id'];
        print(orderId);
        _setUpRazorPay(
            TicketOrder(
              orderId: orderId,
              amount: (provider.price * provider.selectedQuantity).toString(),
            ),
            provider.selectedZoo.razorPayAPIKey);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: ZAKAppBar(),
      body: Consumer<VehicleBookingViewModel>(
        builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ZAKTitle(
                        title: "Provide User Details",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ZAKTextField(
                            hintText: 'Name',
                            obscureText: false,
                            controller: _nameController),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ZAKTextField(
                            hintText: 'Email ID',
                            obscureText: false,
                            onChanged: (text) {
                              EmailValidator.validate(text);
                              setState(() {});
                            },
                            controller: _emailController),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ZAKTitle(
                        title: "Quantity",
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        subtitle: Text(
                            'Available: ${provider.selectedVehicleTime.quantity}'),
                        title: Text(
                          provider.selectedVehicleTime.startTime.toString(),
                          style: TextStyle(
                              color: ZAKDarkGreen, fontWeight: FontWeight.w600),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: ZAKGrey),
                              borderRadius: BorderRadius.circular(17)),
                          width: 100,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (provider.selectedQuantity > 0) {
                                    provider.selectedQuantity--;
                                  }
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: ZAKGreen,
                                ),
                              ),
                              Text(
                                '${provider.selectedQuantity ?? '0'}',
                                style: subtitleTextStyle(FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (provider.selectedQuantity <
                                      provider.selectedVehicleTime.quantity) {
                                    provider.selectedQuantity++;
                                  }
                                },
                                child: Icon(
                                  Icons.add,
                                  color: ZAKGreen,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: ZAKButton(
                          title: 'Proceed To Pay',
                          onPressed:
                              (EmailValidator.validate(_emailController.text) &&
                                      _nameController.text.isNotEmpty &&
                                      _emailController.text.isNotEmpty &&
                                      provider.selectedQuantity > 0)
                                  ? () {
                                      makeBooking(provider);
                                    }
                                  : null),
                    ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// final response = await provider
//     .doBooking(_accessToken);
// if (response.didSucceed) {
//   TicketOrder order;

//   String orderId = json.decode(
//       response.object)['order_id'];

//   final ticketOrderResponse =
//       await provider.getPaymentDetails(
//           _accessToken, orderId);

// }

class UserVehicleModel {
  String date;
  String vehicleId;
  String quantity;
  String name;
  String email;

  UserVehicleModel(
      {this.date, this.vehicleId, this.quantity, this.name, this.email});
}

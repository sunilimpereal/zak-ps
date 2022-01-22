import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zak_mobile_app/models/lineItem.dart';
import 'package:zak_mobile_app/models/ticket_subcategory.dart';
import 'package:zak_mobile_app/models/ticket_summary.dart';
import 'package:zak_mobile_app/models/ticketrequest.dart';
import 'package:zak_mobile_app/models/userDetail.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/my_tickets_and_passes_screen.dart';
import 'package:zak_mobile_app/view/screens/tickets_passes/ticket_details.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_gradient_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/ticket_view_model.dart';
import 'package:zak_mobile_app/extensions/text.dart';

import '../../main.dart';

class UserTicketFormScreen extends StatefulWidget {
  final TicketSummary summary;

  UserTicketFormScreen({this.summary});
  @override
  _UserTicketFormScreenState createState() => _UserTicketFormScreenState();
}

class _UserTicketFormScreenState extends State<UserTicketFormScreen> {
  ValueNotifier isLoading = ValueNotifier(false);
  TextEditingController _nameController, _cityController, _emailController;
  DateTime _selectedBookingDate;
  var _formKey = GlobalKey<FormState>();
  TicketViewModel ticketViewModel;
  TicketOrder order;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _cityController = TextEditingController();
    _emailController = TextEditingController();
    _selectedBookingDate = DateTime.now();
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    ticketViewModel = TicketViewModel(accessToken);

    super.initState();
  }

  void _setUpRazorPay(TicketOrder order) {
    final razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final phoneNumber =
        Provider.of<AuthenticationViewModel>(context, listen: false)
            .phoneNumber;

    var options = {
      orderIDKey: order.orderId,
      key: widget.summary.razorPayAPIkey,
      amountKey: order.amount,
      nameKey: zakKey,
      prefillKey: {contactKey: phoneNumber, emailKey: _emailController.text}
    };
    razorPay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    order.signature = response.signature;
    order.paymentId = response.paymentId;
    isLoading.value = false;
    ticketViewModel.getPaymentStatus(order);
    // Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>TicketDetailsScreen(ticket));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MyTicketsAndPassesScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ticketViewModel.getPaymentStatus(order);
    isLoading.value = false;
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
    void makeBooking() async {
      isLoading.value = true;
      // showCircularIndicator(context);
      _formKey.currentState.validate();
      final userDetails = UserDetails(
          city: _cityController.text,
          dateOfVisit: _selectedBookingDate.toString(),
          email: _emailController.text,
          name: _nameController.text);

      final ticket = TicketRequestModel(
          number: generateTicketNumber(),
          userDetails: userDetails,
          lineItems: widget.summary.lineitems,
          price: widget.summary.totalAmount.toDouble(),
          userEmail: userDetails.email,
          organization: widget.summary.organizationId,
          createdTimeStamp: DateTime.now().toUtc().toString()
          // price:
          );
      final finalTicket = await ticketViewModel.getOrderId(ticket);
//      Navigator.of(context).pop();
      if (finalTicket.id == null) {
        showSnackbar(_scaffoldKey, genericErrorMessage, () {});
        isLoading.value = false;
      } else {
        order = await ticketViewModel.getRazorPayOrderId(finalTicket.id);
        _setUpRazorPay(order);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: ZAKAppBar(),
      body: Padding(
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
                      title: "Provide ticket details",
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
                          hintText: 'City',
                          obscureText: false,
                          controller: _cityController),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: GestureDetector(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                          );
                          setState(() {
                            _selectedBookingDate = selectedDate;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(width: 1, color: ZAKGrey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              _selectedBookingDate == null
                                  ? 'Visit Date'
                                  : getFormattedDate(_selectedBookingDate),
                              style: TextStyle(
                                  color: _selectedBookingDate == null
                                      ? null
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, isLoadings, child) {
                  return isLoadings
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: ZAKButton(
                              title: 'Proceed To Pay',
                              onPressed: (EmailValidator.validate(
                                          _emailController.text) &&
                                      _nameController.text.isNotEmpty &&
                                      _cityController.text.isNotEmpty &&
                                      _emailController.text.isNotEmpty &&
                                      _selectedBookingDate != null)
                                  ? makeBooking
                                  : null),
                        );
                }),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class TitleSubtitleText extends StatelessWidget {
  final String title, subtitle;
  TitleSubtitleText({@required this.title, @required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.withStyle(
            color: ZAKDarkGreen, style: Theme.of(context).textTheme.headline6),
        SizedBox(
          height: 5,
        ),
        subtitle.withStyle(
            style: Theme.of(context).textTheme.subtitle2, color: ZAKGrey)
      ],
    );
  }
}

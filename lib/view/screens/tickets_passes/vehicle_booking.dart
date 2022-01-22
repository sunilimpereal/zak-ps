import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zak_mobile_app/models/ticketrequest.dart';
import 'package:zak_mobile_app/models/vehicleBooking.dart/available_vehicle_response.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/networking/constants.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/home_screen.dart';
import 'package:zak_mobile_app/view/screens/vehiclebooking/select_vehicle.dart';
import 'package:zak_mobile_app/view/screens/vehiclebooking/user_vehicle_booking_details.dart';
import 'package:zak_mobile_app/view/widgets/vehicle_availability_card.dart';

import 'package:zak_mobile_app/view/widgets/zak_button.dart';

import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/vehicle_booking_view_model.dart';

class VehicleBookingScreen extends StatelessWidget {
  final Vehicle vehicle;

  VehicleBookingScreen(this.vehicle);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> restricted = ValueNotifier(false);
    final provider =
        Provider.of<VehicleBookingViewModel>(context, listen: false);
    TicketOrder order;

    String _accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    Size size = MediaQuery.of(context).size;
    TextEditingController controller;

    void _handlePaymentSuccess(PaymentSuccessResponse response) {
      order.signature = response.signature;
      order.paymentId = response.paymentId;
      provider.getPaymentDetails(
          Provider.of<AuthenticationViewModel>(context, listen: false).token,
          order.id);
      //  isLoading.value = false;
      //  ticketViewModel.getPaymentStatus(order);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
          (Route<dynamic> route) => true);
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      //  ticketViewModel.getPaymentStatus(order);
      //  isLoading.value = false;
      // showSnackbar(_scaffoldKey, 'Could not finish payment!', () {});
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      // TODO: Do something when an external wallet was selected
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
        key: provider.selectedZoo.razorPayAPIKey,
        amountKey: order.amount,
        nameKey: zakKey,
        prefillKey: {
          contactKey: phoneNumber,
          //emailKey: _emailController.text
        }
      };
      razorPay.open(options);
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ZAKTitle(
                title: 'Select your time slot',
              ),
            ),
            Consumer<VehicleBookingViewModel>(
              builder: (context, provider, child) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: ZAKTextField(
                  hintText: provider.selectedDate != null
                      ? getFormattedDate(provider.selectedDate)
                      : 'Select Date',
                  controller: controller,
                  readOnly: true,
                  obscureText: false,
                  onTap: () async {
                    final DateTime picked = await showDatePicker(
                        builder: (_, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                              primary: Colors.green,
                            )),
                            child: child,
                          );
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030));
                    if (picked != null && picked != provider.selectedDate) {
                      provider.selectedDate = picked;
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('NOTE'),
            ),
            Container(
              color: ZAKLightGrey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'This reservation is for Battery operated vehicle (BOV) only. You will need to purchase you r entry tickets seperately from the main menu. Each trip is stricty limited to one hour only',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            Consumer<VehicleBookingViewModel>(
              builder: (context, provider, child) => provider.selectedDate ==
                      null
                  ? Container()
                  : Container(
                      child: FutureBuilder(
                          future: provider.getVehiclesByDay(_accessToken),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: CircularProgressIndicator(),
                              ));
                            } else if (provider.availableVehicleResponse
                                .availability.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Text(
                                    'No vehicle available for this date.\nTry Again with some other date',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ZAKGreen,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    GridView.count(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      childAspectRatio: 4 / 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      children: List.generate(
                                        provider.availableVehicleResponse
                                            .availability.length,
                                        (index) => VehicleAvailablityListTile(
                                          vehicle: provider
                                              .availableVehicleResponse
                                              .availability[index],
                                          onSelect: () {
                                            provider.selectedQuantity = 1;
                                            provider.price = double.parse(
                                                provider
                                                    .availableVehicleResponse
                                                    .price);
                                            provider.selectedVehicleTime =
                                                provider
                                                    .availableVehicleResponse
                                                    .availability[index];
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        UserVehicleInfo()));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

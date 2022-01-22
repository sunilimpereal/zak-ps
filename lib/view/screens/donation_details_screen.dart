import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:zak_mobile_app/models/donation.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/successfully_completed_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/donation_view_model.dart';

class DonationDetailsScreen extends StatefulWidget {
  final String zooName;
  final String zooID;
  final Zoo zoo;

  DonationDetailsScreen({this.zooID, this.zooName, this.zoo});
  static const routeName = 'DonationDetailsScreen/';

  @override
  _DonationDetailsScreenState createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _donationAmountController = TextEditingController();
  DonationViewModel donationVM;
  Donation donation = Donation();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    donation.signature = response.signature;
    donation.paymentId = response.paymentId;
    donationVM.getPaymentStatus(donation);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SuccessfullyCompletedPayment(
              didCompleteDonating: true,
              animalNames: [],
              zoo: widget.zoo,
            )));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    donation.paymentStatus = 'Failed';
    donationVM.orderPaymentFailed(donation);
    showSnackbar(_scaffoldKey, 'Could not finish payment!', () {});
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // TODO: Do something when an external wallet was selected
  }

  void _setUpRazorPay(Donation donation) {
    final razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final phoneNumber =
        Provider.of<AuthenticationViewModel>(context, listen: false)
            .phoneNumber;
    var options = {
      orderIDKey: donation.orderID,
      key: widget.zoo.razorPayAPIKey,
      amountKey: donation.donationAmount * 100,
      nameKey: zakKey,
      prefillKey: {contactKey: phoneNumber, emailKey: donation.emailID}
    };
    razorPay.open(options);
  }

  @override
  void initState() {
    super.initState();
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    donationVM = DonationViewModel(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    void makeDonation() async {
      _formKey.currentState.validate();
      if (double.parse(_donationAmountController.text) >= 50) {
        donation = Donation(
          name: _nameController.text,
          city: _cityController.text,
          emailID: _emailController.text,
          zooName: widget.zooName,
          zooID: widget.zooID,
          donationAmount: double.parse(_donationAmountController.text),
        );
        showCircularIndicator(context);
        donation = await donationVM.getOrderID(donation);
        Navigator.of(context).pop();
        if (donation.orderID == null) {
          showSnackbar(_scaffoldKey,
              'Something went wrong. Please try again later.', () {});
        } else {
          _setUpRazorPay(donation);
        }
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: ZAKAppBarWithContactDetails(widget.zoo.contact, _scaffoldKey),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ZAKTitle(
                  title: widget.zooName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child:
                    'All donation & adoptions are exempted u/s. 80 of the IT Act 1961.'
                        .withStyle(
                            style: subtitleTextStyle(FontWeight.w500),
                            color: ZAKGrey),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child:
                    'All the donations will be posted on the zoo website. For donations above INR 10,000 details will be mentioned at the zoo’s name board as well. Donation certificate will be emailed.'
                        .withStyle(
                            style: subtitleTextStyle(FontWeight.w500),
                            color: ZAKGrey),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: ZAKTextField(
                          hintText: 'Name',
                          obscureText: false,
                          controller: _nameController,
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: ZAKTextField(
                          hintText: 'City',
                          obscureText: false,
                          controller: _cityController,
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: ZAKTextField(
                          hintText: 'Email ID',
                          obscureText: false,
                          controller: _emailController,
                          onChanged: (_) {
                            setState(() {});
                          },
                          validator: (String text) {
                            if (!EmailValidator.validate(text)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      ZAKTextField(
                        hintText: 'Donation amount',
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (String text) {
                          if (double.parse(text) < 50) {
                            return 'The donation amount should be a minimum of INR 50';
                          }
                          return null;
                        },
                        controller: _donationAmountController,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40, top: 123),
                        child: ZAKButton(
                          onPressed:
                              (EmailValidator.validate(_emailController.text) &&
                                      _nameController.text.isNotEmpty &&
                                      _cityController.text.isNotEmpty &&
                                      _emailController.text.isNotEmpty &&
                                      _donationAmountController.text.isNotEmpty)
                                  ? makeDonation
                                  : null,
                          title: 'Donate',
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

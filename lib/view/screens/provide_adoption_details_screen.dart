import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:zak_mobile_app/models/adoption.dart';
import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/successfully_completed_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_radio_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_text_field.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/view_models/adoption_view_model.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class ProvideAdoptionDetailsScreen extends StatefulWidget {
  final double totalAmount;
  final List<Animal> selectedAnimals;
  final Zoo zoo;

  ProvideAdoptionDetailsScreen(
      this.totalAmount, this.selectedAnimals, this.zoo);

  @override
  _ProvideAdoptionDetailsScreenState createState() =>
      _ProvideAdoptionDetailsScreenState();
}

class _ProvideAdoptionDetailsScreenState
    extends State<ProvideAdoptionDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  Adoption adoption = Adoption();
  bool displayName = false;
  AdoptionViewModel adoptionVM;
  DateTime selectedDateOfAdoption = DateTime.now();

  @override
  void initState() {
    super.initState();
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    adoptionVM = AdoptionViewModel(accessToken);
  }

  void makeAdoption() async {
    showCircularIndicator(context);
    final phoneNumber =
        Provider.of<AuthenticationViewModel>(context, listen: false)
            .phoneNumber;
    _formKey.currentState.validate();
    adoption = Adoption(
        animals: widget.selectedAnimals,
        displayName: displayName,
        totalAmount: widget.totalAmount,
        zooID: widget.zoo.id,
        zooName: widget.zoo.name,
        name: _nameController.text,
        cityName: _cityController.text,
        email: _emailController.text,
        phoneNumber: phoneNumber,
        dateOfAdoption: selectedDateOfAdoption);
    adoption = await adoptionVM.getAdoptionOrderID(adoption);
    Navigator.of(context).pop();
    if (adoption.adoptionOrderID == null) {
      showSnackbar(_scaffoldKey, genericErrorMessage, () {});
    } else {
      _setUpRazorPay();
    }
  }

  void _setUpRazorPay() {
    final razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final phoneNumber =
        Provider.of<AuthenticationViewModel>(context, listen: false)
            .phoneNumber;

    var options = {
      orderIDKey: adoption.adoptionOrderID,
      key: widget.zoo.razorPayAPIKey,
      amountKey: adoption.totalAmount * 100,
      nameKey: zakKey,
      prefillKey: {contactKey: phoneNumber, emailKey: _emailController.text}
    };
    razorPay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    adoption.signature = response.signature;
    adoption.paymentID = response.paymentId;
    adoptionVM.getPaymentStatus(adoption);
    List<String> animalsNames = [];
    for (var animal in widget.selectedAnimals) {
      animalsNames.add(animal.name);
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SuccessfullyCompletedPayment(
              didCompleteDonating: false,
              animalNames: animalsNames,
              zoo: widget.zoo,
            )));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    adoptionVM.getPaymentStatus(adoption);
    showSnackbar(_scaffoldKey, 'Could not finish payment!', () {});
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // TODO: Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: ZAKAppBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ZAKTitle(
                    title: 'Provide adoption details',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child:
                        'All adoptions will be posted on the zoo website. Adoption certificate will be emailed.'
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
                                if (!EmailValidator.validate(text.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
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
                                  selectedDateOfAdoption = selectedDate;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: ZAKGrey))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    selectedDateOfAdoption == null
                                        ? 'Adoption Start Date'
                                        : getFormattedDate(
                                            selectedDateOfAdoption),
                                    style: TextStyle(
                                        color: selectedDateOfAdoption == null
                                            ? null
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  // 'Do you want your details (name and city) to be displayed on a board next to animal enclosure?'
                  //     .withStyle(
                  //         style: subtitleTextStyle(FontWeight.w500),
                  //         color: ZAKDarkGreen),
                  // Row(
                  //   children: <Widget>[
                  //     ZAKRadioButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             displayName = false;
                  //           });
                  //         },
                  //         title: 'No',
                  //         isSelected: !displayName),
                  //     ZAKRadioButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             displayName = true;
                  //           });
                  //         },
                  //         title: 'Yes',
                  //         isSelected: displayName),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 123),
                child: ZAKButton(
                  onPressed: (EmailValidator.validate(_emailController.text.trim()) &&
                          _nameController.text.isNotEmpty &&
                          _cityController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          selectedDateOfAdoption != null)
                      ? makeAdoption
                      : null,
                  title: 'Proceed To Pay',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:zak_mobile_app/models/adoption.dart';
import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

class AdoptionViewModel {
  final accessToken;

  AdoptionViewModel(this.accessToken);

  Future<List<Adoption>> getMyAdoptions() async {
    List<Adoption> adoptions = [];
    final response = await getRequest(
        accessToken: accessToken,
        api: adoptionOrdersAPIKey + '?status=Paid',
        successStatusCode: 200);
    if (response.object != null) {
      final adoptionsResponse = json.decode(response.object);
      for (var donation in adoptionsResponse) {
        adoptions.add(_getAdoptionFromResponse(donation));
      }
    }
    return adoptions;
  }

  Adoption _getAdoptionFromResponse(dynamic response) {
    final List<Animal> animals = [];
    final animalsResponse = response[adoptionOrderItemsKey];
    for (var animal in animalsResponse) {
      animals.add(Animal(
        name: animal[animalNameKey],
        numberOfYears: animal[durationKey],
      ));
    }
    final timeStamp = response[createdTimeStamp];
    final dateOfAdoption = DateTime.parse(timeStamp);
    final adoption = Adoption(
        zooName: response[zooNameKey] ?? '',
        animals: animals,
        dateOfAdoption: dateOfAdoption);
    return adoption;
  }

  Future<Adoption> getAdoptionOrderID(Adoption adoption) async {
    final List<Map<String, dynamic>> animals = [];
    for (var animal in adoption.animals) {
      animals.add({
        animalKey: animal.animalID,
        animalNameKey: animal.name,
        amountKey: animal.amount,
        durationKey: animal.numberOfYears,
      });
    }
    final body = {
      adoptionOrderItemsKey: animals,
      zooNameKey: adoption.zooName,
      totalAmountKey: adoption.totalAmount,
      zooKey: adoption.zooID,
    };
    final response = await postRequest(
        api: adoptionOrdersAPIKey,
        successStatusCode: 201,
        body: body,
        accessToken: accessToken);
    if (response.object != null && response.didSucceed) {
      final adoptionResponse = json.decode(response.object);
      adoption.adoptionOrderID = adoptionResponse[orderIDKey].toString();
      adoption.adoptionID = adoptionResponse[idKey].toString();
    }
    // TODO: Check this flow
    _createAdoptionDetails(adoption);
    return adoption;
  }

  void _createAdoptionDetails(Adoption adoption) {
    final body = {
      nameKey: adoption.name,
      addressKey: adoption.cityName,
      mobileKey: adoption.phoneNumber,
      emailKey: adoption.email,
      adoptionOrderKey: int.parse(adoption.adoptionID),
      cityKey: adoption.cityName,
      displayKey: adoption.displayName ? 'Yes' : 'No',
      displayNameKey: adoption.name,
      displayCityKey: adoption.cityName,
      startDateKey: _getFormattedDateForBackend(adoption.dateOfAdoption)
    };
    postRequest(
        accessToken: accessToken,
        successStatusCode: 201,
        body: body,
        api: adoptionDetailsKey);
  }

  String _getFormattedDateForBackend(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return (formatter.format(date));
  }

  void getPaymentStatus(Adoption adoption) async {
    final body = {
      signatureKey: adoption.signature,
      paymentIDKey: adoption.paymentID,
    };
    final adoptionID = adoption.adoptionID;
    patchRequest(
        accessToken: accessToken,
        api: adoptionOrdersAPIKey + '$adoptionID/',
        successStatusCode: 200,
        body: body);
  }
}

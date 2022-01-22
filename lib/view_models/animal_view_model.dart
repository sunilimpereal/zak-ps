import 'dart:convert';

import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

class AnimalViewModel {
  final accessToken;

  AnimalViewModel(this.accessToken);

  Future<List<Animal>> getAdoptionGroups(String groupID) async {
    List<Animal> animals = [];
    final response = await getRequest(
        accessToken: accessToken,
        api: animalsKey + '?group=$groupID',
        successStatusCode: 200);
    if (response.object != null) {
      final animalsResponse = json.decode(response.object);
      if (animalsResponse != null) {
        animals = _getAnimalsFromResponse(animalsResponse);
      }
    }
    return animals;
  }

  List<Animal> _getAnimalsFromResponse(dynamic animalsResponse) {
    final List<Animal> animals = [];
    for (var animal in animalsResponse) {
      animals.add(Animal(
          amount: animal[amountKey],
          animalID: animal[idKey].toString(),
          groupID: animal[groupKey].toString(),
          name: animal[nameKey]));
    }
    return animals;
  }
}

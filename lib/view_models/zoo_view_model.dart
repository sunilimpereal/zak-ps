import 'dart:convert';

import 'package:zak_mobile_app/models/contact.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

class ZooViewModel {
  final accessToken;

  ZooViewModel(this.accessToken);

  Future<List<Zoo>> getZoos({bool toDonate = false}) async {
    List<Zoo> zoos = [];
    final response = await getRequest(
        accessToken: accessToken,
        api: zooKey + (toDonate ? '?donation=true' : '?adoption=true'),
        successStatusCode: 200);
    if (response.object != null) {
      final zoosResponse = json.decode(response.object);
      if (zoosResponse != null) {
        zoos = _getZooFromResponse(zoosResponse);
      }
    }

    return zoos;
  }

  Future<List<Zoo>> getZoosForTicketBooking() async {
    List<Zoo> zoos = [];
    final response = await getRequest(
        accessToken: accessToken,
        api: zooKey + '/?ticketing_org__isnull=false',
        successStatusCode: 200);
    if (response.object != null) {
      final zoosResponse = json.decode(response.object);
      if (zoosResponse != null) {
        zoos = _getZooFromResponse(zoosResponse);
      }
    }

    return zoos;
  }

  List<Zoo> _getZooFromResponse(dynamic zoosResponse) {
    final List<Zoo> zoos = [];
    for (var zoo in zoosResponse) {
      Contact contact;
      List contactsResponse = zoo[zooContactDetailsKey];
      if (contactsResponse != null && contactsResponse.isNotEmpty) {
        if (contactsResponse[0] != null) {
          contact = Contact(
              name: contactsResponse[0][nameKey],
              role: contactsResponse[0][roleKey],
              email: contactsResponse[0][emailKey],
              phoneNumber: contactsResponse[0][phoneNumberKey],
              zooID: contactsResponse[0][zooKey].toString(),
              id: contactsResponse[0][idKey].toString());
        }
      }
      zoos.add(Zoo(
          id: zoo[idKey].toString(),
          city: zoo[cityKey],
          name: zoo[nameKey],
          organizationId: zoo['ticketing_org'].toString(),
          numberOfSpecies: zoo[numberOfSpeciesKey],
          razorPayAPIKey: zoo[razorPayClientIDKey],
          contact: contact));
    }
    return zoos;
  }
}

import 'dart:convert';

import 'package:zak_mobile_app/models/adoption_group.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

class AdoptionGroupViewModel {
  final accessToken;

  AdoptionGroupViewModel(this.accessToken);

  Future<List<AdoptionGroup>> getAdoptionGroups(String zooID, {bool toDonate = false}) async {
    List<AdoptionGroup> adoptionGroups = [];
    final response = await getRequest(
        accessToken: accessToken, api: groupsKey + '?zoo=$zooID', successStatusCode: 200);
    final adoptionGroupsResponse = json.decode(response.object);
    if (adoptionGroups != null) {
      adoptionGroups = _getAdoptionGroupsFromResponse(adoptionGroupsResponse);
    }
    return adoptionGroups;
  }

  List<AdoptionGroup> _getAdoptionGroupsFromResponse(
      dynamic adoptionGroupsResponse) {
    final List<AdoptionGroup> adoptionGroups = [];
    for (var adoptionGroup in adoptionGroupsResponse) {
      final List<String> benefits = [];
      final benefitsResponse = adoptionGroup[benefitsKey];
      for (var benefit in benefitsResponse) {
        benefits.add(benefit.toString());
      }
      adoptionGroups.add(AdoptionGroup(
          adoptionGroupID: adoptionGroup[idKey].toString() ?? '',
          benefits: benefits,
          priceRange: adoptionGroup[priceRangeKey] ?? '',
          zooID: adoptionGroup[zooKey].toString() ?? ''));
    }
    return adoptionGroups;
  }
}

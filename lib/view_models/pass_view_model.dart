import 'dart:convert';

import 'package:zak_mobile_app/models/pass.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

class PassViewModel {
  final accessToken;

  PassViewModel(this.accessToken);

  Future<List<Pass>> getPasses() async {
    List<Pass> passes = [];
    final response = await getRequest(
        accessToken: accessToken, api: passesAPI, successStatusCode: 200);
    if (response.object != null) {
      final passesResponse = json.decode(response.object);
      for (var pass in passesResponse) {
        passes.add(_getPassFromResponse(pass));
      }
    }
    return passes;
  }

  Pass _getPassFromResponse(dynamic response) {
    final dateTimeStamp = response[validFromKey];
    final endDate =
        dateTimeStamp == null ? null : DateTime.parse(response['valid_till']);
    final date = dateTimeStamp == null ? null : DateTime.parse(dateTimeStamp);
    final pass = Pass(
        numberOfPasses: response['number_of_passes'],
        qrCode: response['qr_code'],
        remainingPasses: response['remaining_passes'],
        totalPasses: response['total_passes'],
        numberOfMembers: response[passDetailKey][numberOfMembersKey],
        numberOfVisits: response[passDetailKey][numberOfVisitsKey],
        startDate: date,
        endDate: endDate,
        zooName: response[passDetailKey][zooNameKey]);
    return pass;
  }
}

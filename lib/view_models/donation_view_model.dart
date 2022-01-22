import 'dart:convert';

import 'package:zak_mobile_app/models/donation.dart';
import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

class DonationViewModel {
  final accessToken;

  DonationViewModel(this.accessToken);

  Future<List<Donation>> getMyDonations() async {
    List<Donation> donations = [];
    final response = await getRequest(
        accessToken: accessToken,
        api: donationsKey + '?status=Paid',
        successStatusCode: 200);
    if (response.object != null) {
      final donationsResponse = json.decode(response.object);
      for (var donation in donationsResponse) {
        donations.add(_getDonationFromResponse(donation));
      }
    }
    return donations;
  }

  Donation _getDonationFromResponse(dynamic response) {
    final timeStamp = response[createdTimeStamp];
    final dateOfDonation = DateTime.parse(timeStamp);
    final donation = Donation(
        zooName: response[zooNameKey] ?? '',
        donationAmount: response[amountKey],
        dateOfDontaion: dateOfDonation);
    return donation;
  }

  Future<Donation> getOrderID(Donation donation) async {
    final body = {
      nameKey: donation.name,
      cityKey: donation.city,
      emailKey: donation.emailID,
      amountKey: donation.donationAmount,
      zooKey: int.parse(donation.zooID),
      'zoo_name': donation.zooName
    };
    final response = await postRequest(
        api: donationsKey,
        successStatusCode: 201,
        body: body,
        accessToken: accessToken);
    if (response.object != null && response.didSucceed) {
      final donationResponse = json.decode(response.object);
      donation.orderID = donationResponse[orderIDKey];
      donation.donationID = donationResponse[idKey].toString();
    }
    return donation;
  }

  void getPaymentStatus(Donation donation) async {
    final body = {
      signatureKey: donation.signature,
      paymentIDKey: donation.paymentId,
    };
    final donationID = donation.donationID;
    patchRequest(
        accessToken: accessToken,
        api: donationsKey + '$donationID/',
        successStatusCode: 200,
        body: body);
  }

  void orderPaymentFailed(Donation donation) async {
    final body = {statusKey: donation.paymentStatus};
    final donationID = donation.donationID;
    patchRequest(
        accessToken: accessToken,
        api: donationsKey + '$donationID/',
        successStatusCode: 200,
        body: body);
  }
}

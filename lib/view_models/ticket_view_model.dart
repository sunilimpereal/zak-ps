import 'dart:convert';

import 'package:zak_mobile_app/models/lineItem.dart';
import 'package:zak_mobile_app/models/ticket_category.dart';
import 'package:zak_mobile_app/models/ticketrequest.dart';
import 'package:zak_mobile_app/models/vehicleBooking.dart/vehicle_response_model.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

import '../main.dart';

class TicketViewModel {
  final String _accessToken;
  TicketViewModel(this._accessToken);

  Future<List<TicketCategory>> getCategories(String zooID) async {
    List<TicketCategory> categories = [];
    final response = await getRequest(
        accessToken: _accessToken,
        api: 'zoo_categories/?zoo=$zooID',
        successStatusCode: 200);
    if (response.didSucceed && response.object != null) {
      final categoryResponse = json.decode(response.object);
      for (var pass in categoryResponse) {
        categories.add(TicketCategory.fromMap(pass));
      }
    }
    return categories;
  }

  Future<TicketRequestModel> getOrderId(
      TicketRequestModel ticketRequestModel) async {
    final response = await postRequest(
        accessToken: _accessToken,
        api: 'user_online_ticket/',
        body: ticketRequestModel.toMap(),
        successStatusCode: 201);
    final ticket = TicketRequestModel.fromJson(response.object);

    return ticket;
  }

  Future<TicketOrder> getRazorPayOrderId(String id) async {
    try {
      final body = {'ticket': int.parse(id)};
      final response = await postRequest(
          accessToken: _accessToken,
          api: 'online_ticket_order/',
          body: body,
          successStatusCode: 201);
      TicketOrder ticket = TicketOrder.fromJson(response.object);

      return ticket;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPaymentStatus(TicketOrder order) async {
    final body = order.toMap();
    final response = await patchRequest(
        accessToken: _accessToken,
        api: 'online_ticket_order/${order.id}/',
        body: body,
        successStatusCode: 200);
    print(response);
  }

  Future<List<TicketRequestModel>> getMyTickets() async {
    List<TicketRequestModel> tickets = [];
    final response = await getRequest(
        accessToken: _accessToken,
        api:
            'user_online_ticket/?booked_by=$userId&onlineticketorder__status=Paid',
        successStatusCode: 200);

    for (var ticket in json.decode(response.object)) {
      tickets.add(TicketRequestModel.fromMap(ticket));
    }

    return tickets;
  }

  Future<List<VehicleResponseModel>> getVehicleTickets() async {
    List<VehicleResponseModel> tickets = [];
    final response = await getRequest(
        accessToken: _accessToken, api: 'book-slot/', successStatusCode: 200);

    for (var ticket in json.decode(response.object)) {
      tickets.add(VehicleResponseModel.fromMap(ticket));
    }

    return tickets;
  }
}

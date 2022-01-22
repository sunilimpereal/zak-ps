import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:zak_mobile_app/models/vehicleBooking.dart/available_vehicle_response.dart';
import 'package:zak_mobile_app/models/vehicleBooking.dart/day_available_response.dart';
import 'package:zak_mobile_app/models/zoo.dart';

import 'package:zak_mobile_app/networking/http_requests.dart';
import 'package:zak_mobile_app/utility/utility.dart';

class VehicleBookingViewModel extends ChangeNotifier {
  bool _isLoading = false;
  Vehicle _selectedVehicle;
  DateTime _selectedDate;
  VehicleAvailabilityResponse _availableVehicleResponse;
  Zoo _selectedZoo;
  double _price;
  String _accessToken;
  String _selectedTime;
  AvailableVehicleModel _selectedVehicleTime;
  int _selectedQuantity = 1;

  int get selectedQuantity => _selectedQuantity;
  set selectedQuantity(int quantity) {
    _selectedQuantity = quantity;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  double get price => _price;
  set price(double price) {
    this._price = price;
  }

  resetSelectedVehicleTime() {
    _selectedVehicleTime = null;
    notifyListeners();
  }

  AvailableVehicleModel get selectedVehicleTime => _selectedVehicleTime;
  set selectedVehicleTime(AvailableVehicleModel time) {
    _selectedVehicleTime = time;
  }

  set selectedZoo(Zoo value) {
    _selectedZoo = value;
  }

  Zoo get selectedZoo => _selectedZoo;

  // ignore: unnecessary_getters_setters
  Vehicle get selectedVehicle => _selectedVehicle;
  DateTime get selectedDate => _selectedDate;
  VehicleAvailabilityResponse get availableVehicleResponse =>
      _availableVehicleResponse;
  // ignore: unnecessary_getters_setters
  set selectedVehicle(Vehicle value) {
    _selectedVehicle = value;
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  reset() {
    _selectedVehicle = null;
  }

  Future<void> getVehiclesByDay(String accessToken) async {
    String d = DateFormat('yyyy-MM-dd').format(_selectedDate);
    var response = await postRequest(
        accessToken: accessToken,
        successStatusCode: 200,
        api: 'vehicle-availability/',
        body: {'date': d, 'bo_vehicle': selectedVehicle.id});

    if (response.didSucceed) {
      _availableVehicleResponse =
          VehicleAvailabilityResponse.fromJson(response.object);
    }
  }

  Future<List<Vehicle>> getAvailableVehicles(
      String zooId, String accessToken) async {
    _accessToken = accessToken;
    List<Vehicle> vehicles = [];
    var response = await getRequest(
        api: 'bo-vehicle/?zoo=$zooId',
        successStatusCode: 200,
        accessToken: accessToken);

    if (response.didSucceed) {
      for (var item in json.decode(response.object)) {
        vehicles.add(Vehicle.fromMap(item));
      }
    }
    return vehicles;
  }

  Future<Response> doBooking(String accessToken) async {
    String date = DateFormat('yyyy-MM-dd').format(_selectedDate).toString();
    var response = await postRequest(
        api: 'book-slot/',
        accessToken: accessToken,
        successStatusCode: 201,
        body: {
          'date': date,
          'bo_vehicle': _selectedVehicle.id,
          'start_time': _selectedVehicleTime.startTime,
          'quantity': _selectedQuantity
        });

    return response;
  }

  Future<Response> getPaymentDetails(String accessToken, String orderId,
      {String signature, String paymentId}) async {
    var response = await postRequest(
        accessToken: accessToken,
        api: 'payment-ev-booking/',
        successStatusCode: 201,
        body: {
          'order_id': orderId,
          'signature': signature,
          'payment_id': paymentId
        });
    return response;
  }
}

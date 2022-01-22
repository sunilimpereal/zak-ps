import 'dart:convert';

class VehicleAvailabilityResponse {
  List<AvailableVehicleModel> availability;
  String vehicleId;
  String date;
  String message;
  String price;

  VehicleAvailabilityResponse.fromMap(Map<String, dynamic> map) {
    vehicleId = map['bo_vehicle'].toString();
    date = map['date'];
    price = map['bo_vehicle_price'].toString();
    message = map['msg'];
    availability = ((map['available_vehicles'] ?? []) as List).map((response) {
      return AvailableVehicleModel.fromMap(response);
    }).toList();
  }

  factory VehicleAvailabilityResponse.fromJson(String source) =>
      VehicleAvailabilityResponse.fromMap(json.decode(source));
}

class AvailableVehicleModel {
  String startTime;
  int quantity;

  AvailableVehicleModel.fromMap(Map<String, dynamic> map) {
    startTime = map['start_time'];
    quantity = map['available_quantity'];
  }
}

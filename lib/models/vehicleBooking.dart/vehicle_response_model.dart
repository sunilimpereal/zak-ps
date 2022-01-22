class VehicleResponseModel {
  String bookingId;
  String user;
  String startTime;
  String endTime;
  String vehicleName;
  String date;

  VehicleResponseModel.fromMap(Map<String, dynamic> map) {
    this.bookingId = map['booking_id'];
    this.user = map['user'];
    this.startTime = map['start_time'];
    this.endTime = map['end_time'];
    this.vehicleName = map['zoo_bo_vehicle'];
    this.date = map['date'];
  }
}

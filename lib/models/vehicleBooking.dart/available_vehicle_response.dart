class Vehicle {
  String id;
  String name;
  int seats;
  int quantity;
  String price;
  bool isAvailable;

  Vehicle.fromMap(Map<String, dynamic> map) {
    id = map['id'].toString();
    name = map['name'];
    seats = map['seats'];
    quantity = map['quantity'];
    isAvailable = map['is_available'];
    price = map['price'].toInt().toString();
  }
}

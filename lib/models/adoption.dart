import 'package:zak_mobile_app/models/animal.dart';

class Adoption {
  String adoptionID;
  List<Animal> animals;
  String zooName;
  double totalAmount;
  String zooID;
  String adoptionOrderID;
  bool displayName;
  String signature;
  String paymentID;
  String name;
  String cityName;
  String email;
  String phoneNumber;
  DateTime dateOfAdoption;

  Adoption(
      {this.zooName,
      this.adoptionID,
      this.zooID,
      this.totalAmount,
      this.adoptionOrderID,
      this.animals,
      this.displayName,
      this.paymentID,
      this.signature,
      this.name,
      this.cityName,
      this.email,
      this.phoneNumber,
      this.dateOfAdoption});
}

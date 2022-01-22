class Donation {
  String zooName;
  String name;
  String city;
  String emailID;
  double donationAmount;
  String orderID;
  String signature;
  String paymentId;
  String paymentStatus;
  String donationID;
  String zooID;
  DateTime dateOfDontaion;

  Donation(
      {this.name,
      this.city,
      this.donationAmount,
      this.emailID,
      this.zooName,
      this.orderID,
      this.paymentId,
      this.signature,
      this.paymentStatus,
      this.donationID,
      this.zooID,
      this.dateOfDontaion});
}

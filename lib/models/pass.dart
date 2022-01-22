class Pass {
  String id;
  String zooName;
  DateTime startDate;
  DateTime endDate;
  int numberOfMembers;
  int numberOfVisits;
  int numberOfPasses;
  int totalPasses;
  String qrCode;
  int remainingPasses;

  Pass(
      {this.id,
      this.zooName,
      this.numberOfMembers,
      this.numberOfPasses,
      this.remainingPasses,
      this.endDate,
      this.qrCode,
      this.totalPasses,
      this.numberOfVisits,
      this.startDate});
}

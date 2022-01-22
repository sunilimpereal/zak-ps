import 'dart:convert';

import 'package:zak_mobile_app/models/lineItem.dart';
import 'package:zak_mobile_app/models/ticket_subcategory.dart';

class TicketSummary {
  String zooName;
  List<LineItem> lineitems;
  String razorPayAPIkey;
  int totalAmount;
  String organizationId;
  TicketSummary(
      {this.zooName,
      this.lineitems,
      this.totalAmount,
      this.organizationId,
      this.razorPayAPIkey});

  Map<String, dynamic> toMap() {
    return {
      'zooName': zooName,
      'category': lineitems?.map((x) => x?.toMap())?.toList(),
      'totalAmount': totalAmount,
      'organization': organizationId
    };
  }

  factory TicketSummary.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TicketSummary(
        zooName: map['zooName'],
        lineitems: List<LineItem>.from(
            map['category']?.map((x) => LineItem.fromMap(x))),
        totalAmount: map['totalAmount'],
        organizationId: map['organizationId']);
  }

  String toJson() => json.encode(toMap());

  factory TicketSummary.fromJson(String source) =>
      TicketSummary.fromMap(json.decode(source));
}

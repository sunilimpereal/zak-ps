import 'dart:convert';

import 'package:zak_mobile_app/models/lineItem.dart';
import 'package:zak_mobile_app/models/ticket_subcategory.dart';
import 'package:zak_mobile_app/models/userDetail.dart';

class TicketRequestModel {
  String id;
  String number;
  String organization;
  String userEmail;
  String organizationName;
  String qrCode;
  bool isScanned;
  List<LineItem> lineItems;
  double price;
  UserDetails userDetails;
  String createdTimeStamp;
  TicketRequestModel(
      {this.number,
      this.organization,
      this.isScanned,
      this.userEmail,
      this.qrCode,
      this.lineItems,
      this.id,
      this.price,
      this.userDetails,
      this.createdTimeStamp,
      this.organizationName});

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'organization': organization,
      'id': id,
      'user_email': userEmail,
      'organization_name': organizationName,
      'lineitems': lineItems?.map((x) => x?.toMap())?.toList(),
      'price': price,
      'user_details': userDetails?.toMap(),
      'issued_ts': createdTimeStamp,
    };
  }

  factory TicketRequestModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TicketRequestModel(
      number: map['number'],
      isScanned: map['isScanned'],
      qrCode: map['qr_code'],
      organization: map['organization'].toString(),
      organizationName: map['organization_name'],
      id: map["id"].toString(),
      userEmail: map['user_email'],
      lineItems: List<LineItem>.from(
          map['lineitems']?.map((x) => LineItem.fromMap(x))),
      price: map['price'],
      userDetails: UserDetails.fromMap(map['user_details']),
      createdTimeStamp: map['issued_ts'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketRequestModel.fromJson(String source) =>
      TicketRequestModel.fromMap(json.decode(source));
}

class TicketOrder {
  String id;
  String orderId;
  String amount;
  String signature;
  String paymentId;
  TicketOrder(
      {this.id, this.orderId, this.amount, this.signature, this.paymentId});

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'order_id': orderId,
      'amount': amount.toString(),
      'signature': signature,
      'payment_id': paymentId
    };
  }

  factory TicketOrder.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TicketOrder(
        id: map['id'].toString() ?? null,
        orderId: map['order_id'].toString(),
        amount: map['amount'].toString(),
        signature: map['signature'].toString(),
        paymentId: map['payment_id'].toString());
  }

  String toJson() => json.encode(toMap());

  factory TicketOrder.fromJson(String source) =>
      TicketOrder.fromMap(json.decode(source));
}

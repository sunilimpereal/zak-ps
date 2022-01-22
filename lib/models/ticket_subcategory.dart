import 'dart:convert';

class TicketSubCategory {
  String id;
  String name;
  String type;
  String price;
  int quantity;
  TicketSubCategory({
    this.id,
    this.name,
    this.price,
    this.type,
    this.quantity = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'quantity': quantity ?? 0,
    };
  }

  factory TicketSubCategory.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TicketSubCategory(
        id: map['id'].toString(),
        name: map['name'],
        price: map['price'].toString(),
        quantity: map['quantity'] ?? 0,
        type: map['type']);
  }

  String toJson() => json.encode(toMap());

  factory TicketSubCategory.fromJson(String source) =>
      TicketSubCategory.fromMap(json.decode(source));
}

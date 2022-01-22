import 'dart:convert';

import 'ticket_subcategory.dart';

class TicketCategory {
  String id;
  String name;
  String organizationId;
  List<TicketSubCategory> subcategory;
  String mode;
  TicketCategory({
    this.id,
    this.organizationId,
    this.name,
    this.mode,
    this.subcategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'organization': organizationId,
      'subcategories': subcategory?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory TicketCategory.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TicketCategory(
      id: map['id'].toString(),
      name: map['name'],
      organizationId: map['organization'].toString(),
      mode: map['mode'].toString(),
      subcategory: List<TicketSubCategory>.from(
          map['subcategories']?.map((x) => TicketSubCategory.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketCategory.fromJson(String source) =>
      TicketCategory.fromMap(json.decode(source));
}

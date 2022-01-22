import 'dart:convert';

class LineItem {
  String id;
  String subCategoryName;
  String type;
  String subCategoryPrice;
  int quantity;
  String price;
  String category;
  LineItem({
    this.id,
    this.subCategoryName,
    this.type,
    this.subCategoryPrice,
    this.quantity,
    this.price,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'subcategory': id,
      'subcategory_name': subCategoryName,
      'type': type,
      'subcategory_price': subCategoryPrice,
      'quantity': quantity,
      'price': price,
      'category': category,
    };
  }

  factory LineItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LineItem(
      id: map['subcategory'].toString(),
      subCategoryName: map['subcategory_name'],
      type: map['type'],
      subCategoryPrice: map['subcategory_price'].toString(),
      quantity: map['quantity'],
      price: map['price'].toString(),
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LineItem.fromJson(String source) =>
      LineItem.fromMap(json.decode(source));
}

import 'dart:convert';

class UserDetails {
  String name;
  String email;
  String city;
  String dateOfVisit;
  UserDetails({
    this.name,
    this.email,
    this.city,
    this.dateOfVisit,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'city': city,
      'date_of_visit': dateOfVisit,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserDetails(
      name: map['name'],
      email: map['email'],
      city: map['city'],
      dateOfVisit: map['date_of_visit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source));
}

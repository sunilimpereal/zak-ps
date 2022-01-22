import 'package:zak_mobile_app/models/contact.dart';

class Zoo {
  final String name;
  final String id;
  final String organizationId;
  final String city;
  final int numberOfSpecies;
  final String razorPayAPIKey;
  final Contact contact;

  Zoo(
      {this.city,
      this.organizationId,
      this.id,
      this.name,
      this.numberOfSpecies,
      this.razorPayAPIKey,
      this.contact});
}

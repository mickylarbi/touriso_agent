import 'package:touriso_agent/models/contact.dart';
import 'package:touriso_agent/models/services.dart';

// ignore: must_be_immutable
class Accommodation extends Services {
  String id;
  String companyId;
  String name;
  String? slogan;
  double rating;
  String description;
  Contact contact;

  Accommodation({
    required this.id,
    required this.companyId,
    required this.name,
    this.slogan,
    required this.rating,
    required this.description,
    required this.contact,
  });

  @override
  List<Object?> get props =>
      [id, companyId, name, slogan, rating, description, contact];
}

enum AccommodationType { hotel, guestHouse, apartment }

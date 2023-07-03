import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Site extends Equatable {
  String id;
  String name;
  String location;
  GeoPoint geoLocation;
  String description;
  List<String> imageUrls;

  Site({
    required this.id,
    required this.name,
    required this.location,
    required this.geoLocation,
    required this.description,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        geoLocation,
        description,
        imageUrls,
      ];
}

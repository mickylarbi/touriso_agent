import 'package:equatable/equatable.dart';
import 'package:touriso_agent/models/cduration.dart';

// ignore: must_be_immutable
class Activity extends Equatable {
  String id;
  String siteId;
  String name;
  CDuration duration;
  double price;
  String? location;
  String description;
  List<String> imageUrls;

  Activity({
    required this.id,
    required this.siteId,
    required this.name,
    required this.duration,
    required this.price,
    this.location,
    required this.description,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        duration,
        price,
        location,
        description,
      ];
}

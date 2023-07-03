import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Activity extends Equatable {
  String id;
  String name;
  Duration duration;
  double price;
  String location;
  String description;
  List<String> imageUrls;

  Activity({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.location,
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

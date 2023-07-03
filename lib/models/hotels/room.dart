import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Room extends Equatable {
  String id;
  String number;
  String description;
  List<String> imageUrls;
  double price;
  bool? booked;

  Room(
      {required this.id,
      required this.number,
      required this.description,
      required this.imageUrls,
      required this.price});

  @override
  List<Object?> get props => [id, number, description, imageUrls, price];
}

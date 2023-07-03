import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TravelAgency extends Equatable {
  String id;
  String name;
  String slogan;

  TravelAgency(this.id, this.name, this.slogan);

  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TravelRates extends Equatable {
  String id;
  TravelType type;
  String classs;
  double rate;

  TravelRates(this.id, this.type, this.rate, this.classs);

  @override
  List<Object?> get props => [id, type, rate, classs];
}

enum TravelType { bus, flight }

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CDuration extends Equatable {
  int value;
  String unit;

  CDuration(this.value, this.unit);

  @override
  List<Object?> get props => [value, unit];

  @override
  String toString() => '$value $unit';
}

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Company extends Equatable {
  String id;
  String name;
  String motto;
  String logoUrl;

  Company(this.id, this.name, this.motto, this.logoUrl);

  @override
  List<Object?> get props => [id, name, motto, logoUrl];
}

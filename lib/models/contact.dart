import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Contact extends Equatable {
  String phone;
  String email;

  Contact({required this.phone, required this.email});

  @override
  List<Object?> get props => [phone, email];
}

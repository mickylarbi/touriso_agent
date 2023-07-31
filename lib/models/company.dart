import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Company extends Equatable {
  String id;
  String name;
  String motto;
  String email;
  String logoUrl;

  Company(
      {this.id = '',
      required this.name,
      required this.motto,
      required this.email,
      required this.logoUrl});

  Company.fromFirebase(Map<String, dynamic> map, String companyId)
      : id = companyId,
        name = map['name'],
        motto = map['motto'],
        email = map['email'],
        logoUrl = map['logoUrl'];

  Map<String, dynamic> toFirebase() => {
        'name': name,
        'motto': motto,
        'email': email,
        'logoUrl': logoUrl,
      };

  @override
  List<Object?> get props => [id, name, motto, email, logoUrl];
}

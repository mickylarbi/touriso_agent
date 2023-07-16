import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Company extends Equatable {
  String id;
  String name;
  String motto;
  String logoUrl;

  Company(this.id, this.name, this.motto, this.logoUrl);

  Company.fromFirebase(Map<String, dynamic> map, String companyId)
      : id = companyId,
        name = map['name'],
        motto = map['motto'],
        logoUrl = map['logoUrl'];

  Map<String, dynamic> toFirebase() => {
        'name': name,
        'motto': motto,
        'logoUrl': logoUrl,
      };

  @override
  List<Object?> get props => [id, name, motto, logoUrl];
}

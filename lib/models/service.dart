import 'package:equatable/equatable.dart';

abstract class Service extends Equatable {
  const Service();
  const Service.fromFirebase();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Booking extends Equatable {
  String id;
  String clientId;
  String activityId;
  String companyId;
  DateTime dateTime;
  int numberOfPeople;
  bool checkedOut;

  Booking(
      {required this.id,
      required this.clientId,
      required this.activityId,
      required this.companyId,
      required this.dateTime,
      required this.numberOfPeople,
      this.checkedOut=false,});

  Booking.empty(
      {this.id = '',
      required this.clientId,
      required this.activityId,
      required this.companyId,
      required this.dateTime,
      required this.numberOfPeople,
      this.checkedOut=false,});

  Booking.fromFirebase(Map<String, dynamic> map, String bookingId)
      : id = bookingId,
        clientId = map['clientId'],
        activityId = map['activityId'],
        companyId = map['companyId'],
        dateTime = DateTime.fromMillisecondsSinceEpoch(
            (map['dateTime'] as Timestamp).millisecondsSinceEpoch),
        numberOfPeople = map['numberOfPeople']
        ,checkedOut=map['checkedOut']??false;

  Map<String, dynamic> toFirebase() => {
        'clientId': clientId,
        'activityId': activityId,
        'companyId': companyId,
        'dateTime': dateTime,
        'numberOfPeople': numberOfPeople,
        'checkedOut': checkedOut, 
      };

  @override
  List<Object?> get props => [];
}

import 'package:touriso_agent/models/cduration.dart';
import 'package:touriso_agent/models/service.dart';

// ignore: must_be_immutable
class Activity extends Service {
  String id;
  String siteId;
  String name;
  CDuration duration;
  double price;
  String? location;
  String description;
  List<String> imageUrls;

  Activity({
    required this.id,
    required this.siteId,
    required this.name,
    required this.duration,
    required this.price,
    this.location,
    required this.description,
    required this.imageUrls,
  });

  Activity.empty({
    this.id = '',
    this.siteId = '',
    required this.name,
    required this.duration,
    required this.price,
    required this.location,
    required this.description,
    this.imageUrls = const [],
  });

  Activity.fromFirebase(Map<String, dynamic> map, String activityId)
      : id = activityId,
        siteId = map['siteId'],
        name = map['name'],
        duration = CDuration.fromFirebase(map['duration'] as List),
        price = map['price'],
        location = map['location'],
        description = map['description'],
        imageUrls = map['imageUrls'] == null
            ? []
            : (map['imageUrls'] as List).map((e) => e.toString()).toList();

  Map<String, dynamic> toFirebase() => {
        'siteId': siteId,
        'name': name,
        'duration': duration.toFirebase(),
        'price': price,
        'location': location,
        'description': description,
        'imageUrls': imageUrls,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        duration,
        price,
        location,
        description,
      ];
}

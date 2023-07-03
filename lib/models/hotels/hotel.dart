import 'package:touriso_agent/models/hotels/accommodation.dart';
import 'package:touriso_agent/models/hotels/room.dart';

// ignore: must_be_immutable
class Hotel extends Accommodation {
  List<Room> rooms;

  Hotel({
    required this.rooms,
    required super.id,
    required super.companyId,
    required super.name,
    required super.rating,
    required super.description,
    super.slogan,
    required super.contact,
  });

  @override
  List<Object?> get props => [rooms, id, name, rating, description, slogan];
}

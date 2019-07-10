import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/date_format.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

// utility - convert a FB snapshot to  map that includes the doc id
Map<String, dynamic> snap2Map(DocumentSnapshot snap) {
  var m = Map<String, dynamic>();
  snap.data.forEach((k, v) => m[k] = v);
  m['id'] = snap.documentID;
//  print("Doc id ${snap.documentID}");
//  print("m = $m");
  return m;
}

@JsonSerializable()
class User {
  String email;
  @JsonKey(nullable: false)
  String id;

  User({this.email, this.id});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Course {
  @JsonKey(includeIfNull: false)
  String id;
  String name;
  // todo: Find out out to serialize custom field
  //GeoPoint location;
  Course({this.id, this.name});

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  factory Course.fromFirestore(String id, Map<String, dynamic> j) {
    return Course.fromJson(j)..id = id;
  }

  Map<String, dynamic> toJson() => _$CourseToJson(this);

  String toString() => "Course(id=$id, name=$name";
}

@JsonSerializable()
class CourseMap {
  Map<String, Course> courses;

  CourseMap(this.courses);

  factory CourseMap.fromJson(Map<String, dynamic> json) =>
      _$CourseMapFromJson(json);

  Map<String, dynamic> toJson() => _$CourseMapToJson(this);
}

// represents a booking of a tee time.
//
@JsonSerializable()
class Booking {
  String id;

  @JsonKey(nullable: false)
  String teeTimeRef;

  @JsonKey(nullable: false)
  // this is the id of the user that booked this slot.
  // They might not be playing.
  // The createdBY user can alter this reservation
  String createdBy;
  bool paid = false;
  // String list of players - also include the createdBy user
  // if they are playing. Any user in this list can cancel
  // themselves, but not the reservation.
  List<String> players = [];
  // Todo: Do we make guets a sentinel value??
  int guests = 0; // number of guests this player has invited

  Booking(
      this.teeTimeRef, this.createdBy, this.players, this.guests, this.paid);

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}

// A tee time consisting of a group of players, a time, a courseId.
@JsonSerializable()
class TeeTime {
  @JsonKey(nullable: false)
  String id;
  DateTime dateTime = DateTime.now();

  @JsonKey(nullable: false)
  String courseID;
  String notes;
  String startingHole;
  int availableSpots;
  // for speedy display - cache the names of the players.
  @JsonKey(nullable: false)
  List<String> playerNames = [];

  // List of booking id linked to this time
  @JsonKey(nullable: false)
  List<String> bookingRefs = [];

  TeeTime(
      {this.id,
      this.dateTime,
      this.courseID,
      this.notes = "",
      this.availableSpots: 4,
      this.startingHole: "1",
      this.playerNames = const [],
      this.bookingRefs = const []});

  factory TeeTime.fromJson(Map<String, dynamic> json) {
    //print("TeeTime.fromJson($json)  type=${json.runtimeType}");
    try {
      var x = _$TeeTimeFromJson(json);
      return x;
    } catch (e) {
      print("Ex $e");
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$TeeTimeToJson(this);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'models.g.dart';

// utility - convert a FB snapshot to  map that includes the doc id

Map<String, dynamic> snap2Map(DocumentSnapshot snap) {
  var m = Map<String, dynamic>();
  snap.data.forEach((k, v) => m[k] = v);
  m['id'] = snap.documentID;
  return m;
}

/// We have an object on every id.
class FireStoreObject {
  // The id is read, but is not written out to the object
  @JsonKey(ignore: true)
  String id;

  FireStoreObject();
}

@JsonSerializable()
class User extends FireStoreObject {
  String email;
  String displayName;

  User({this.email, this.displayName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static User currentUser(FirebaseUser user) =>
      User(email: user.email, displayName: user.displayName)..id = user.uid;
}

@JsonSerializable()
class Course extends FireStoreObject {
  String name;
  // todo: Find out out to serialize custom field
  //GeoPoint location;
  Course({this.name});

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);

  String toString() => "Course(id=$id, name=$name";
}

@JsonSerializable()
class CourseMap extends FireStoreObject {
  Map<String, Course> courses;

  CourseMap(this.courses);

  factory CourseMap.fromJson(Map<String, dynamic> json) =>
      _$CourseMapFromJson(json);

  Map<String, dynamic> toJson() => _$CourseMapToJson(this);
}

// represents a booking of a tee time.
//
@JsonSerializable()
class Booking extends FireStoreObject {
  @JsonKey(nullable: false)
  String teeTimeId;

  @JsonKey(nullable: false)
  String courseId;

  @JsonKey(nullable: false)
  // this is the id of the user that booked this slot.
  // They might not be playing.
  // The createdBY user can alter this reservation
  User createdById;
  bool paid = false;
  // Map of players.
  //- also include the createdBy user
  // if they are playing. Any user in this list can cancel
  // themselves, but not the reservation.
  Map<String, User> players = {};
  // Todo: Do we make guests a sentinel value??
  int guests = 0; // number of guests this player has invited

  Booking(
      {TeeTime teeTime,
      this.createdById,
      this.players,
      this.guests,
      this.paid}) {
    this.courseId = teeTime.courseID;
  }

  void addPlayer(User u) => players[u.id] = u;
  void addPlayers(List<User> users) => users.forEach((u) => addPlayer(u));

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}

// A tee time consisting of a group of players, a time, a courseId.
@JsonSerializable()
class TeeTime extends FireStoreObject {
  DateTime dateTime = DateTime.now();

  @JsonKey(nullable: false)
  String courseID;
  String notes;
  String startingHole;
  int availableSpots;
  // for speedy display - cache the names of the players.
  @JsonKey(nullable: false)
  Map<String, User> players = {};

  // List of booking id linked to this time
  @JsonKey(nullable: false)
  List<String> bookingRefs = [];

  TeeTime(
      {this.dateTime,
      this.courseID,
      this.notes = "",
      this.availableSpots: 4,
      this.startingHole: "1",
      this.players = const {},
      this.bookingRefs = const []});

  factory TeeTime.fromJson(Map<String, dynamic> json) {
    //print("TeeTime.fromJson($json)  type=${json.runtimeType}");
    // for debugging..
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

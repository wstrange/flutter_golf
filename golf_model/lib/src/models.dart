import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:uuid/uuid.dart';

part 'models.g.dart';

var _uuid = Uuid();

abstract class User implements Built<User, UserBuilder> {
  @nullable
  String get id;
  String get displayName;
  String get email;

  factory User([updates(UserBuilder b)]) = _$User;

  User._();

  static Serializer<User> get serializer => _$userSerializer;
}

abstract class Profile implements Built<Profile, ProfileBuilder> {
  // The uid of the user
  String get id;
  // todo: Add preferences, etc.

  factory Profile([updates(ProfileBuilder b)]) = _$Profile;

  Profile._();

  static Serializer<Profile> get serializer => _$profileSerializer;
}

//
//abstract class FullUser extends Object
//    with User
//    implements Built<FullUser, FullUserBuilder> {}

abstract class Course implements Built<Course, CourseBuilder> {
  @nullable
  String get id;
  String get name;
  // todo: Add firestore GeoPoint support
  //GeoPoint location;

  factory Course([updates(CourseBuilder b)]) = _$Course;

  Course._();

  static Serializer<Course> get serializer => _$courseSerializer;
}

abstract class TeeTime implements Built<TeeTime, TeeTimeBuilder> {
  @nullable
  String get id;
  DateTime get dateTime;
  String get courseId;
  @nullable
  String get notes;
  String get startingHole;
  int get availableSpots;
  // for speedy display - cache the names of the players.
  BuiltMap<String, User> get players;

  // List of booking id linked to this time
  BuiltList<String> get bookingRefs;

  factory TeeTime([updates(TeeTimeBuilder b)]) = _$TeeTime;

  TeeTime._();

  static Serializer<TeeTime> get serializer => _$teeTimeSerializer;

  // Generate a list of tee times for the given [courseId]
  // Tee times start at [startTime] end at [endTime] spaced apart by [Duration]
  static BuiltList<TeeTime> generateTeeTimes(
      {String courseId,
      DateTime startTime,
      DateTime endTime,
      Duration spacing = const Duration(minutes: 9)}) {
    // todo: More sanity checks..
    if (startTime.compareTo(endTime) >= 0)
      throw new Exception("Start time is after end time");

    var l = List<TeeTime>();

    var d = startTime;
    while (d.compareTo(endTime) <= 0) {
      var t = TeeTime((t) => t
        ..id = _uuid.v1()
        ..courseId = courseId
        ..dateTime = d
        ..availableSpots = 4
        ..startingHole = "1");
      l.add(t);
      d = d.add(spacing);
    }
    return BuiltList<TeeTime>(l);
  }
}

/// A booking (reservation) for a tee time.
/// A TeeTime could have more than one booking.
abstract class Booking implements Built<Booking, BookingBuilder> {
  String get id;
  String get teeTimeId;
  String get courseId;

  // this is the id of the user that booked this slot.
  // They might not be playing.
  // The createdBY user can alter this reservation
  User get createdByUser;

  @nullable
  bool get paid;
  // Map of players.
  //- also include the createdBy user, only
  // if they are playing. Any user in this list can cancel
  // themselves, but not the reservation. Only the createdBy user
  // can cancel the reservation
  BuiltMap<String, User> get players;

  factory Booking([updates(BookingBuilder b)]) = _$Booking;

  Booking._();

  static Serializer<Booking> get serializer => _$bookingSerializer;

  //tatic Booking createBooking({String courseId, String teeTimeId, User createdBy})
}

import 'package:aqgolf/aqgolf.dart';

class User extends ManagedObject<_User> implements _User {
  @override
  String toString() => "User(id=$id,email=$email)";
}

class _User {
  @primaryKey
  int id;

  @Column(unique: true)
  String email;

  /// Set of reservations this user has made
  //ManagedSet<Reservation> userReservations;

  ///
  /// Set of reservations this user is associated with
  /// They might not have *made* the booking.
  //ManagedSet<PlayersReservation> playerReservations;

  ManagedSet<TeeTime> playerTeeTimes;
  ManagedSet<TeeTime> bookedTeeTimes;


}
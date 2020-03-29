import 'package:aqueduct/aqueduct.dart';
import 'package:aqgolf/aqgolf.dart';

class TeeTime extends ManagedObject<_TeeTime> implements _TeeTime {
  @override
  void willUpdate() {
  }

  @override
  void willInsert() {
  }
}

class _TeeTime {
  @primaryKey
  int id;

  @Column(defaultValue: "4")
  int totalSpots = 4;
  @Column(defaultValue: "4")
  int remainingSpots = 4;

  @Column(defaultValue: "1")
  String startHole;

  DateTime dateTime;

  @Relate(#teeTimesForCourse)
  Course course;

  // Reservations on this tee time.
  //ManagedSet<Reservation> reservations;

  @Relate(#bookedTeeTimes)
  User bookedBy;
  @Relate(#playerTeeTimes)
  User player;


//  /// reservations on this tee time
//  ManagedSet<Reservation> reservations;

}
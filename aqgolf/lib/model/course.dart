import 'package:aqgolf/aqgolf.dart';

class Course extends ManagedObject<_Course> implements _Course {}

class _Course {
  @primaryKey
  int id;

  @Column(unique: false)
  String name;

  ManagedSet<TeeTime> teeTimesForCourse;
}
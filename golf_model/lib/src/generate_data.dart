/// Generate sample data
///
///

import '../model.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

generate_data(int num_users, int num_courses) {
  var users = List<User>();

  // add some users
  for (int i = 0; i < num_users; ++i) {
    users.add(User((u) => u
      ..id = "$i"
      ..displayName = "user$i"
      ..email = "user$i@example.com"));
  }

  print(users);

  // courses
  var courses = List<Course>();
  for (int i = 0; i < num_courses; ++i) {
    courses.add(Course((c) => c
      ..id = "$i"
      ..name = "Course$i"));
  }

  print(courses);

  // generate Tee Times
  var now = DateTime.now();
  var start = DateTime(now.year, now.month, now.day, 7);
  var end = DateTime(now.year, now.month, now.day, 17);
  var times =
      TeeTime.generateTeeTimes(courseId: "1", startTime: start, endTime: end);

  print("Tee times = $times");

  var firstTime = times.first;
  // Create a booking
  var b = Booking((b) => b
    ..id = uuid.v1()
    ..courseId = "Course1"
    ..teeTimeId = firstTime.id
    ..createdByUser = users[0].toBuilder());

  print("Booking $b");
}

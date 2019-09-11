/// Generate sample data
///
///

import 'models.dart';
import 'serializers.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void generateData(int numUsers, int numCourses) {
  var users = List<User>();

  // add some users
  for (int i = 0; i < numUsers; ++i) {
    users.add(User((u) => u
      ..id = "$i"
      ..displayName = "user$i"
      ..email = "user$i@example.com"));
  }

  print(users);

  // courses
  var courses = List<Course>();
  for (int i = 0; i < numCourses; ++i) {
    courses.add(Course((c) => c..name = "Course$i"));
  }

  print(courses);

  // generate Tee Times
  var now = DateTime.now();
  var start = DateTime(now.year, now.month, now.day, 7);
  var end = DateTime(now.year, now.month, now.day, 17);
  var times = TeeTime.generateTeeTimes(
      courseId: courses[0].id, startTime: start, endTime: end);

  print("Tee times = $times");

  //times.forEach( (t) => jsonSerializer.serialize)

  var players = {users[0].id: users[0]};

  var firstTime = times.first;
  // Create a booking
  var b = Booking((b) => b
    ..id = uuid.v1()
    ..courseId = courses[0].id
    ..teeTimeId = firstTime.id
    ..createdByUser = users[0].toBuilder()
    ..players.addAll(players));

  print("Booking $b");

  var s = jsonSerializer.serialize(b);

  var s2 = serializers.serialize(b);

  print("Serialized = $s2\n\njson format = $s");

  var ds = jsonSerializer.deserialize(s);

  print("Deserialized = $ds");

  assert(ds == b);
}

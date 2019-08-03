import 'package:golf_model/model.dart';
import 'package:test/test.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  test('First Test', () {
    var user = User((u) => u
      ..id = "user1"
      ..displayName = "foo"
      ..email = "foo@bar");

    var course = Course((c) => c
      ..name = "talons"
      ..id = "talons");

    expect(user.displayName, equals("foo"));
    var serialized = jsonSerializer.serialize(user);
    print("$serialized");
    var j = jsonSerializer.serializeWith(User.serializer, user);

    var booking = Booking((b) => b
      ..players = BuiltMap<String, User>().toBuilder()
      ..courseId = course.id
      ..teeTimeId = "1"
      ..createdByUser = user.toBuilder());

    j = jsonSerializer.serialize(booking);

    print("booking $booking to json = $j");
  });

  test("Serializes", () {});
}

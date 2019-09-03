import 'package:golf_proto/protos/golf.pbserver.dart';
import 'package:golf_proto/protos/google/protobuf/timestamp.pb.dart';
import 'package:test/test.dart';
import 'package:golf_proto/golf_proto.dart';

main() {
  test("proto test", () {
    var teeTime = TeeTime();
    teeTime.numberPlayers = 3;
    var now = DateTime.now().toUtc();
    var timeStamp = Timestamp.fromDateTime(now);
    teeTime.timeStamp = timeStamp;

    var m = teeTime.writeToJsonMap();
    var s = teeTime.writeToJson();

    print("Json map = $m\n json string = $s");

    var otherTeeTime = TeeTime.fromJson(s);

    expect(otherTeeTime, equals(teeTime));

    // make the instance immutable
    otherTeeTime.freeze();
    //should throw an exception if you attempt to update it
    expect(() => otherTeeTime.numberPlayers = 1, throwsUnsupportedError);

    expect(otherTeeTime.timeStamp.toDateTime(), equals(now));

    //print("local time = ${now.toLocal()}");
  });
}

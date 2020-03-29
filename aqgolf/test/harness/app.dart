import 'package:aqgolf/aqgolf.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:aqgolf/aqgolf.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:aqueduct/aqueduct.dart';

/// A testing harness for aqgolf.
///
/// A harness for testing an aqueduct application. Example test file:
///

class Harness extends TestHarness<AqgolfChannel> with TestHarnessORMMixin {

  static String TESTUSER1 = 'test1@foo.com';

  @override
  Future onSetUp() async {
    await resetData();
  }

  @override
  Future onTearDown() async {
    
  }
  // Seed is called before every test.
  @override
  Future seed() async {

    print("Seed called");
    var user   = await Query.insertObject(context, User()..email = TESTUSER1);

    var course = await Query.insertObject(context, Course()..name = "Country Hills Talons");

    var teeTime = TeeTime()
      ..course = course
      ..dateTime = DateTime.now()
      ..bookedBy = user
      ..player = user;

    var t = await Query.insertObject(context, teeTime);


  }

  @override
  ManagedContext get context => channel.context;
}

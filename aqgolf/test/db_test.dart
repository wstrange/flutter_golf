import 'harness/app.dart';
import 'package:test/test.dart';
import 'package:logging/logging.dart';


Future main() async {
  Logger.root.level = Level.INFO;

  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final harness = Harness()..install(restartForEachTest: false);


  test("GET /example returns 200 {'key': 'value'}", () async {
    expectResponse(await harness.agent.get("/example"), 200, body: {"key": "value"});
  });

  test("ORM", () async {
    var context = harness.context;
    var user = User();
    user.email = "test@foo.com";

    var r = await Query.insertObject(context, user);
    print("r = $r");

    var q = Query<User>(context);
    final allUsers = await q.fetch();

    allUsers.forEach((u) => print("User $u"));
  });

  test("Basict DB Test", () async {
    var context = harness.context;

    // Get the test user
    var q =  Query<User>(context)..where( (u) => u.email).equalTo( Harness.TESTUSER1 );
    var user = await q.fetchOne();
    expect( user.email, equals(Harness.TESTUSER1));

    // Find all the tee times created by the test user.
    var q2 = Query<TeeTime>(context)..where( (t) => t.bookedBy.id).equalTo(user.id);
    var teeTimes = await q2.fetch();
    expect(teeTimes.length, equals(1));

    // User is also playing on this tee time
    var q3 = Query<TeeTime>(context)..where( (t) => t.player.id ).equalTo(user.id);
    var teeTimes2 = await q3.fetch();
    expect(teeTimes2.length, equals(1));
    expect(teeTimes[0].id, equals(teeTimes2[0].id));

  });

}

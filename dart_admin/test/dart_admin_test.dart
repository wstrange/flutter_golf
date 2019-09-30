@TestOn('node')
import 'package:firebase_admin_interop/firebase_admin_interop.dart';
import 'setup.dart';

import 'package:test/test.dart';

main() {
  print("hello world");

  var app = initFirebaseApp();
  app.firestore().settings(FirestoreSettings(timestampsInSnapshots: true));

  group('$Firestore', () {
    test("write stuff", () async {
      var ref = app.firestore().document('foo/23');
      final data = new DocumentData.fromMap({
        'name': 'Firestore',
        'profile.url': "https://pic.com/123",
      });

      await ref.setData(data);
    });
  });
}

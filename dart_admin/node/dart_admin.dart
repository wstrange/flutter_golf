import 'dart:async';
import 'package:firebase_admin_interop/firebase_admin_interop.dart';

import 'package:node_interop/node.dart';
import 'package:node_interop/util.dart';
import 'dart:convert';

final Map env = dartify(process.env);

App initEmuluatorApp() => FirebaseAdmin.instance.initializeApp();

App initFirebaseApp() {
  if (!env.containsKey('FIREBASE_CONFIG') ||
      !env.containsKey('FIREBASE_SERVICE_ACCOUNT_JSON'))
    throw new StateError('Environment variables are not set.');

  Map certConfig = jsonDecode(env['FIREBASE_SERVICE_ACCOUNT_JSON']);
  final cert = FirebaseAdmin.instance.cert(
    projectId: certConfig['project_id'],
    clientEmail: certConfig['client_email'],
    privateKey: certConfig['private_key'],
  );
  final Map config = jsonDecode(env['FIREBASE_CONFIG']);
  //final databaseUrl = config['databaseURL'];
  return FirebaseAdmin.instance.initializeApp(new AppOptions(
    credential: cert, // databaseURL: databaseUrl
  ));
}

Future<void> main() async {
  //var app = initFirebaseApp();
  final serviceAccountKeyFilename = 'service-accounts/service-account.json';
  final admin = FirebaseAdmin.instance;
  final cert = admin.certFromPath(serviceAccountKeyFilename);
//  final app = admin.initializeApp(new AppOptions(
//      credential: cert, databaseURL: "https://flutterxgolf.firebaseio.com"));

  //final app = admin.initializeApp(new AppOptions(credential: cert));

  final app = admin.initializeApp();

  var ref = app.firestore().document('/foo/23');

  var snap = await ref.get();
  print("Snap = ${snap.data.keys}");

  // Write value to the database at "/test-path" location.
  final data = new DocumentData.fromMap({
    'name': 'Firestore',
    'profile.url': "https://pic.com/123",
  });

  await ref.setData(data);

  snap = await ref.get();

  print("Snap = ${snap.data.keys}");
}

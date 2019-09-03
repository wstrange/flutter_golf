import 'dart:async';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/firestore/v1.dart' as fs;

Future<void> main() async {
  final serviceAccountKeyFilename = '../service-accounts/service-account.json';

  var sa = File(serviceAccountKeyFilename).readAsStringSync();

  final _credentials = new ServiceAccountCredentials.fromJson(sa);

  print("Creds are $_credentials");

  const _SCOPES = [fs.FirestoreApi.CloudPlatformScope];

  var http_client = await clientViaServiceAccount(_credentials, _SCOPES);

  print("http = $http_client");

  fs.FirestoreApi api = fs.FirestoreApi(http_client);

  api.projects.databases.operations;
}

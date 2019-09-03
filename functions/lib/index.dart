import 'dart:async';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';

void main() {
  functions['onTeeTimeWrite'] = functions.firestore
      .document('/teeTimes/{teeTimeId}')
      .onWrite(teeTimeOnWrite);
}

FutureOr<void> teeTimeOnWrite(
    Change<DocumentSnapshot> change, EventContext context) {
  final data = change.after.data;
  final id = change.after.documentID;
  final ts = data.getTimestamp("dateTime").toDateTime();
  final c = data.toMap();

  print(
      "doc id = $id Change data = $c  ts = ${ts} ts type = ${ts.runtimeType}");

  //change.after.firestore.collection("/teeTimes");
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../util/date_format.dart' as util;
import 'dart:async';

final _teeTimeTransformer =
    StreamTransformer<QuerySnapshot, List<TeeTime>>.fromHandlers(
        handleData: (snapshot, sink) {
  var docSnaps = snapshot.documents;
  var teeTimes = docSnaps.map((doc) => TeeTime.fromSnapshot(doc)).toList();
  sink.add(teeTimes);
});

class TeeTimeService with ChangeNotifier {
  final Firestore _firestore;
  final FirebaseAuth _firebaseAuth;
  //final FirebaseUser _user;
  final _ymdFormatter = new DateFormat('yyyy-MM-dd');

  TeeSheet teeSheet;
  // Create the teeTime service. This is always done in the
  // the context of a current user.
  TeeTimeService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance,
        _firebaseAuth = auth ?? FirebaseAuth.instance;

  Stream<List<TeeTime>> getTeeTimes(String courseId, DateTime date) {
    var ref = _firestore.collection("teeTimes");

    var q = ref
        .where("courseID", isEqualTo: courseId)
        .where("yyyyMMdd", isEqualTo: util.dateToYearMonthDay(date))
        .orderBy("dateTime");

    return q.snapshots().transform(_teeTimeTransformer);
  }

  // Generate a list of empty tee times.
  Future<void> generateTeeTimes(
      String courseID, DateTime start, DateTime finish,
      {Duration increment: const Duration(minutes: 9)}) async {
    // todo: Check start < finish, doesnt span more than one day, etc.

    // develeopment aide:
    deleteTeeTimes(courseID, start, finish);

    var time = start.add(Duration(seconds: 0));
    while (time.compareTo(finish) <= 0) {
      var teeTime = TeeTime(dateTime: time, courseID: courseID);
      // insert into firestore
      var doc = await _firestore.collection("teeTimes").add(teeTime.toMap());
      time = time.add(increment);
    }
  }

  // Todo: This is not recommended from a client side app;
  Future<void> deleteTeeTimes(
      String courseID, DateTime start, DateTime finish) async {
    var q = _firestore
        .collection("teeTimes")
        .where("courseID", isEqualTo: courseID)
        .where("dateTime", isGreaterThanOrEqualTo: start)
        .where("dateTime", isLessThanOrEqualTo: finish);

    await q.getDocuments().then((snap) {
      snap.documents.forEach((dSnap) => _firestore
          .collection("teeTimes")
          .document(dSnap.documentID)
          .delete());
    });
  }

  Future<void> bookTeeTime(TeeTime teeTime, int slots) async {
    print("Book time $teeTime slots=$slots");
    var user = await _firebaseAuth.currentUser();

    teeTime.availableSpots -= slots;
    teeTime.playerIDs = [user.uid];

    _firestore
        .collection("teeTimes")
        .document(teeTime.id)
        .updateData(teeTime.toMap());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/models.dart';
import '../util/date_format.dart' as util;
import 'dart:async';

// Converts a stream of firestore doc snapshots to a list
// of TeeTimes
final _teeTimeTransformer =
    StreamTransformer<QuerySnapshot, List<TeeTime>>.fromHandlers(
        handleData: (snapshot, sink) {
          //snapshot.documents.forEach((doc) => print("Doc = ${doc.data}"));
          var docSnaps = snapshot.documents;
          var teeTimes = docSnaps
              .map((DocumentSnapshot doc) => TeeTime.fromJson(snap2Map(doc)))
              .toList();
          //print("Tee times = $teeTimes");
          sink.add(teeTimes);
        },
        handleDone: (sink) => print("Tee time transformer done"),
        handleError: (error, stacktrace, sink) =>
            print("** transformer error $error "));

final _bookingTransformer =
    StreamTransformer<QuerySnapshot, List<Booking>>.fromHandlers(
        handleData: (snapshot, sink) {
          snapshot.documents.forEach((doc) => print("Doc = ${doc.data}"));
          var docSnaps = snapshot.documents;
          var booking = docSnaps
              .map((DocumentSnapshot doc) => Booking.fromJson(snap2Map(doc)))
              .toList();
//print("Tee times = $teeTimes");
          sink.add(booking);
        },
        handleDone: (sink) => print("Tee time transformer done"),
        handleError: (error, stacktrace, sink) =>
            print("** transformer error $error "));

class TeeTimeService {
  final Firestore _firestore;
  final FirebaseAuth _firebaseAuth;
  //final FirebaseUser _user;
  // Create the teeTime service. This is always done in the
  // the context of a current user.
  TeeTimeService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance,
        _firebaseAuth = auth ?? FirebaseAuth.instance;

  Stream<List<TeeTime>> getTeeTimeStream(String courseId, DateTime date) {
    var ref = _firestore.collection("teeTimes");
    var d = util.dateToYearMonthDay(date);
    var start =
        DateTime(date.year, date.month, date.day, 0, 1).toIso8601String();
    var end =
        DateTime(date.year, date.month, date.day, 23, 59).toIso8601String();

    print("Get Stream for List of Tee Times courseId = $courseId, For $date");
    var q = ref
        .where("courseID", isEqualTo: courseId)
        .where("dateTime", isGreaterThanOrEqualTo: start)
        .where("dateTime", isLessThanOrEqualTo: end)
        .orderBy("dateTime");

    //var q = ref;
    //q.snapshots().listen((event) => print("${event.documents}"));

    return q.snapshots().transform(_teeTimeTransformer);
  }

  // Generate a list of empty tee times.
  Future<void> generateTeeTimes(
      String courseID, DateTime start, DateTime finish,
      {Duration increment: const Duration(minutes: 20)}) async {
    // todo: Check start < finish, doesnt span more than one day, etc.

    // develeopment aide:
    //deleteTeeTimes(courseID, start, finish);

    var time = start.add(Duration(seconds: 0));
    while (time.compareTo(finish) <= 0) {
      var teeTime = TeeTime(dateTime: time, courseID: courseID);
      // insert into firestore
      await _firestore.collection("teeTimes").add(teeTime.toJson());
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

  // Create a booking.
  Future<void> createBooking(Booking booking) async {
    try {
      print("Creating booking");
      var r = await _firestore.collection("booking").add(booking.toJson());
      var bid = r.documentID;
      print("booking created ${bid}");

      // todo: Update the tee time

    } catch (e) {
      print("Exception creating booking $e");
      throw e;
    }
  }

  Future<void> bookTeeTime(TeeTime teeTime, [int slots = 1]) async {
    print("Book time $teeTime slots=$slots");
    var user = await _firebaseAuth.currentUser();

    teeTime.availableSpots -= slots;

    assert(teeTime.id != null);
    var booking =
        Booking(teeTime.id, user.uid, {user.uid: user.displayName}, 0, true);

    var json = teeTime.toJson();
    print("Book $slots  payload = $json");

    try {
      print("Creating booking");
      var r = await _firestore.collection("booking").add(booking.toJson());
      var bid = r.documentID;
      print("booking created ${bid}");

      // update links in tee Time to this booking.
      teeTime.bookingRefs.add(bid);
      // This is wrong...
      // TODO: Fix me
      teeTime.playerNames.add(user.displayName);

      print("Updating teeTime ${teeTime.toJson()}");
      await _firestore
          .collection("teeTimes")
          .document(teeTime.id)
          .updateData(json);
    } catch (e) {
      print("Exception trying to update the teeTime $e");
      rethrow;
    }
  }

  findUserTeeTimes() async {
    var user = await _firebaseAuth.currentUser();
    _firestore
        .collection("teeTimes")
        .where("booking.${user.uid}", isGreaterThanOrEqualTo: 0);
  }

  // Return a stream of Bookings linked to this tee time
  Stream<List<Booking>> getBookingsForTeeTime(TeeTime teeTime) {
    print("Get stream bookings for ${teeTime.id}");
    assert(teeTime.id != null);
    var q = _firestore
        .collection("booking")
        .where("teeTimeRef", isEqualTo: teeTime.id);

    return q.snapshots().transform(_bookingTransformer);
  }

  // Cancel the entire booking
  // todo: This can be implemented partially by a trigger
  // so that the user cancelling does not need write access to the
  // teeTimes
  Future<void> cancelBooking(TeeTime t, Booking b) async {
    //var user = await _firebaseAuth.currentUser();
    var players = b.players.values.toList();
    //
    try {
      // first remove the booking from the tee times
      // todo: Make this a trigger
//      await _firestore.collection("teeTimes").document(t.id).updateData({
//        "bookingRefs": FieldValue.arrayRemove([b.id]),
//        "playerNames": FieldValue.arrayRemove(players)
//      });
      // now delete the booking
      await _firestore.collection("booking").document(b.id).delete();
      print("Canceled booking ${b.id}");
    } catch (e) {
      print("Exception $e");
    }
  }
}

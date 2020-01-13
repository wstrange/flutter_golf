import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import '../model/model.dart';
import 'dart:async';

import 'service_exception.dart';

final Logger log = new Logger('TeeTimeService');

// Converts a stream of firestore doc snapshots to a list
// of TeeTimes
final _teeTimeTransformer =
    StreamTransformer<QuerySnapshot, List<TeeTime>>.fromHandlers(
        handleData: (snapshot, sink) {
          // snapshot.documents.forEach((doc) => print("Doc = ${doc.data}"));
          var docSnaps = snapshot.documents;
          var teeTimes = docSnaps
              .map((DocumentSnapshot doc) =>
                  jsonSerializer.deserializeWith(TeeTime.serializer, doc.data))
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
              .map((DocumentSnapshot doc) =>
                  jsonSerializer.deserializeWith(Booking.serializer, doc.data))
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
  CollectionReference _teeTimeRef;

  TeeTimeService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance,
        _firebaseAuth = auth ?? FirebaseAuth.instance {
    _teeTimeRef = _firestore.collection("teeTimes");
  }

  Stream<List<TeeTime>> getTeeTimeStream(String courseId, DateTime date) {
    var start = DateTime(date.year, date.month, date.day, 0, 1);
    var end = DateTime(date.year, date.month, date.day, 23, 59);

    var ts = Timestamp.fromDate(start);
    var te = Timestamp.fromDate(end);

    log.fine(
        "Get Stream for List of Tee Times courseId = $courseId, For $date");
    var q = _teeTimeRef
        .where("courseId", isEqualTo: courseId)
        .where("dateTime", isGreaterThanOrEqualTo: ts)
        .where("dateTime", isLessThanOrEqualTo: te)
        .orderBy("dateTime");

    return q.snapshots().transform(_teeTimeTransformer);
  }
//
//  Future<List<TeeTime>> _getTeeTimeList(String courseId, DateTime date) async {
//    var start = DateTime(date.year, date.month, date.day, 0, 1);
//    var end = DateTime(date.year, date.month, date.day, 23, 59);
//
//    var ts = Timestamp.fromDate(start);
//    var te = Timestamp.fromDate(end);
//
//    log.fine("Get List of Tee Times courseId = $courseId, For $date");
//    var q = _teeTimeRef
//        .where("courseId", isEqualTo: courseId)
//        .where("dateTime", isGreaterThanOrEqualTo: ts)
//        .where("dateTime", isLessThanOrEqualTo: te)
//        .orderBy("dateTime");
//    var d = await q.getDocuments();
//
//    var docList = d.documents.map((doc) => _deserialize(doc)).toList();
//
//    return docList;
//  }

  Future<TeeTime> getTeeTime({Course course, DateTime date}) async {
    var ts = Timestamp.fromDate(date);

    var q = _teeTimeRef
        .where("courseId", isEqualTo: course.id)
        .where("dateTime", isEqualTo: ts);
    var doc = await q.getDocuments();

    // todo.. error check here..
    if (doc.documents.length != 1) {
      return null; // this is bogus..
    }
    return _deserialize(doc.documents.first);
  }

  Future<TeeTime> getTeeTimeById(String id) async {
    var doc = await _teeTimeRef.document(id).get();
    // todo: fix
    if (doc == null || doc.data.isEmpty) return null;
    return _deserialize(doc);
  }

  TeeTime _deserialize(DocumentSnapshot doc) =>
      jsonSerializer.deserializeWith(TeeTime.serializer, doc.data);

  // Generate a list of empty tee times.
  Future<void> genTeeTimes(Course course,
      {DateTime start,
      DateTime finish,
      Duration increment: const Duration(minutes: 20)}) async {
    // todo: Check start < finish, doesnt span more than one day, etc.

    if (start == null) start = DateTime.now();
    if (finish == null) finish = start.add(Duration(hours: 8));

    var times = TeeTime.generateTeeTimes(
        courseId: course.id,
        startTime: start,
        endTime: finish,
        spacing: increment);
    times.forEach((teeTime) async {
      //log.fine("Add teetime $teeTime");
      var json = jsonSerializer.serializeWith(TeeTime.serializer, teeTime);
      log.fine("Tee time json =$json");
      await _firestore
          .collection("teeTimes")
          .document(teeTime.id)
          .setData(json);
    });
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
      log.fine("Creating booking");
      await _firestore
          .collection("booking")
          .document(booking.id)
          .setData(jsonSerializer.serializeWith(Booking.serializer, booking));
      log.fine("booking created ${booking.id}");
      // todo update the tee time

    } catch (e) {
      log.fine("Exception creating booking $e");
      throw e;
    }
  }

  Future<void> bookTeeTime(TeeTime teeTime, User user, [int slots = 1]) async {
    log.fine("Book time $teeTime slots=$slots  user=$user");

    var booking = Booking((b) => b
      ..players.addAll({user.id: user})
      ..createdByUser = user.toBuilder()
      ..courseId = teeTime.courseId
      ..paid = true
      ..teeTimeId = teeTime.id);

    await createBooking(booking);

    // todo: Are we better off just reading / updating the entire doc..
    // This has to run server side eventually..
    log.fine("Updating teeTime id ${teeTime.id}");

//    await _firestore.collection("teeTimes").document(teeTime.id).updateData({
//      "bookingRefs": FieldValue.arrayUnion([booking.id],
//       :  jsonSerializer.serializeWith(User.serializer, user)
//    });

    var teeRef = _firestore.collection("teeTimes").document(teeTime.id);
    var doc = await teeRef.get();
    var tt = jsonSerializer.deserializeWith(TeeTime.serializer, doc.data);

    log.fine("got teeTime $tt");
    var nt = tt.rebuild((t) => t
      ..bookingRefs.addAll([booking.id])
      ..availableSpots = tt.availableSpots - 1
      ..players.addAll({user.id: user}));

    log.fine("Updated time = $nt");

    await teeRef.setData(jsonSerializer.serializeWith(TeeTime.serializer, nt));
  }

  findUserTeeTimes() async {
    var user = await _firebaseAuth.currentUser();
    _firestore
        .collection("teeTimes")
        .where("booking.${user.uid}", isGreaterThanOrEqualTo: 0);
  }

  // Return a stream of Bookings linked to this tee time
  Stream<List<Booking>> getBookingsStreamForTeeTime(TeeTime teeTime) {
    log.fine("Get stream bookings for ${teeTime.id}");
    assert(teeTime.id != null);
    var q = _firestore
        .collection("booking")
        .where("teeTimeId", isEqualTo: teeTime.id);

    return q.snapshots().transform(_bookingTransformer);
  }

  // Return a list of bookings for this tee time
  Future<List<Booking>> getBookingsForTeeTime(TeeTime teeTime) async {
    log.fine("Get bookings for ${teeTime.id}");
    assert(teeTime.id != null);
    var q = _firestore
        .collection("booking")
        .where("teeTimeId", isEqualTo: teeTime.id);

    var docs = await q.getDocuments();

    return docs.documents
        .map((doc) =>
            jsonSerializer.deserializeWith(Booking.serializer, doc.data))
        .toList(growable: false);
  }

  // Cancel the entire booking
  // todo: This can be implemented partially by a trigger
  // so that the user cancelling does not need write access to the
  // teeTimes
  Future<void> cancelBooking(TeeTime teeTime, Booking b) async {
    // TODO: Move this to the server
    // Create updates to the teeTime.
    var updates = {
      // remove the booing reference
      "bookingRefs": FieldValue.arrayRemove([b.id]),
      // the number of spots gets increased by the number of cancelled players
      "availableSpots": teeTime.availableSpots + b.players.keys.length,
    };

    // The cancelled players are removed from the teeTime players map
    b.players.keys.forEach(
        (playerId) => updates["players.$playerId"] = FieldValue.delete());

    try {
      // first remove the booking from the tee times

      // todo: Make this a trigger
      await _firestore
          .collection("teeTimes")
          .document(b.teeTimeId)
          .updateData(updates);
      // now delete the booking
      await _firestore.collection("booking").document(b.id).delete();
      log.fine("Canceled booking ${b.id}");
    } catch (e) {
      log.fine("Exception $e");
    }
  }

  StreamSubscription<QuerySnapshot> _docSnaps;

  // Listen to updates for course on the given date
  // Update the list provided by adding, removing, or updating items
  // TODO: This could be smarter aboout caching the stream and
  // not causing firebase to reread the doc. Stay subscribed
  // appears as if FB is smart enough to not reread??
  void subscribeTeeTimeListUpdates(
      String courseId, DateTime date, List<TeeTime> list) {
    var start = DateTime(date.year, date.month, date.day, 0, 1);
    var end = DateTime(date.year, date.month, date.day, 23, 59);

    var ts = Timestamp.fromDate(start);
    var te = Timestamp.fromDate(end);
    // todo: check for the date / course being the same.
    // query does not implement equals, so we can't compare it.

    log.fine("Subscribe to Tee Times for courseId = $courseId, For $date");
    var q = _teeTimeRef
        .where("courseId", isEqualTo: courseId)
        .where("dateTime", isGreaterThanOrEqualTo: ts)
        .where("dateTime", isLessThanOrEqualTo: te)
        .orderBy("dateTime");

    if (_docSnaps != null) {
      log.fine("Cancelling previous stream");
      _docSnaps.cancel();
      list.clear();
    }

    _docSnaps = q.snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((docChange) {
        var t = _deserialize(docChange.document);
        switch (docChange.type) {
          case DocumentChangeType.added:
            list.add(t);
            break;
          case DocumentChangeType.removed:
            list.remove(t);
            break;
          case DocumentChangeType.modified:
            log.fine("Document modified $t  ${docChange}");
            int i = list.indexWhere((l) => l.id == t.id);
            if (i == -1) {
              throw ServiceException("List did not contain document");
            }
            list[i] = t;
        }
      });
    });
  }
}

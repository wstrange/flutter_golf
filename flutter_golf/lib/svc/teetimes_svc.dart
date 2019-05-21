import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class TeeTimeService with ChangeNotifier {
  final Firestore _firestore;
  //final FirebaseUser _user;
  final _ymdFormatter = new DateFormat('yyyy-MM-dd');

  TeeSheet teeSheet;
  // Create the teeTime service. This is always done in the
  // the context of a current user.
  TeeTimeService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance;
  //_firebaseAuth = auth ?? FirebaseAuth.instance;

  Future<DocumentReference> createTeetime(FSTeetime teetime) async {
    var docRef = await _firestore.collection("teetimes").add(teetime.data);
    // todo
    return docRef;
  }

  Future<TeeSheet> refreshTeeSheet(String course, DateTime date) async {
    var t = _ymdFormatter.format(date);
    var doc = _firestore
        .collection("courses")
        .document(course)
        .collection("teeSheet")
        .document(t);
    print("$course  date=$t");
    print("Getting doc = $doc");
    var m = await doc.get();

    teeSheet = TeeSheet.fromMap(m.data);

    notifyListeners();
    return teeSheet;
  }

  Stream<DocumentSnapshot> getTeeSheetStream(String courseID, DateTime date) {
    var t = _ymdFormatter.format(date);
    var doc = _firestore
        .collection("courses")
        .document(courseID)
        .collection("teeSheet")
        .document(t);
    var s = doc.snapshots();
    print("returning stream $s for ${doc.toString()}");
    return s;
    //StreamTransformer.fromHandlers( handleData: );
    //return doc.snapshots().map((snap) => TeeSheet.fromMap(snap.data));
  }

  Future<void> generateSampleData() async {
    var course = "ECS1WnnFLNrn2wPe8WUc";

    var teeSheets = _firestore
        .collection("courses")
        .document(course)
        .collection("teeSheet");
    var t = TeeSheet.empty(DateTime.now());

    // create a t sheet
    teeSheets
        .document(_ymdFormatter.format(t.date))
        .setData({"teeTimes": t.teeTimesAsFirebaseMap()});
  }
}

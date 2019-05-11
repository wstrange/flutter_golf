import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TeetimeService with ChangeNotifier {
  final Firestore _firestore;
  //final FirebaseUser _user;
  final _ymdFormatter = new DateFormat('yyyy-MM-dd');
  Map<dynamic, dynamic> teeSheet = {};

  // Create the teeTime service. This is always done in the
  // the context of a current user.
  TeetimeService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance;
  //_firebaseAuth = auth ?? FirebaseAuth.instance;

  Future<DocumentReference> createTeetime(FSTeetime teetime) async {
    var docRef = await _firestore.collection("teetimes").add(teetime.data);
    return docRef;
  }

  Future<Map<dynamic, dynamic>> updateTeesSheet(
      String course, DateTime date) async {
    var t = _ymdFormatter.format(date);
    var doc = _firestore
        .collection("courses")
        .document(course)
        .collection("teesheet")
        .document(t);
    print("$course  date=$t");
    print("Getting doc = $doc");
    var m = await doc.get();
    var d2 = _firestore
        .document("/courses/ECS1WnnFLNrn2wPe8WUc/teesheet/2019-05-05");
    var m2 = await d2.get();

    // todo: Convert this to a model
    var xx = m.data;

    teeSheet = xx['teetimes'];
    print("Tee sheet is $teeSheet m2 = ${m2.data}");
    if (teeSheet == null) teeSheet = {};
    notifyListeners();
    return teeSheet;
  }
}

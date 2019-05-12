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

  TeeSheet teeSheet;
  // Create the teeTime service. This is always done in the
  // the context of a current user.
  TeetimeService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance;
  //_firebaseAuth = auth ?? FirebaseAuth.instance;

  Future<DocumentReference> createTeetime(FSTeetime teetime) async {
    var docRef = await _firestore.collection("teetimes").add(teetime.data);
    return docRef;
  }

  Future<TeeSheet> refreshTeeSheet(String course, DateTime date) async {
    var t = _ymdFormatter.format(date);
    var doc = _firestore
        .collection("courses")
        .document(course)
        .collection("teesheet")
        .document(t);
    print("$course  date=$t");
    print("Getting doc = $doc");
    var m = await doc.get();

    // todo: Convert this to a model
    teeSheet = TeeSheet.fromJSON(m.data['teetimes']);

    notifyListeners();
    return teeSheet;
  }
}

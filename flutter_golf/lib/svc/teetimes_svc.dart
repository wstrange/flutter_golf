import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/models.dart';

class TeetimeService {

  final Firestore _firestore;
  //final FirebaseAuth _firebaseAuth;
  final FirebaseUser _user;

  // Create the teeTime service. This is always done in the
  // the context of a current user.
  TeetimeService(this._user, {Firestore firestore,FirebaseAuth auth }) :
        _firestore = firestore ?? Firestore.instance;
       //_firebaseAuth = auth ?? FirebaseAuth.instance;


  Future<DocumentReference> createTeetime(Teetime teetime) async {
    var docRef = await _firestore.collection("teetimes").add(teetime.data);
    return docRef;
  }


}
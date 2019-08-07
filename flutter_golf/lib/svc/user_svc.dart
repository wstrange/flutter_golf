import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final Firestore _firestore;

  // Create the teeTime service. This is always done in the
  // the context of a current user.
  UserService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance;
}

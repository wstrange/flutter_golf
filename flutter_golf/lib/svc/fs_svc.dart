import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "teetimes_svc.dart";
import "user_svc.dart";
import "course_svc.dart";

// Firestore services
class FireStore {
  final Firestore _firestore;
  final FirebaseAuth _auth;
  final TeeTimeService teeTimeService;
  final UserService userService;
  final CourseService courseService;

  FireStore({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        teeTimeService = TeeTimeService(firestore: firestore, auth: auth),
        userService = UserService(firestore: firestore, auth: auth),
        courseService = CourseService(firestore: firestore, auth: auth);
}

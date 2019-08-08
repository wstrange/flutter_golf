import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "teetimes_svc.dart";
import "profile_svc.dart";
import "course_svc.dart";
import 'user_svc.dart';
import '../model/model.dart';

// Firestore services
class FireStore {
  final Firestore _firestore;
  final FirebaseAuth _auth;
  final TeeTimeService teeTimeService;
  final ProfileService profileService;
  final CourseService courseService;
  final UserService userService;

  FireStore({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        teeTimeService = TeeTimeService(firestore: firestore, auth: auth),
        profileService = ProfileService(firestore: firestore, auth: auth),
        userService = UserService(firebaseAuth: auth, firestore: firestore),
        courseService = CourseService(firestore: firestore, auth: auth);

  // This is not correct  / complete..
  // https://firebase.google.com/docs/firestore/solutions/delete-collections
  deleteCollection(String c) async {
    var ref = _firestore.collection(c);
    var d = await ref.orderBy('__name__').limit(100).getDocuments();
    d.documents.forEach((doc) async {
      await _firestore.collection(c).document(doc.documentID).delete();
    });
  }

  createSampleData() async {
    var now = DateTime.now();
    var t = DateTime(now.year, now.month, now.day, 7);
    // Generate a sample course;

    var name = "Country Hills Talons";

    try {
      // If the course exists - dont recreate it.
      var course = await courseService.getCourseByName(name);
      if (course == null) {
        course = Course((c) => c..name = name);
        await courseService.createCourse(course);
      }

      // delete tee time
      await deleteCollection("/teeTimes");

      await teeTimeService.genTeeTimes(course, start: t);

      // get the first teeTime
      await teeTimeService.getTeeTimes(course, t);
    } catch (e) {
      print("Exception creating sample data $e");
      rethrow;
    }
  }
}

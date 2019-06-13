import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/models.dart';
import 'package:intl/intl.dart';

class CourseService {
  final Firestore _firestore;
  Course _selectedCourse;

  TeeSheet teeSheet;

  // Create the teeTime service. This is always done in the
  // the context of a current user.
  CourseService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance;

  // Gets the course list as a stream - watches for modifications.
  Stream<List<Course>> getCoursesStream() {
    var ref = _firestore.collection("courses");
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Course.fromMap(doc.documentID, doc.data))
        .toList());
  }

  // Gets the Course list, but does not watch for additions.
  Future<List<Course>> getCoursesList() async {
    var ref = _firestore.collection("courses");
    var docs = await ref.getDocuments();
    return docs.documents
        .map((snapshot) => Course.fromMap(snapshot.documentID, snapshot.data))
        .toList();
  }

  // Todo: What if course does not exist?
  Future<Course> getCourse(String courseId) async {
    var ref = _firestore.collection("courses");
    var snap = await ref.document(courseId).get();
    if (snap.exists) return Course.fromMap(snap.documentID, snap.data);
    return null;
  }
}

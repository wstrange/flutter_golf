import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/model.dart';

class CourseService {
  final Firestore _firestore;
  // Create the teeTime service. This is always done in the
  // the context of a current user.
  CourseService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance;

  // Gets the course list as a stream - watches for modifications.
  Stream<List<Course>> getCoursesStream() {
    var ref = _firestore.collection("courses");
//    return ref.snapshots().map(
//        (list) => list.documents
//        //.map((doc) => Course.fromJson(doc.data)..id = doc.documentID)
//        ,
//        map((doc) => jsonSerializer.deserialize(doc)).toList());

    return ref.snapshots().map((courseList) => courseList.documents.map(
        (snap) =>
            jsonSerializer.deserializeWith(Course.serializer, snap.data)));
  }

  // Gets the Course list, but does not watch for additions.
  Future<List<Course>> getCoursesList() async {
    var ref = _firestore.collection("courses");
    var docs = await ref.getDocuments();

    try {
      return docs.documents.map((doc) {
        print("doc data = ${doc.data}");
        return jsonSerializer.deserializeWith(Course.serializer, doc.data);
      }).toList();
    } catch (e) {
      print("Exception getting courses $e");
    }
  }

  // Todo: What if course does not exist?
  Future<Course> getCourse(String courseId) async {
    var ref = _firestore.collection("courses");
    var doc = await ref.document(courseId).get();
    if (doc.exists)
      return jsonSerializer.deserializeWith(Course.serializer, doc.data);
    return null;
  }

  Future<void> createCourse(Course course) async {
    await _firestore
        .collection("courses")
        .document(course.id)
        .setData(jsonSerializer.serialize(course));
  }
}

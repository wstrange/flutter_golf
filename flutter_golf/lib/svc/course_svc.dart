import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/model.dart';

class CourseService {
  final Firestore _firestore;
  // Create the teeTime service. This is always done in the
  // the context of a current user.
  CourseService({Firestore firestore, FirebaseAuth auth})
      : _firestore = firestore ?? Firestore.instance;

  // Gets the course list as a stream
  // This should be a query scoped to what the user should see
  // e.g. - favorities, or geo location within a region etc.
  Stream<List<Course>> getCoursesStream() {
    var ref = _firestore.collection("courses");
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
        .setData(jsonSerializer.serializeWith(Course.serializer, course));
  }

  Future<Course> getCourseByName(String name) async {
    var d = await _firestore
        .collection("courses")
        .where("name", isEqualTo: name)
        .getDocuments();

    // Doesnt look like the doc is there, or
    if (d == null || d.documents == null) return null;

    // todo: lame
    if (d.documents.length != 1)
      throw new Exception("Expecting only one course with name $name");

    return jsonSerializer.deserializeWith(
        Course.serializer, d.documents[0].data);
  }
}

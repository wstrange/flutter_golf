import "package:cloud_firestore/cloud_firestore.dart";
import '../model/models.dart';
import 'package:intl/intl.dart';

// Do stuff to the repo
class RepoService {
  final _ymdFormatter = new DateFormat('yyyy-MM-dd');

  Firestore _firestore = Firestore.instance;

  Future<void> generateSampleData() async {
    var course = "ECS1WnnFLNrn2wPe8WUc";

    var teeSheets = _firestore
        .collection("courses")
        .document(course)
        .collection("teesheet");

    var date = DateTime.now();
    // create a t sheet
    teeSheets
        .document(_ymdFormatter.format(date))
        .setData({"teetimes": emptyTeeSheet()});
  }

  Map<String, String> emptyTeeSheet() {
    var ref = "available";
    var m = Map<String, String>();
    for (int hour = 7; hour <= 18; ++hour) {
      for (int min = 0; min < 60; min += 10) {
        var t =
            hour.toString().padLeft(2, "0") + min.toString().padLeft(2, "0");
        m[t] = ref;
      }
    }

    return m;
  }

  Future<Map<String, DocumentReference>> loadTeeSheet(
      String courseID, DateTime date) async {
    var d = _ymdFormatter.format(date);

    var ts = _firestore
        .collection("courses")
        .document(courseID)
        .collection("teesheet");

    var snapshot = await ts.document(d).get();

    if (snapshot.exists) {
      return snapshot.data['teetimes'];
    }
    return null;
  }
}

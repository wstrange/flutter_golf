import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String email;
  String id;

  User({this.email, this.id});
}

class Course {
  String id;
  String name;
  GeoPoint location;
  Map<DateTime, TeeSheet> teeSheets = {};
  Course({this.id, this.name});

  factory Course.fromMap(Map<String, dynamic> m) {
    return Course(name: m['name'], id: m['id']);
  }
}

class TeeSheet {
  static final available = Firestore.instance.document("/teetimes/available");
  String courseID;
  DateTime date = DateTime.now();
  Map<DateTime, DocumentReference> teeTimes = {};

  TeeSheet({this.teeTimes, this.date});

  factory TeeSheet.fromMap(Map m) {
    //print("TeeSheet from map $m");
    var x = m['teeTimes'];

    var newmap = Map<DateTime, DocumentReference>();

    x.forEach((date, v) {
      var d = DateTime.parse(date);
      newmap[d] = v as DocumentReference;
    });

    var ts = TeeSheet(teeTimes: newmap);
    print("Created TeeSheet $ts");
    return ts;
  }

  // make an empty tee sheet for the date.
  factory TeeSheet.empty(DateTime d) {
    var t = TeeSheet(teeTimes: _emptyTeeSheet(d), date: d);
    return t;
  }

  static Map<DateTime, DocumentReference> _emptyTeeSheet(DateTime d) {
    // first tee time at 7 AM
    var t = DateTime(d.year, d.month, d.day, 7, 0);
    // last tee time
    var end = DateTime(d.year, d.month, d.day, 18, 1);
    var increment = Duration(minutes: 9);

    var m = Map<DateTime, DocumentReference>();
    while (t.isBefore(end)) {
      m[t] = available;
      t = t.add(increment);
    }
    return m;
  }

  Map<String, DocumentReference> teeTimesAsFirebaseMap() =>
      teeTimes.map((date, ref) => MapEntry(date.toIso8601String(), ref));

  String toString() => "TeeSheet date=$date, teeTimes = $teeTimes";
}

// A tee time consisting of a group of players, a time, a courseId.
class Teetime {
  String id;
  String bookedByUserID;
  DateTime time = DateTime.now();
  List<String> playerIDs = [];
  String courseID;
  String description;

  Teetime({this.id});
}

// Firestore specific ...

class FSTeetime {
  DocumentReference createdBy;
  List<DocumentReference> players;
  Timestamp time;
  DocumentReference course;

  FSTeetime(FirebaseUser creator) {
    createdBy = Firestore.instance.collection("users").document(creator.uid);
  }

  void addPlayer(DocumentReference player) {
    if (!players.contains(player)) players.add(player);
  }

  void removePlayer(DocumentReference player) {
    players.remove(player);
  }

  void setCourse(String ref) {
    course = Firestore.instance.collection("courses").document(ref);
  }

  Map<String, dynamic> get data => {
        'createdBy': createdBy,
        'players': players,
        'time': time,
        'course': course
      };
}

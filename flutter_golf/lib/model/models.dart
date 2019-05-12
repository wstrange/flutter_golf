import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String email;
  String id;
}

class Course {
  String id;
  String name;
  GeoPoint location;
  Map<DateTime, TeeSheet> teeSheets = {};
}

class TeeSheet {
  Map<DateTime, String> teeTimes = {};
  TeeSheet(this.teeTimes);

  factory TeeSheet.fromJSON(Map m) {
    var newmap = Map<DateTime, String>();
    var inc = Duration(minutes: 9);
    var n = DateTime.now();
    m.forEach((k, v) {
      var hour = (k as String).substring(0, 2);
      var min = (k as String).substring(2);
      var h = int.parse(hour);
      var m = int.parse(min);
      var d = DateTime(2019, 06, 30, h, m);
      newmap[d] = v.toString();
      n.add(inc);
    });
    return TeeSheet(newmap);
  }
}

class Teetime {
  String bookedByUserID;
  DateTime time = DateTime.now();
  List<String> playerIDs = [];
  String courseID;
  String description;
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

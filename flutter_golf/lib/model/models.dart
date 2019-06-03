import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/date_format.dart';

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

  Map<String, DocumentReference> teeTimesAsFirebaseMap() =>
      teeTimes.map((date, ref) => MapEntry(date.toIso8601String(), ref));

  String toString() => "TeeSheet date=$date, teeTimes = $teeTimes";
}

// represents the playerInfo subcollection
class PlayerInfo {
  String uid;
  bool paid = false;
  String displayName; // so we dont have to look up on uid?
}

// A tee time consisting of a group of players, a time, a courseId.
class TeeTime {
  String id;
  DateTime dateTime = DateTime.now();
  Map<String, PlayerInfo> playerInfo = {};
  List<String> playerIDs = [];
  String courseID;
  String notes;
  String startingHole;
  int availableSpots;

  TeeTime(
      {this.id,
      this.dateTime,
      this.playerIDs: const [],
      this.courseID,
      this.notes,
      this.availableSpots: 4,
      this.startingHole: "1"});

  factory TeeTime.fromMap(String id, Map<String, Object> m) {
    return TeeTime(
        id: id,
        dateTime: (m['dateTime'] as Timestamp).toDate(),
        courseID: m['courseID'],
        notes: m['notes'],
        availableSpots: m['availableSpots'] as int,
        startingHole: m['startingHole']);
  }

  factory TeeTime.fromSnapshot(DocumentSnapshot doc) {
    return TeeTime.fromMap(doc.documentID, doc.data);
  }

  Map<String, Object> toMap() {
    return {
      'dateTime': Timestamp.fromDate(dateTime),
      'courseID': courseID,
      'playerIDs': playerIDs,
      'notes': notes,
      'yyyyMMdd': dateTo_yyyyMMdd(dateTime),
      'availableSpots': availableSpots,
      'startingHole': startingHole
    };
  }
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

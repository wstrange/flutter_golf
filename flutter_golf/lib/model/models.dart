import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Course.fromMap(String id, Map<String, dynamic> m) {
    // todo: Why is this being called over and over...
    print("Make course from $m");
    return Course(id: id, name: m['name']);
  }

  String toString() => "Course(id=$id, name=$name";
}

class TeeSheet {
  static final available = Firestore.instance.document("/teetimes/available");
  String courseID;
  DateTime date = DateTime.now();
  Map<DateTime, DocumentReference> teeTimes = {};

  TeeSheet({this.teeTimes, this.date});

  factory TeeSheet.fromMap(Map m) {
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
  // map to subcollection - if we use subcollections...
  Map<String, PlayerInfo> playerInfo = {};
  List<String> playerIDs = []; // id of players
  // This is an optimization - so we dont need to fetch the associated ids..
  List<String> playerDisplayNames = []; // names of players for display
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
      this.startingHole: "1",
      this.playerDisplayNames});

  factory TeeTime.fromMap(String id, Map<String, Object> m) {
    return TeeTime(
        id: id,
        dateTime: (m['dateTime'] as Timestamp).toDate(),
        courseID: m['courseID'],
        notes: m['notes'],
        availableSpots: m['availableSpots'] as int,
        startingHole: m['startingHole'],
        playerDisplayNames: m['playerDisplayNames'] as List<String>);
  }

  factory TeeTime.fromSnapshot(DocumentSnapshot doc) {
    return TeeTime.fromMap(doc.documentID, doc.data);
  }

  Map<String, Object> toMap() {
    return {
      'dateTime': Timestamp.fromDate(dateTime),
      'courseID': courseID,
      'playerIDs': playerIDs,
      'playerDisplayNames': playerDisplayNames,
      'notes': notes,
      'yyyyMMdd': dateToYearMonthDay(dateTime),
      'availableSpots': availableSpots,
      'startingHole': startingHole
    };
  }
}

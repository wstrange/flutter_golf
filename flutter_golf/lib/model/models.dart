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
  Course({this.id, this.name});

  factory Course.fromMap(String id, Map<String, dynamic> m) {
    // todo: Why is this being called over and over...
    //print("Make course from $m");
    return Course(id: id, name: m['name']);
  }

  String toString() => "Course(id=$id, name=$name";
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
    // nasty. Firestore returns List<dynamic>. Find out
    // better way to serialize.
    List<String> dn = m['playerDisplayNames'] != null
        ? List<String>.from(m['playerDisplayNames'])
        : [];

    return TeeTime(
      id: id,
      dateTime: (m['dateTime'] as Timestamp).toDate(),
      courseID: m['courseID'],
      notes: m['notes'],
      availableSpots: m['availableSpots'] as int,
      startingHole: m['startingHole'],
      playerDisplayNames: dn,
    );
  }

  factory TeeTime.fromSnapshot(DocumentSnapshot doc) {
    // print("Build TeeTime ${doc.documentID}");
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

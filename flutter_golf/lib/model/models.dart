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
  Map<DateTime,Teesheet> teeSheets = {};

}

class Teesheet {
  String courseID;
  Map<DateTime,String> teeTimes = {};
}

class Teetime {
  String bookedByUserID;
  DateTime time = DateTime.now();
  List<String> playerIDs = [];
  String  courseID;
  String  description;
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
    if( ! players.contains(player))
      players.add(player);
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

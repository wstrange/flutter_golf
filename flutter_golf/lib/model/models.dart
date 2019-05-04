import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String email;
  String id;
}

class Course {
  String id;
  String name;
}

//
//class Teetime {
//  String bookedByUserID;
//  DateTime _time = DateTime.now();
//  List<String> playerIDs = [];
//  String  courseID;
//  String description;
//}
//

// Firestore specific ...

class Teetime {
  DocumentReference createdBy;
  List<DocumentReference> players;
  Timestamp time;
  DocumentReference course;

  Teetime(FirebaseUser creator) {
    createdBy = Firestore.instance.collection("users").document(creator.uid);
  }

  void addPlayer(DocumentReference player) {
    if( ! players.contains(player))
      players.add(player);
  }

  void removePlayer(DocumentReference player) {
    players.remove(player);
  }

  Map<String, dynamic> get data => {
        'createdBy': createdBy,
        'players': players,
        'time': time,
        'course': course
      };
}

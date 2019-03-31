import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(FirebaseUser user, BuildContext context) {
    Firestore.instance.collection('/users').document(user.uid).setData({
      'email': user.email,
      'uid': user.uid,
      'test': 'fooooo'
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
    });
  }
}
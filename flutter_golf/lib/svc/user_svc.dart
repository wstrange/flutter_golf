import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../model/model.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Error
}

class UserService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final Firestore _firestore;
  FirebaseUser _firebase_user;
  Status _status = Status.Uninitialized;
  User _user;

  UserService(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignin,
      Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _firestore = firestore ?? Firestore.instance {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get firebaseUser => _firebase_user;

  User get user => _user;

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var user = await _firebaseAuth.signInWithCredential(credential);
      _registerUser(user);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithCredentials(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user == null) return false;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp({String email, String password}) async {
    var user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _registerUser(user);
  }

  Future<void> _registerUser(FirebaseUser u) async {
    // add user to users doc

    var ref = _firestore.collection("users");
    _user = _firebaseUserToModelUser(u);

    try {
      await ref
          .document(_user.id)
          .setData(jsonSerializer.serializeWith(User.serializer, _user));
    } catch (e) {
      print("Exception Serializing user $e");
    }
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  // todo: Should return a User model
  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _firebase_user = firebaseUser;
      _status = Status.Authenticated;
      // Create a Model User from the firebase user
      _user = _firebaseUserToModelUser(_firebase_user);
    }
    notifyListeners();
  }

  User _firebaseUserToModelUser(FirebaseUser fb) => User((u) => u
    ..id = fb.uid
    ..displayName = fb.displayName
    ..email = fb.email);
}

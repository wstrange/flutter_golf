import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final Firestore _firestore;

  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignin,
      Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _firestore = firestore ?? Firestore.instance;

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var user = await _firebaseAuth.signInWithCredential(credential);
    _registerUser(user);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    var user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _registerUser(user);
  }

  Future<void> _registerUser(FirebaseUser user) async {
    // add user to users doc
    await _firestore
        .collection("users")
        .document(user.uid)
        .setData({"email": user.email, "displayName": user.displayName});
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  // todo: Should return a User model
  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}

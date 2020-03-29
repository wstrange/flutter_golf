import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/model.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Error
}

abstract class _UserStore with Store {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final Firestore _firestore;
  FirebaseUser _firebaseUser;

  _UserStore()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn(),
        _firestore = Firestore.instance {}

  @observable
  User user;

  @observable
  Status status = Status.Unauthenticated;

  @action
  Future<bool> signInWithGoogle() async {
    try {
      status = Status.Authenticating;
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var authResult = await _firebaseAuth.signInWithCredential(credential);
      registerUser(authResult.user);
      status = Status.Authenticated;
      return true;
    } catch (e) {
      print(e);
      status = Status.Unauthenticated;
      return false;
    }
  }

  @action
  Future<void> registerUser(FirebaseUser u) async {
    // add user to users doc

    var ref = _firestore.collection("users");
    user = _firebaseUserToModelUser(u);

    try {
      await ref
          .document(user.id)
          .setData(jsonSerializer.serializeWith(User.serializer, user));
    } catch (e) {
      print("Exception Serializing user $e");
    }
  }

  @action
  Future<void> signOut() async {
    _firebaseAuth.signOut();
    _googleSignIn.signOut();
    status = Status.Unauthenticated;
    user = null; // todo: is this the right thing to do?
  }

  User _firebaseUserToModelUser(FirebaseUser fb) => User((u) => u
    ..id = fb.uid
    ..displayName = fb.displayName
    ..email = fb.email);

  @action
  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      status = Status.Unauthenticated;
    } else {
      _firebaseUser = firebaseUser;
      status = Status.Authenticated;
      // Create a Model User from the firebase user
      user = _firebaseUserToModelUser(_firebaseUser);
    }
  }

  @action
  Future<bool> signInWithCredentials(String email, String password) async {
    try {
      status = Status.Authenticating;
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user == null) return false;
      status = Status.Authenticated;
      return true;
    } catch (e) {
      status = Status.Unauthenticated;
      return false;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tacres_draft/model/user.dart';
import 'package:tacres_draft/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create myUser object based on firebase user
  myUser? _userFromFirebaseUser(User user) {
    return user != null ? myUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<myUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  // sign in anon

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(
      String currEmail, String currPassword) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: currEmail, password: currPassword);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String currEmail, String currPassword) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: currEmail, password: currPassword);
      User? user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOutAuth() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      print("error log out");
      return null;
    }
  }

  String giveMyUid() {
    final User? user = _auth.currentUser;
    final uid = user!.uid;

    return uid;
    // here you write the codes to input the data into firestore
  }
}

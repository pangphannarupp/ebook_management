import 'package:firebase_auth/firebase_auth.dart';
import 'package:notification_management/domain/entities/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  UserApp _userFromFirebaseUser(User user) {
    return user != null ? UserApp(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<UserApp> get userApp {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // forget password
  Future forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // User user = result.user;
      // return _userFromFirebaseUser(user);
      return result.user;
    } catch (error) {
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }

}
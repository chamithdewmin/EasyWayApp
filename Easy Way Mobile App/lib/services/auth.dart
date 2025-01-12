import 'package:firebase/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer' as dev;

class AuthServices{

  //firebase instance
  final FirebaseAuth _auth =FirebaseAuth.instance;
  DatabaseReference users = FirebaseDatabase.instance.ref("user_profile");

  String get userID => _auth.currentUser?.uid ?? '';

  //create a user from firebase user with uid
  UserModel? _userWithFirebaseUserUid (User? user){
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //create the stream for checking the auth changes in the user
  Stream<UserModel?> get user {
  return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //Sign in anonymous
  Future singInAnonymously () async {

    try{

    UserCredential result = await _auth.signInAnonymously();
    User? user = result.user;
    return _userWithFirebaseUserUid(user);

    }catch(err) {
      print(err.toString());
      return null;
    }
  }
  //Register using email and password
  Future registerWithEmailAndPassword (String email, String password) async {

    try{

      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      final snapshot = await users.child(user!.uid).set({
        'name': '',
        'email': email,
        'phone': '',
        'address': '',
      });

    //create a new document for the user with the uid
  

      return _userWithFirebaseUserUid(user);

    }catch(err){
      print(err.toString());
      return null;
    }
  }
  

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      dev.log(e.toString());
    }
  }

  //sing in using email and password
  Future singInUsingEmailAndPassword(String email, String password) async {
    try{

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
        User? user = result.user;
        return _userWithFirebaseUserUid(user);

    }catch(err){
      print(err.toString());
      return null;
    }
  }

  signInWithCredential(OAuthCredential credential) {}

}
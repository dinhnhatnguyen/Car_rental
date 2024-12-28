import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../presentation/widgets/show_toast.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.',context: context);
      } else {
        showToast(message: 'An error occurred: ${e.code}',context: context);
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.',context: context);
      } else {
        showToast(message: 'An error occurred: ${e.code}',context: context);
      }

    }
    return null;

  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showToast(message: 'Successfully signed out', context: context);
    } catch (e) {
      showToast(message: 'Error signing out', context: context);
    }
  }


}
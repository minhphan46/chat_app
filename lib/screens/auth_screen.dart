import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        // login
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // singup
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        storeUser(userCredential, email, username);
      }
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials';

      if (error.message != null) {
        message = error.message!;
      }

      showSnackbar(ctx, message);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      showSnackbar(ctx, error.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> storeUser(
    UserCredential userCredential,
    String email,
    String username,
  ) async {
    // store username and email of user to firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'username': username,
      'email': email,
    });
  }

  void showSnackbar(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}

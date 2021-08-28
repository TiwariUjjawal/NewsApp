// import 'package:firebase/widgets/auth/auth_form.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  bool _isLoggingIn;
  AuthScreen(this._isLoggingIn);
  static const routeName = '/authScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
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
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set(({
              'username': username,
              'email': email,
              'joinedAt': Timestamp.now(),
            }));
      }
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An Error Occured, please check your credentitals';

      if (err.message != null) {
        message = err.message.toString();
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
      // ScaffoldMessenger
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Colors.grey[300],
      body: AuthForm(_submitAuthForm, _isLoading, widget._isLoggingIn),
    );
  }
}

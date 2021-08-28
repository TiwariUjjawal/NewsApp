import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'google_auth.dart';

class AuthForm extends StatefulWidget {
  bool isLoading;
  bool isLoggingIn;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  AuthForm(this.submitFn, this.isLoading, this.isLoggingIn);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // late bool _isLogin;

  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _onSubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        widget.isLoggingIn,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Stack(children: [
        Container(
          color: Colors.blueAccent[400],
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),
        SingleChildScrollView(
          child: Container(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 150),
                child: Center(
                  child: Image.asset(
                    'lib/images/logo.png',
                    height: 200,
                    width: 300,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                // margin: EdgeInsets.only(top: 200),
                // height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    margin: EdgeInsets.all(20),
                    child: registerationForm(),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget registerationForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                emailField(),
                if (!widget.isLoggingIn) usernameField(),
                SizedBox(height: 25),
                passwordField(),
              ],
            ),
          ),
          // SizedBox(height: ),
          loginSignupButtons(),
        ],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      key: ValueKey('email'),
      onSaved: (value) {
        _userEmail = value.toString();
      },
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(
          Icons.email,
          color: Colors.blueAccent[400],
        ),
        hintText: 'Enter email address',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
              width: 10,
            )),
      ),
    );
  }

  Widget usernameField() {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        TextFormField(
          key: ValueKey('username'),
          onSaved: (value) {
            _userName = value.toString();
          },
          validator: (value) {
            if (value!.isEmpty || value.length < 4) {
              return 'Please enter atleast 4 characters';
            }
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(
              Icons.person,
              color: Colors.blueAccent[400],
            ),
            hintText: 'Enter Username',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Colors.blueAccent[400] ?? Colors.blue)),
          ),
        ),
      ],
    );
  }

  Widget passwordField() {
    return TextFormField(
      key: ValueKey('password'),
      onSaved: (value) {
        _userPassword = value.toString();
      },
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return 'Password length must be 6 characters long';
        }
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(
          Icons.password,
          color: Colors.blueAccent[400],
        ),
        hintText: 'Enter Password',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.blueAccent[400] ?? Colors.blue)),
      ),
      obscureText: true,
    );
  }

  Widget loginSignupButtons() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: !widget.isLoading
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (!widget.isLoading)
              FlatButton(
                  onPressed: () {
                    setState(() {
                      widget.isLoggingIn = !widget.isLoggingIn;
                    });
                  },
                  child: Text(
                    widget.isLoggingIn
                        ? 'Create new account'
                        : 'I have already an account',
                    style:
                        TextStyle(color: Colors.blueAccent[700], fontSize: 15),
                  )),
            if (widget.isLoading)
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 40, top: 20, bottom: 40),
                child: CircularProgressIndicator(),
              ),
            if (!widget.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  // : Colors.blue,
                  style: TextButton.styleFrom(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(100)),
                      padding: EdgeInsets.only(
                          right: 30, left: 30, top: 8, bottom: 8),
                      primary: Colors.blueAccent[700]),
                  onPressed: () {
                    _onSubmit();
                  },
                  child: Text(
                    widget.isLoggingIn ? 'Login' : 'SignUp',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
          ],
        ),
        if (!widget.isLoading)
          FutureBuilder(
            future: Authentication.initializeFirebase(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error initializing Firebase');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return GoogleSignInButton();
              }
              return CircularProgressIndicator();
            },
          ),
      ],
    );
  }
}

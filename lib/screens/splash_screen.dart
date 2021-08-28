import 'package:flutter/material.dart';

import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _enterAuth(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Container(
        padding: EdgeInsets.only(top: 150),
        child: Column(children: [
          Center(
            child: Image.asset(
              '/Users/ut/StudioProjects/library_firebase/images/logo-svg.png',
              width: 200,
              // height: 300,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 60,
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(false),
                  ),
                );
              },
              child: Text(
                'Register',
                style: TextStyle(fontSize: 25),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[900],
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 60,
            width: 250,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(true),
                  ),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 25),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[900],
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

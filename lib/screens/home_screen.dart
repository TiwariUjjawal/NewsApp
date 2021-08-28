import 'package:final_project/screens/my_profile.dart';
import 'package:final_project/screens/news_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      elevation: 0,
      brightness: Brightness.dark,
      // backgroundColor: Colors.blueAccent[400],
      backgroundColor: Colors.blueAccent[400],
      title: Text('App Title'),
      actions: [
        DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          items: [
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('My Profile'),
                  ],
                ),
              ),
              value: 'myProfile',
            ),
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
              value: 'logout',
            ),
          ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'logout') {
              FirebaseAuth.instance.signOut();
            }
            if (itemIdentifier == 'myProfile') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyProfile(),
                  ));
            }
          },
        )
      ],
    );
    double appBarheight = appBar.preferredSize.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: NewsScreen(),
    );
  }
}

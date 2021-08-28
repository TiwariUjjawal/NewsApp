import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  AppBar appBar = AppBar(
    brightness: Brightness.dark,
    title: Text(
      'PROFILE',
      style: TextStyle(fontSize: 20),
    ),
    backgroundColor: Colors.blueAccent[400],
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users/')
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser?.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final userDocs = userSnapshot.data?.docs;
            return Column(
              children: [
                profileCard(userDocs),
                SizedBox(height: 30),
                emailListTile(),
                SizedBox(height: 40),
                registeredListTile(userDocs),
                SizedBox(height: 60),
                // editProfileButton(),
                logoutButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget profileCard(userDocs) {
    return Stack(
      children: [
        Container(
          height: 190,
          color: Colors.blueAccent[400],
        ),
        Container(
          height: 300,
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 10,
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, top: 30),
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Icon(
                      Icons.person_rounded,
                      size: 150,
                    ),
                  ),
                ),
                Text(
                  userDocs?[0]['username'],
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "@" +
                      (userDocs?[0]['username'].toLowerCase())
                          .replaceAll(new RegExp(r"\s+"), ""),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget emailListTile() {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blueAccent[400],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                width: 2, color: Colors.blueAccent[400] ?? Colors.blue)),
        child: Icon(
          Icons.email_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      title: Text(
        FirebaseAuth.instance.currentUser?.email ?? '',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget registeredListTile(userDocs) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blueAccent[400],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                width: 2, color: Colors.blueAccent[400] ?? Colors.blue)),
        child: Icon(
          Icons.app_registration_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      title: Text(
        ("Registered On: " +
            DateFormat.yMMMd()
                .format((userDocs?[0]['joinedAt']).toDate())
                .toString()),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget editProfileButton() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 50,
        width: 350,
        child: ElevatedButton(
          onPressed: () async {},
          child: Text(
            'Edit My Profile',
            style: TextStyle(fontSize: 25),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent[400],
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 50,
        width: 350,
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
          },
          child: Text(
            'Logout',
            style: TextStyle(fontSize: 25),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent[400],
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}

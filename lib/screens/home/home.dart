import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo4/screens/authenticate/sign_in.dart';
import 'package:demo4/services/auth.dart';
import 'package:demo4/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  // String name;
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    //getUserName();
    // Call the function to fetch data when the widget is created
  }

  String name = '';
  //AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  //dynamic result = await _auth.signInAnon();
                  // if (result == null) {
                  //   print('error in sign in');
                  // } else {
                  //   print('signed in');
                  //   print(result);
                  //   // ignore: use_build_context_synchronously
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       // Return an alert dialog
                  //       return AlertDialog(
                  //         title: Text('Alert Dialog'),
                  //         content: Text('This is a simple alert dialog.'),
                  //         actions: <Widget>[
                  //           TextButton(
                  //             onPressed: () {
                  //               // Close the alert dialog
                  //               Navigator.of(context).pop();
                  //             },
                  //             child: Text('OK'),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // }
                  // ignore: use_build_context_synchronously
                  goSignin(context);
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown[300],
                ),
              ),
            ),
          ),
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  //getUserName();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown[300],
                ),
                child: const Text(
                  'Print User Data',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
          Text(
            'The user name is ${name}',
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) {
      goSignin(context);
    });
  }

  void goSignin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  // void getUserName() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   name = (await DatabaseService(uid: user!.uid).getUserData())!;

  // }
}

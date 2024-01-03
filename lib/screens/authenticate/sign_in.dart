import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo4/resusable_widgets/loading.dart';
import 'package:demo4/resusable_widgets/login_register_btn.dart';
import 'package:demo4/resusable_widgets/text_field.dart';
import 'package:demo4/screens/authenticate/sign_up.dart';
import 'package:demo4/screens/home/home.dart';
import 'package:demo4/screens/map_screens/simple_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool alertSet = false;
  bool isLoading = false;
  //
  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  //
  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;

      if (!isDeviceConnected && alertSet == false) {
        showDialogBox();
        setState(() {
          alertSet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  //

  showDialogBox() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("No connection"),
            content: const Text("Please check your connectivity"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'cancel');
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showDialogBox();
                    setState(() {
                      alertSet = true;
                    });
                  } else {
                    setState(() {
                      alertSet = false;
                    });
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(66, 6, 231, 1),
                    Color.fromRGBO(133, 219, 241, 1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: reusableTextfield('Username', Icons.person_outlined,
                        false, _userController),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: reusableTextfield('Password', Icons.lock_outline,
                        true, _passwordController),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  signOptionbtn(context, true, () async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _userController.text,
                              password: _passwordController.text)
                          .then((value) {
                        checkUserStatus();
                        setState(() {
                          isLoading = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SimpleMap()),
                        );
                      }).onError((error, stackTrace) {
                        print("Error ${error}");
                        setState(() {
                          isLoading = false;
                          // _errorMessage = e.message ?? 'Authentication failed';
                          _userController.clear();
                          //_userController.text = '';
                          _passwordController.clear();
                          // _passwordController.text = '';
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _errorMessage = e.message ?? 'Authentication failed';
                        //_userController.clear();
                        //_userController.text = '';
                        //_passwordController.clear();
                        // _passwordController.text = '';
                      });
                    }
                  }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void checkUserStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    print("User id is ${user?.uid}");
  }
}

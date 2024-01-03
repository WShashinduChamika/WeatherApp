import 'package:demo4/resusable_widgets/loading.dart';
import 'package:demo4/resusable_widgets/login_register_btn.dart';
import 'package:demo4/resusable_widgets/text_field.dart';
import 'package:demo4/screens/authenticate/sign_in.dart';
import 'package:demo4/screens/home/home.dart';
import 'package:demo4/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  //
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
                    child: reusableTextfield(
                        'Email', Icons.email_outlined, false, _emailController),
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
                  signOptionbtn(context, false, () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) async {
                      User? user = FirebaseAuth.instance.currentUser;
                      //print(user?.uid);
                      await DatabaseService(uid: user!.uid).setUserData(
                          _userController.text,
                          _emailController.text,
                          _passwordController.text);
                      setState(() {
                        isLoading = true;
                      });
                      goHome(context);
                    }).onError((error, stackTrace) {
                      setState(() {
                        _userController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        isLoading = false;
                      });
                      print("Error ${error.toString()}");
                    });
                  }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void goHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }
}

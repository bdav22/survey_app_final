import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/components/my_button.dart';
import 'package:survey_app/components/my_textfield.dart';
import 'package:survey_app/components/my_passwordfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

/*
//forgot password method
  void forgotPass() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text);
  }

*/
  void signUserIn() async {
    //display a loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //try and catch for signing in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      //get rid of loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //get rid of loading circle
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.code);
    }
  }

  //login error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Center(
              child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //logo
                  /*
                  const Icon(
                    Icons.no_drinks_sharp, //FILL WITH OUR ACTAUL LOGO
                    color: Colors.orange,
                    size: 200,
                  ),
                  */

                  Image.asset(
                    '/Users/bendavenport/survey_app/lib/images/CatholicULogo.png',
                    height: 200,
                    width: 325,
                  ),

                  Text(
                    'Welcome back to Whichspot, let\'s find the party',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // username textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  PasswordField(
                    controller: passwordController,
                    hintText: 'Password',
                  ),

                  const SizedBox(height: 8),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onTap: () {
                              //forgotPass();
                              showDialog(
                                  context: context,
                                  builder: (_) => const AlertDialog(
                                        backgroundColor:
                                            Color.fromRGBO(20, 20, 20, 1),
                                        title: Text(
                                          'Check Email For Password Reset!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ));
                            }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "Sign In",
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Create an account',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

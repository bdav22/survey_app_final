import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/components/my_button.dart';
import 'package:survey_app/components/my_textfield.dart';
import 'package:survey_app/components/my_passwordfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

/*
//forgot password method
  void forgotPass() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text);
  }

*/
  void signUserUp() async {
    //display a loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //try creating the user
    try {
      //compare password with confirmed password
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text
            );
      } else if (passwordController.text != confirmPasswordController.text){
      
        //show passwords dont match
        showErrorMessage("Passwords don't match");
          
      }

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
                    'Lets create an account for oyu ',
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

                  // confirm password textfield
                  PasswordField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                  ),

                  const SizedBox(height: 8),

                  // forgot password?
                  
                  const SizedBox(height: 25),

                  // sign up button
                  MyButton(
                    text: "Sign Up",
                    onTap: signUserUp,
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now',
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

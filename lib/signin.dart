import 'package:flutter/material.dart';
import 'auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Instance variables
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center, // Horizontally centered
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically centered
          children: [
            //Title
            Text("To Do List",
              style: TextStyle(
                fontSize: 50,
              ),
            ),

            SizedBox(height: 20,),

            // On tap, use Google to sign into to do list
            GestureDetector(
              onTap: (){
                authService.signInWithGoogle(context);
              },
              // Sign in button
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Text("Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
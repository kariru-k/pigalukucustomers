import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';

import '../constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Timer(
        const Duration(
            seconds: 3
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user==null){
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/pigaluku_logo.png'),
              const SizedBox(height: 20,),
              const Text(
                'Clothing Store',
                style: kPageViewTextStyle,
              )
            ],
          )
      ),
    );
  }
}

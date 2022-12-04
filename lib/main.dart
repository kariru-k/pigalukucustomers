import 'dart:async';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/constants.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Timer(
      const Duration(
        seconds: 3
      ), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => const WelcomeScreen()
        ));
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



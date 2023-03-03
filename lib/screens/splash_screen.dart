import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/screens/map_screen.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:piga_luku_customers/services/user_services.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  LocationProvider locationProvider = LocationProvider();

  @override
  void initState() {
    Timer(
        const Duration(
            seconds: 3
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user==null){
          Navigator.popAndPushNamed(context, WelcomeScreen.id);
        }else{
          getUserData();
        }
      });
    }
    );

    super.initState();
  }

  getUserData() async{
    UserServices _userServices = UserServices();
    await locationProvider.getCurrentPosition();
    _userServices.getUserById(user!.uid).then((result){
      if (result["location"] != null) {
        print("Null BOYY");
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, MapScreen.id);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final LocationProvider locationData = Provider.of<LocationProvider>(context);

    locationData.getCurrentPosition();


    return Scaffold(
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/pigaluku_logo.png'),
              const SizedBox(height: 20,),
              const Text(
                'PIGA LUKU',
                style: kPageViewTextStyle,
              )
            ],
          )
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: (){
                auth.error = '';
                FirebaseAuth.instance.signOut().then((value) => {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>const WelcomeScreen()
                  ))
                });
              },
              child: const Text(
                'Sign Out'
              )
          ),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                },
                child: const Text(
                    'Go To Home Screen'
                )
            ),
        ]),
      ),
    );
  }
}

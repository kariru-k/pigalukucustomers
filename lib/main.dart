import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/constants.dart';
import 'package:piga_luku_customers/firebase_options.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=>AuthProvider(),
        )
      ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
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
    super.initState();
    // TODO: implement initState
    Timer(
      const Duration(
        seconds: 3
      ), () {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if(user==null){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>const WelcomeScreen()
            ));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>const HomeScreen()
            ));
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



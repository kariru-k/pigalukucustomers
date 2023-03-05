import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/firebase_options.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/providers/store_provider.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/screens/login_screen.dart';
import 'package:piga_luku_customers/screens/map_screen.dart';
import 'package:piga_luku_customers/screens/onboard_screen.dart';
import 'package:piga_luku_customers/screens/register_screen.dart';
import 'package:piga_luku_customers/screens/splash_screen.dart';
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
        ),
        ChangeNotifierProvider(
            create: (_)=> LocationProvider()
        ),
        ChangeNotifierProvider(
            create: (_)=> StoreProvider()
        ),
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
        primaryColor: Colors.deepPurpleAccent,
        fontFamily: "Lato"
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id:(context)=>const HomeScreen(),
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        LoginScreen.id:(context)=>const LoginScreen(),
        SplashScreen.id:(context)=> const SplashScreen(),
        RegisterScreen.id:(context)=> const RegisterScreen(),
        OnBoardScreen.id:(context)=> const OnBoardScreen(),
        MapScreen.id:(context)=> const MapScreen()
      },
    );
  }
}




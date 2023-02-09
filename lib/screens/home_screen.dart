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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(),
        centerTitle: true,
        title: TextButton(
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Delivery Address",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: Colors.white,
                onPressed: () {},
              )
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: (){},
              alignment: Alignment.topLeft,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none
                  ),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search for your location",
                  prefixIcon: const Icon(Icons.search_sharp, color: Colors.black,)
              ),
            ),
          ),
        ),
      ),
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

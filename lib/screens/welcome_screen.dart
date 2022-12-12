import 'package:flutter/material.dart';
import 'package:piga_luku_customers/screens/login_screen.dart';
import 'package:piga_luku_customers/screens/onboard_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.lightBlueAccent
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            )
        ),
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(child: OnBoardScreen()),
                  const Text('Ready to Order from your nearest shop?'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                    child: const Text('Set Delivery Location'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                    },
                    child: RichText(
                      text: const TextSpan(
                          text: "Already a Customer? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ]),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

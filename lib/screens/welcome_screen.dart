import 'package:flutter/material.dart';
import 'package:piga_luku_customers/screens/onboard_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
                right: -1.0,
                top: 2.0,
                child: TextButton(
                  onPressed: () {  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                  ),
                )
            ),
            Column(
              children: [
                const Expanded(child: OnBoardScreen()),
                const Text('Ready to Order from your nearest shop?'),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent
                  ),
                  child: const Text('Set Delivery Location'),
                ),
                const SizedBox(height: 20,),
                TextButton(
                  onPressed: () {  },
                  child: RichText(
                    text: const TextSpan(
                        text: "Already a Customer? ",
                        style: TextStyle(
                            color: Colors.black
                        ),
                        children: [
                          TextSpan(
                              text: 'Log In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              )
                          )
                        ]
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

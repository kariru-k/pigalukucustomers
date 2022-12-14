import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';
  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset('images/pigaluku_logo.png'),
              ),
              const TextField(),
              const TextField(),
              const TextField(),
              const TextField(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {

  final _controller = PageController(
      initialPage: 0
  );

  final List<Widget> _pages = [
    Column(
      children: [
        Image.asset('images/onboarding_clothes.jpg'),
        Text('Shop The Latest Trends')
      ],
    ),
    Column(
      children: [
        Image.asset('images/onboarding_babe.jpg'),
        Text('Order Online For Your Convenience')
      ],
    ),
    Column(
      children: [
        Image.asset('images/onboarding_suit.jpg'),
        Text('Look as stylish as you can Be!')
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [],
      ),
    );
  }
}

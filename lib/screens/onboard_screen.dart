import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/constants.dart';

class OnBoardScreen extends StatefulWidget {
  static const String id = 'onboarding-screen';
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {

  final _controller = PageController(
      initialPage: 0
  );

  int _currentPage = 0;

  final List<Widget> _pages = [
    Column(
      children: [
        Expanded(child: Image.asset('images/onboarding_clothes.jpg')),
        const Text(
          'Shop The Latest Trends',
          style: kPageViewTextStyle,
          textAlign: TextAlign.center,
        )
      ],
    ),
    Column(
      children: [
        Expanded(child: Image.asset('images/onboarding_babe.jpg')),
        const Text(
          'Order Online At Your Convenience',
          style: kPageViewTextStyle,
          textAlign: TextAlign.center,
        )
      ],
    ),
    Column(
      children: [
        Expanded(child: Image.asset('images/onboarding_suit.jpg')),
        const Text(
          'Look as stylish as you can Be!',
          style: kPageViewTextStyle,
          textAlign: TextAlign.center,
        )
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 20,),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Theme.of(context).primaryColor
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}

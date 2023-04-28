import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/screens/favourite_screen.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/screens/my_orders_screen.dart';
import 'package:piga_luku_customers/screens/profile_screen.dart';
import 'package:piga_luku_customers/widgets/cart/cart_notification.dart';

class MainScreen extends StatelessWidget {
  static const String id = 'main-screen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return [
        const HomeScreen(),
        const FavouritesScreen(),
        const MyOrders(),
        const ProfileScreen()
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.square_favorites_alt),
          title: ("My Favourites"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.bag),
          title: ("My Orders"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.profile_circled),
          title: ("My Profile"),
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }



    return Scaffold(
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 56),
        child: CartNotification(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PersistentTabView(
          context,
          controller: controller,
          screens: buildScreens(),
          navBarHeight: 56,
          items: navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Colors.white,
            border: Border.all(
              color: Colors.black45
            )
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          navBarStyle: NavBarStyle.style11, // Choose the nav bar style with this property.
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/screens/main_screen.dart';
import 'package:piga_luku_customers/screens/map_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:piga_luku_customers/widgets/near_by_store.dart';
import 'package:piga_luku_customers/widgets/top_pick_store.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:piga_luku_customers/widgets/image_slider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _location = "";
  String _street = "";
  String _locality = "";

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? location = preferences.getString('address');
    String? street = preferences.getString("street");
    String? locality = preferences.getString("locality");
    setState(() {
      _location = location!;
      _street = street!;
      _locality = locality!;
    });
  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return [
            const MyAppBar()
          ];
        },
        body: ListView(
          padding: const EdgeInsets.only(top: 0.0),
          children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: ImageSlider(),
              ),
              Container(
                  height: 200,
                  color: Colors.white,
                  child: TopPickStore()
              ),
            const NearByStores()
          ]),
      ),
      );
  }
}



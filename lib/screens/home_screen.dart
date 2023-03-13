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
            SliverAppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              centerTitle: true,
              leading: const Icon(Icons.menu),
              title: TextButton(
                onPressed: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _location,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  _street,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                Text(
                                  _locality,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ],
                            )
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18,),
                          color: Colors.white,
                          onPressed: () {
                            locationData.getCurrentPosition();
                            if(locationData.permissionAllowed == true){
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                screen: const MapScreen(),
                                withNavBar: true,
                                settings: const RouteSettings(name: MapScreen.id),
                                pageTransitionAnimation: PageTransitionAnimation.fade
                              );
                            } else {
                              print("Permission denied");
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: const Icon(Icons.power_settings_new_sharp),
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          screen: const WelcomeScreen(),
                          withNavBar: false,
                          settings: const RouteSettings(name: WelcomeScreen.id),
                          pageTransitionAnimation: PageTransitionAnimation.fade
                      );
                    },
                    alignment: Alignment.topLeft,
                  ),
                ),
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
                preferredSize: const Size.fromHeight(75.0),
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
          )
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
                  child: const TopPickStore()
              ),
              const NearByStores()
          ]),
      ),
      );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/location_provider.dart';
import '../screens/map_screen.dart';
import '../screens/welcome_screen.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({
    super.key,
  });



  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {

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

    final locationData = Provider.of<LocationProvider>(context);

    return SliverAppBar(
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
    );
  }
}
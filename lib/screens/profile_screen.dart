import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/screens/profile_update_screen.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'map_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String id = "profile-screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? address;


  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    var locationData = Provider.of<LocationProvider>(context);
    User? user = FirebaseAuth.instance.currentUser;
    userDetails.getUserDetails();

    locationData.getPrefs().then((value){
      setState(() {
        address = "${value[0]}, ${value[1]}, ${value[2]}";
      });
    });


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "My Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: const Text(
                                    "J",
                                    style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  height: 70,
                                  child: userDetails.snapshot == null ? const CircularProgressIndicator() : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (userDetails.snapshot!.get("firstName") != null && userDetails.snapshot!.get("email") != null) ...[
                                        Text("${userDetails.snapshot!["firstName"]} ${userDetails.snapshot!["lastName"]}"),
                                        Text("${userDetails.snapshot!["email"]}")
                                      ] else ... [
                                        const Text("Update Your Name"),
                                        const Text("Update Your Email Address")
                                      ],
                                      Text(
                                        user!.phoneNumber.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Material(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                ),
                                tileColor: Colors.white,
                                title: Text(
                                  address.toString()
                                ),
                                trailing: SizedBox(
                                  width: 80,
                                  child: OutlinedButton(
                                      onPressed: (){
                                        EasyLoading.show();
                                        locationData.getCurrentPosition().then((value){
                                          if(locationData.permissionAllowed == true){
                                            EasyLoading.dismiss();
                                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                              context,
                                              screen: const MapScreen(),
                                              withNavBar: false,
                                              settings: const RouteSettings(name: MapScreen.id),
                                            );
                                          } else {
                                            EasyLoading.showError("Please Accept Location Permissions for the app", duration: const Duration(seconds: 3));
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "Change",
                                        style: TextStyle(
                                          color: Colors.redAccent
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.history),
                      title: Text("My orders"),
                      horizontalTitleGap: 2,
                    ),
                    const Divider(thickness: 2,),
                    const ListTile(
                      leading: Icon(Icons.comment_outlined),
                      title: Text("My ratings and Reviews"),
                      horizontalTitleGap: 2,
                    ),
                    const Divider(thickness: 2,),
                    const ListTile(
                      leading: Icon(Icons.notifications_active),
                      title: Text("Notifications"),
                      horizontalTitleGap: 2,
                    ),
                    const Divider(thickness: 2,),
                    ListTile(
                      leading: const Icon(Icons.power_settings_new_sharp),
                      title: const Text("Sign Out"),
                      horizontalTitleGap: 2,
                      onTap: () {
                        showCupertinoDialog(context: context, builder: (BuildContext context){
                          return CupertinoAlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text("Are you Sure You want to Log Out of the Application?"),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No", style: TextStyle(color: Colors.red))
                              ),
                              TextButton(
                                  onPressed: (){
                                    FirebaseAuth.instance.signOut();
                                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                      context,
                                      screen: const WelcomeScreen(),
                                      withNavBar: false,
                                      settings: const RouteSettings(name: WelcomeScreen.id),
                                    );
                                  },
                                  child: Text("Yes", style: TextStyle(color: Theme.of(context).primaryColor))
                              ),
                            ],
                          );
                        });
                      },
                    ),
                    const Divider(thickness: 2,),
                  ],
                ),
                Positioned(
                  right: 10.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        screen: const UpdateProfile(),
                        withNavBar: false,
                        settings: const RouteSettings(name: UpdateProfile.id),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}

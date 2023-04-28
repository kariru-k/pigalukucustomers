import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/location_provider.dart';
import '../../screens/map_screen.dart';
import '../../screens/profile_screen.dart';
import '../../services/user_services.dart';

class CartBottomSheet extends StatefulWidget {
  const CartBottomSheet({Key? key}) : super(key: key);

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  String? address;
  bool loading = false;
  UserServices userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(context);
    var cartProvider = Provider.of<CartProvider>(context);

    locationProvider.getPrefs().then((value){
      address = "${value[0]}, ${value[1]}, ${value[2]}";
    });

    return Container(
      height: 140,
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Deliver to this address ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          locationProvider.getCurrentPosition().then((value){
                            setState(() {
                              loading = false;
                            });
                            if(locationProvider.permissionAllowed == true){
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                screen: const MapScreen(),
                                withNavBar: false,
                                settings: const RouteSettings(name: MapScreen.id),
                              );
                            } else {
                              setState(() {
                                loading = false;
                              });
                            }
                          });
                        },
                        child: !loading
                            ?
                        const Text(
                          "Change",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15
                          ),
                        )
                            :
                        const CircularProgressIndicator(),
                      )
                    ],
                  ),
                  Text(
                    address.toString(),
                    maxLines: 3,
                    style: const TextStyle(color: Colors.brown, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Kshs ${cartProvider.subTotal}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      const Text("Including Taxes", style: TextStyle(color: Colors.green, fontSize: 10),)
                    ],
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent
                      ),
                      onPressed: (){
                        EasyLoading.show(status: "Please Wait...");
                        userServices.getUserById(user!.uid).then((value){
                          if (value["id"] == null) {
                            EasyLoading.dismiss();
                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                              context,
                              screen: const ProfileScreen(),
                              settings: const RouteSettings(name: ProfileScreen.id),
                            );
                          } else {
                            EasyLoading.dismiss();
                            if (cartProvider.cod == true) {

                            }
                            else {
                            }
                          }
                        });
                      },
                      child: const Text(
                        "CHECKOUT",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/screens/profile_screen.dart';
import 'package:piga_luku_customers/services/store_services.dart';
import 'package:piga_luku_customers/services/user_services.dart';
import 'package:piga_luku_customers/widgets/cart/cart_list.dart';
import 'package:piga_luku_customers/widgets/cart/cod_toggle.dart';
import 'package:provider/provider.dart';

import 'map_screen.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot? document;
  const CartScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices store = StoreServices();
  UserServices userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? doc;
  var textStyle = const TextStyle(color: Colors.grey);
  int discount = 0;
  int deliveryfee = 0;
  String? address;
  bool loading = false;


  @override
  void initState() {
    super.initState();
    store.getShopDetails(widget.document!["sellerUid"]).then((value){
      doc = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var locationProvider = Provider.of<LocationProvider>(context);
    var userDetails = Provider.of<AuthProvider>(context);
    userDetails.getUserDetails();


    locationProvider.getPrefs().then((value){
      address = "${value[0]}, ${value[1]}, ${value[2]}";
    });


    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: Container(
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
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              SliverAppBar(
                iconTheme: const IconThemeData(
                  color: Colors.black87
                ),
                titleTextStyle: const TextStyle(
                  color: Colors.black87
                ),
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.document!["shopName"],
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "${cartProvider.cartQuantity} ${cartProvider.cartQuantity! > 1 ? "Items" : "Item"}",
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          " To Pay: Kshs. ${cartProvider.subTotal!.toStringAsFixed(0)}",
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ];
          },
          body: cartProvider.cartQuantity! > 0
              ?
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    leading: SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: doc != null ? doc!["url"] : "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(doc != null ? doc!["shopName"] : "Loading..."),
                    subtitle: Text(
                      doc != null ? doc!["address"] : "Loading...",
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[300],),
                  const CodToggleSwitch(),
                  Divider(color: Colors.grey[300],),
                  CartList(document: widget.document,),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: 35,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    hintText: "Discount Code? Enter it here"
                                  ),
                                ),
                              )
                          ),
                          OutlinedButton(
                              onPressed: (){},
                              child: const Text("Apply")
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0, left: 4.0, top: 4, bottom: 80),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Bill Details", style: TextStyle(fontWeight: FontWeight.bold),),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "Basket Value",
                                          style: textStyle,
                                        )
                                    ),
                                    Text(
                                      "Kshs. ${cartProvider.subTotal!.toStringAsFixed(0)}",
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "Discount",
                                          style: textStyle,
                                        )
                                    ),
                                    Text(
                                      "Kshs. $discount",
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "Delivery Fees",
                                          style: textStyle,
                                        )
                                    ),
                                    Text(
                                      "Kshs. $deliveryfee",
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                const Divider(color: Colors.grey,),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Text(
                                          "Total Amount Payable",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15
                                          ),
                                        )
                                    ),
                                    Text(
                                      "Kshs. ${deliveryfee + discount + cartProvider.subTotal!.toDouble()}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context).primaryColor.withOpacity(.3)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            "Total Savings",
                                            style: TextStyle(
                                              color: Colors.green
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Kshs. 200",
                                          style: TextStyle(
                                              color: Colors.green
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
              :
          const Center(child: Text("Your Cart is Empty! Please add some products"))
      )
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
import 'package:piga_luku_customers/services/store_services.dart';
import 'package:piga_luku_customers/services/user_services.dart';
import 'package:piga_luku_customers/widgets/cart/cart_bottomsheet_widget.dart';
import 'package:piga_luku_customers/widgets/cart/cart_list.dart';
import 'package:piga_luku_customers/widgets/cart/cod_toggle.dart';
import 'package:provider/provider.dart';

import '../widgets/cart/coupon_widget.dart';

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
    var userDetails = Provider.of<AuthProvider>(context);
    userDetails.getUserDetails();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: const CartBottomSheet(),
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
                  const CouponWidget(),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
import 'package:piga_luku_customers/screens/cart_screen.dart';
import 'package:piga_luku_customers/services/cart_services.dart';
import 'package:provider/provider.dart';

class CartNotification extends StatefulWidget {
  const CartNotification({Key? key}) : super(key: key);

  @override
  State<CartNotification> createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
  CartServices cartServices = CartServices();
  DocumentSnapshot? document;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartTotal();
    cartServices.getShopName().then((value){
      setState(() {
        document = value;
      });
    });

    return Visibility(
      visible: cartProvider.cartQuantity! > 0 ? true : false,
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("${cartProvider.cartQuantity} ${cartProvider.cartQuantity! > 1 || cartProvider.cartQuantity == null ? "Items" : "Item"}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          const Text("  |  ", style: TextStyle(color: Colors.white),),
                          Text("Kshs. ${cartProvider.subTotal!.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Text(
                        "From ${document!["shopName"]}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        screen: CartScreen(document: document,),
                        withNavBar: true,
                        settings: const RouteSettings(name: CartScreen.id),
                    );
                  },
                  child: Row(
                    children: const [
                      Text("View Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,),
                      Icon(Icons.shopping_cart, color: Colors.white,)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

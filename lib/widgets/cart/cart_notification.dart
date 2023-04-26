import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
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

    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      color: Colors.green,
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
                  cartProvider.cartQuantity! > 1
                      ?
                  Text("${cartProvider.cartQuantity} Items", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                      :
                  Text("${cartProvider.cartQuantity} Item", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("From ${document!["shopName"]}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            InkWell(
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot? document;
  const CartScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      bottomSheet: Container(
        height: 60,
        color: Colors.blueGrey[900],
        child: Center(
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
                    onPressed: (){},
                    child: const Text("CHECKOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                )
              ],
            ),
          ),
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
                          "To Pay: ${cartProvider.subTotal!.toStringAsFixed(0)}",
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ];
          },
          body: const Center(
            child: Text("Cart Screen"),
          )
      )
    );
  }
}

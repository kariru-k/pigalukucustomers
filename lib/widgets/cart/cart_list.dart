import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/services/cart_services.dart';
import 'package:piga_luku_customers/widgets/cart/cart_card.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot? document;

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {

  CartServices cart = CartServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: cart.cart.doc(cart.user!.uid).collection("products").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Material(
                color: Colors.purpleAccent,
                elevation: 4,
                child: CartCard(
                  document: document,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

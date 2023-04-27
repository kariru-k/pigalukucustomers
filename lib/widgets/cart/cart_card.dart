import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/widgets/cart/counter.dart';

class CartCard extends StatelessWidget {
  const CartCard({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot? document;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.grey
              )
          ),
          color: Colors.white
        ),
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: document!["productImage"],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document!["productName"]),
                      Text(
                        "Size: ${document!["size"]}",
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Kshs. ${document!["price"].toString()}"),
                    ],
                  )
                ],
              ),
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: CounterForCard(
                  sizes: [document!["size"]],
                  document: document,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

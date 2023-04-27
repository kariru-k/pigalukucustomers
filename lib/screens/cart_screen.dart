import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
import 'package:piga_luku_customers/services/store_services.dart';
import 'package:piga_luku_customers/widgets/cart/cart_list.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot? document;
  const CartScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices store = StoreServices();
  DocumentSnapshot? doc;


  @override
  void initState() {
    store.getShopDetails(widget.document!["sellerUid"]).then((value){
      doc = value;
    });
    super.initState();
  }


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
          body: Column(
            children: [
              ListTile(
                leading: SizedBox(
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: doc!["url"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(doc!["shopName"]),
                subtitle: Text(
                  doc!["address"],
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                  ),
                ),
              ),
              CartList(document: widget.document,)
            ],
          )
      )
    );
  }
}

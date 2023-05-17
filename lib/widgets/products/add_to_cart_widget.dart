import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:piga_luku_customers/widgets/cart/counter_widget.dart';

import '../../services/cart_services.dart';

class AddToCartWidget extends StatefulWidget {
  const AddToCartWidget({Key? key, required this.document, required this.size}) : super(key: key);
  final DocumentSnapshot document;
  final String? size;

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {

  CartServices cart = CartServices();
  User? user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  bool _exist = false;
  int quantity = 0;
  String? docId;


  @override
  void initState() {
    getCartData(); // Get cart data
    super.initState();
  }

  getCartData() async {
    final snapshot = await cart.cart.doc(user!.uid).collection('products').get();
    if (snapshot.docs.isEmpty) {
      setState(() {
        _loading = true;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('products')
        .where("productId", isEqualTo: widget.document["productId"])
        .get()
        .then(
            (QuerySnapshot querySnapshot) {
              for (var doc in querySnapshot.docs) {
                if (doc["productId"] == widget.document["productId"] && doc["size"] == widget.size) {
                  setState(() {
                    _exist = true;
                    quantity = doc["qty"];
                    docId = doc.id;
                  });
                  break;
                } else {
                  setState(() {
                    _exist = false;
                  });
                }
              }
            });





    return _loading
        ?
    SizedBox(
      height: 56,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
        ),
      ),
    )
        :
    _exist
        ?
    CounterWidget(document: widget.document, quantity: quantity.toInt(), docId: docId.toString(), size: widget.size,)
        :
    InkWell(
      onTap: () {
        if (widget.size != null) {
          EasyLoading.show(status: "Adding to Cart");
          cart.addToCart(widget.document, widget.size).then((value){
            setState(() {
              _exist = true;
            });
            EasyLoading.showSuccess("Added to Cart");
          });
        } else {
          EasyLoading.showError("Please enter a Size", duration: const Duration(seconds: 5));
        }
      },
      child: Container(
        height: 56,
        color: Colors.red[400],
        child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_basket_outlined, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text("Add to basket"),
                ],
              ),
            )
        ),
      ),
    );
  }
}

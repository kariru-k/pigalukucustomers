import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piga_luku_customers/services/cart_services.dart';

class CartProvider with ChangeNotifier{

  CartServices cart = CartServices();
  double? subTotal;
  int? cartQuantity;
  QuerySnapshot? snapshot;

  Future<double>getCartTotal() async {
    var cartTotal = 0.0;
    QuerySnapshot? snapshot = await cart.cart.doc(cart.user!.uid).collection("products").get();

    for (var doc in snapshot.docs) {
      cartTotal = cartTotal + doc["total"];
    }

    subTotal = cartTotal;
    cartQuantity = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();

    return cartTotal;
  }


}
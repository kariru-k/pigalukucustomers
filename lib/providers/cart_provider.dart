import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piga_luku_customers/services/cart_services.dart';

class CartProvider with ChangeNotifier{

  CartServices cart = CartServices();
  double? subTotal;
  int? cartQuantity;
  QuerySnapshot? snapshot;
  DocumentSnapshot? document;
  String? address;
  double? distance;
  bool cod = false;
  List cartList = [];

  Future<double>getCartTotal() async {
    var cartTotal = 0.0;
    List _newList = [];
    QuerySnapshot? snapshot = await cart.cart.doc(cart.user!.uid).collection("products").get();

    for (var doc in snapshot.docs) {
      if (!_newList.contains(doc.data())) {
        _newList.add(doc.data());
        cartList = _newList;
        notifyListeners();
      }
      cartTotal = cartTotal + doc["total"];
    }

    subTotal = cartTotal;
    cartQuantity = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();

    return cartTotal;
  }

  getDistance(distance){
    this.distance = distance;
    notifyListeners();
  }

  getPaymentMethod(index){
    if (index == 0) {
      cod = true;
    } else {
      cod = false;
    }
    notifyListeners();
  }

  getShopName() async {
    DocumentSnapshot doc = await cart.cart.doc(cart.user!.uid).get();
    if(doc.exists){
      document = doc;
      notifyListeners();
    } else {
      document = null;
      notifyListeners();
    }
  }




}
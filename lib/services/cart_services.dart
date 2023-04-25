import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartServices{
  CollectionReference cart = FirebaseFirestore.instance.collection("cart");
  User? user = FirebaseAuth.instance.currentUser;

  Future<void>addToCart(DocumentSnapshot document){
    cart.doc(user!.uid).set({
      'user': user!.uid,
      'sellerUid': document["seller.sellerUid"]
    });

    return cart.doc(user!.uid).collection("products").add({
      "productId": document['productId'],
      "productName": document['productName'],
      "gender": document['gender'],
      "price": document['price'],
      "itemCode": document['itemCode'],
      "qty": 1
    });
  }

  Future<void>updateCartQuantity(docId, quantity) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection("products")
        .doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Product does Not Exist In Cart");
      }

      // Perform an update on the document
      transaction.update(documentReference, {'qty': quantity});

      // Return the new count
      return quantity;
    })
        .then((value) => print("Product cart count updated to $value"))
        .catchError((error) => print("Failed to update cart products: $error"));
  }

}
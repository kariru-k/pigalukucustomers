import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices{
  CollectionReference cart = FirebaseFirestore.instance.collection("cart");
  User? user = FirebaseAuth.instance.currentUser;

  Future<void>addToCart(DocumentSnapshot document, String? size){
    cart.doc(user!.uid).set({
      'user': user!.uid,
      'sellerUid': document["seller.sellerUid"],
      'shopName': document["seller.shopName"]
    });

    return cart.doc(user!.uid).collection("products").add({
      "productId": document['productId'],
      "productName": document['productName'],
      "productImage": document['productImage'],
      "gender": document['gender'],
      "price": document['price'],
      "itemCode": document['itemCode'],
      "qty": 1,
      "size": size,
      "total": document["price"]
    });
  }

  Future<void>updateCartQuantity(docId, quantity, total) async {
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
      transaction.update(documentReference, {
        'qty': quantity,
        "total": total
      });

      // Return the new count
      return quantity;
    });
  }

  Future<void>removeFromCart(docId) async {
    cart.doc(user!.uid).collection("products").doc(docId).delete();
  }

  Future<void>checkData() async {
    final snapshot = await cart.doc(user!.uid).collection("products").get();
    if (snapshot.docs.isEmpty) {
      cart.doc(user!.uid).delete();
    }
  }

  Future<void>deleteCart() async {
    await cart.doc(user!.uid).collection("products").get().then((snapshot){
      for (DocumentSnapshot document in snapshot.docs){
        document.reference.delete();
      }
    });
  }

  Future<String?>checkSeller() async {
    final snapshot = await cart.doc(user!.uid).get();
    return snapshot.exists ? snapshot["shopName"] : null;
  }

  

}
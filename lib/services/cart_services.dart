
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';

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

  Future<DocumentSnapshot>getShopName() async {
    DocumentSnapshot doc = await cart.doc(user!.uid).get();
    return doc;
  }

  Future<void> updateAccount(String mCheckoutRequestID) {
    Map<String, String> initData = {
      'CheckoutRequestID': mCheckoutRequestID,
    };

    return FirebaseFirestore.instance
        .collection("paymentreceipts")
        .doc(mCheckoutRequestID)
        .set(initData)
        .then((value) => print("Transaction Initialized."))
        .catchError((error) => print("Failed to init transaction: $error"));
  }


  Future<dynamic> startTransaction({required tillNumber, required phoneNumber, required amount, required sellerNumber, required context}) async {
    dynamic transactionInitialisation;
    print(phoneNumber);
    try {
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode: tillNumber.toString(),
              transactionType: TransactionType.CustomerPayBillOnline,
              amount: amount,
              partyA: phoneNumber,
              partyB: tillNumber.toString(),
              callBackURL: Uri.parse("https://mpesa.free.beeceptor.com"),
              accountReference: sellerNumber,
              phoneNumber: phoneNumber,
              baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
              transactionDesc: "Payment for goods to Vendor $sellerNumber",
              passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"
          );

      Map result = transactionInitialisation;

      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result["ResponseCode"];
        print("Resulting Code: $mResponseCode");
        if (mResponseCode == '0') {
          return result["CheckoutRequestID"];
        }
        else {
          return showCupertinoDialog(
              context: context,
              builder: (BuildContext context){
                return CupertinoAlertDialog(
                  title: const Text("Error Paying Via M-Pesa"),
                  content: const Text("There was an error while paying via M-Pesa, Please Try again"),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        )
                    ),
                  ],
                );
              }
          );
        }
      }

      print(result);

    } catch (error) {
      print(error);
    }
  }

}
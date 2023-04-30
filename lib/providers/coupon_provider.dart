import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier{

  bool? expired;
  DocumentSnapshot? document;
  int? discountRate;
  String? title;
  String? details;
  
  Future<DocumentSnapshot> getCouponDetails(title, sellerId) async{
    DocumentSnapshot document = await FirebaseFirestore.instance.collection("coupons").doc(title).get();
    if (document.data() != null) {
      if (document["sellerId"] == sellerId) {
        checkExpiry(document);
      }
    }
    return document;
  }


  checkExpiry(DocumentSnapshot? document){
    DateTime date = document!["expiryDate"].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if(dateDiff < 0){
      expired = true;
      notifyListeners();
    } else {
      this.document = document;
      discountRate = document["discountRate"];
      expired = false;
      notifyListeners();
    }
  }



}
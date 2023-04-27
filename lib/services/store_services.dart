

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{

  final CollectionReference vendorbanner = FirebaseFirestore.instance.collection("vendorbanner");
  final CollectionReference vendors = FirebaseFirestore.instance.collection("vendors");


  getTopPickedStore(){
    return vendors
        .where("accVerified", isEqualTo: true)
        .where("isTopPicked", isEqualTo: true)
        .orderBy("shopName")
        .snapshots();
  }

  getNearbyStore(){
    return vendors
        .where("accVerified", isEqualTo: true)
        .orderBy("shopName");
  }

  getNearbyStorePagination(){
    return vendors
        .where("accVerified", isEqualTo: true)
        .orderBy("shopName")
        .snapshots();
  }

  Future<DocumentSnapshot>getShopDetails(sellerUid) async {
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}
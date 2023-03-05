

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{
  getTopPickedStore(){
    return FirebaseFirestore.instance
        .collection("vendors")
        .where("accVerified", isEqualTo: true)
        .where("isTopPicked", isEqualTo: true)
        .orderBy("shopName")
        .snapshots();
  }

  getNearbyStore(){
    return FirebaseFirestore.instance
        .collection("vendors")
        .where("accVerified", isEqualTo: true)
        .orderBy("shopName");
  }

  getNearbyStorePagination(){
    return FirebaseFirestore.instance
        .collection("vendors")
        .where("accVerified", isEqualTo: true)
        .orderBy("shopName")
        .snapshots();
  }
}
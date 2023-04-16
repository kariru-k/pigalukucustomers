

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{

  final CollectionReference vendorbanner = FirebaseFirestore.instance.collection("vendorbanner");



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
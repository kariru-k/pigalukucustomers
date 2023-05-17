import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");

  Future<DocumentReference>saveOrder(Map<String, dynamic> data){
    var result = orders.add(
      data
    );
    return result;
  }

  Color statusColor(DocumentSnapshot document){
    if (document["orderStatus"] == "Accepted") {
      return Colors.blueGrey.shade400;
    }
    if (document["orderStatus"] == "Rejected" || document["orderStatus"] == "Cancelled") {
      return Colors.red;
    }
    if (document["orderStatus"] == "Picked Up") {
      return Colors.pink.shade900;
    }
    if (document["orderStatus"] == "On the way") {
      return Colors.purple.shade900;
    }
    if (document["orderStatus"] == "Delivered") {
      return Colors.green.shade900;
    }
    return Colors.orange;
  }

  Icon statusIcon(DocumentSnapshot document){
    if (document["orderStatus"] == "Accepted") {
      return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Rejected" || document["orderStatus"] == "Cancelled") {
      return Icon(Icons.cancel_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Picked Up") {
      return Icon(Icons.cases, color: statusColor(document),);
    }
    if (document["orderStatus"] == "On the way") {
      return Icon(Icons.delivery_dining_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Delivered") {
      return Icon(Icons.shopping_bag_rounded, color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);

  }

  String statusComment(DocumentSnapshot document){
    if (document["orderStatus"] == "Accepted") {
      return "Your order has been accepted by ${document["seller.shopName"]}";
    }
    if (document["orderStatus"] == "Rejected" || document["orderStatus"] == "Cancelled") {
      return "Unfortunately ${document["seller.shopName"]} could not fulfill your order.";
    }
    if (document["orderStatus"] == "Picked Up") {
      return "Your order has been picked up by ${document["deliveryBoy.name"]}";
    }
    if (document["orderStatus"] == "On the way") {
      return "${document["deliveryBoy.name"]} is on the way with your order";
    }
    if (document["orderStatus"] == "Delivered") {
      return "Your order is here! Enjoy your new clothes!";
    }
    if (document["orderStatus"] == "Assigned A Delivery Person") {
      return "${document["deliveryBoy.name"]} is on the way to pick up your order";
    }
    return "Waiting...";
  }

}
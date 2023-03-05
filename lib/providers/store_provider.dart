import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:piga_luku_customers/services/store_services.dart';

import '../screens/welcome_screen.dart';
import '../services/user_services.dart';

class StoreProvider with ChangeNotifier{
  final StoreServices _storeServices = StoreServices();
  final UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  double? userLatitude;
  double? userLongitude;


  Future<void>getUserLocationData(context) async{
    _userServices.getUserById(user!.uid).then((result){
      if (user != null) {
          GeoPoint? userLocation = result['location'];
          userLatitude = userLocation!.latitude;
          userLongitude = userLocation.longitude;
          notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
}



}
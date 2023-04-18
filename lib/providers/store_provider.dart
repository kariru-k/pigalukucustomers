import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piga_luku_customers/services/store_services.dart';

import '../screens/welcome_screen.dart';
import '../services/user_services.dart';

class StoreProvider with ChangeNotifier{
  final StoreServices _storeServices = StoreServices();
  final UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  double? userLatitude;
  double? userLongitude;
  String? selectedStore;
  String? selectedStoreId;
  DocumentSnapshot? storedetails;
  String? distance;


  getSelectedStore(DocumentSnapshot? storeDetails, distance){
    storedetails = storeDetails;
    this.distance = distance;
    notifyListeners();
  }


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


  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }



}
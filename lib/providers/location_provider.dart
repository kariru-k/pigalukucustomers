
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier{

  double? latitude;
  double? longitude;
  bool permissionAllowed = false;
  late LocationPermission? permission;
  late bool serviceEnabled;
  Placemark? selectedAddress = Placemark();
  bool loading = false;
  loc.Location location = loc.Location();


  //Get current position
  Future<void> getCurrentPosition() async{
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        print("GPS device is turned ON");
      }else{
        print("GPS Device is still OFF");
      }
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }  
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permissions are denied forever');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

      latitude = position.latitude;
      longitude = position.longitude;
      permissionAllowed = true;

      final addresses = await placemarkFromCoordinates(latitude!, longitude!);
      selectedAddress = addresses.first;
      notifyListeners();
  }

  void onCameraMove(CameraPosition cameraPosition) async{
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  getMoveCamera() async{
    final addresses = await placemarkFromCoordinates(latitude!, longitude!);
    selectedAddress = addresses.first;
    print('${selectedAddress?.locality}');
    notifyListeners();
  }

  Future<void>savePreferences(double? latitude,double? longitude,Placemark? address) async {
    print(address!.administrativeArea);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble("latitude", latitude!);
    preferences.setDouble("longitude", longitude!);
    preferences.setString("address", "${address.name}");
    preferences.setString("street", "${address.street}");
    preferences.setString("locality", "${address.locality}");

  }


}
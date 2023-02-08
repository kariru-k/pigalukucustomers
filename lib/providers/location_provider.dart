
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier{

  late double latitude = 0.0;
  late double longitude = 100.0;
  bool permissionAllowed = false;
  late LocationPermission? permission;
  late bool serviceEnabled;
  late Placemark selectedAddress = Placemark();
  late bool loading = false;

  //Get current position
  Future<void> getCurrentPosition() async{
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
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

      final addresses = await placemarkFromCoordinates(latitude, longitude);
      selectedAddress = addresses.first;
      notifyListeners();
  }

  void onCameraMove(CameraPosition cameraPosition) async{
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  getMoveCamera() async{
    final addresses = await placemarkFromCoordinates(latitude, longitude);
    selectedAddress = addresses.first;
    print('${selectedAddress.locality}');
  }
}
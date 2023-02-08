import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/screens/login_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late LatLng currentLocation;
  late GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  late User? user;

  @override
  void initState() {
    // Check if user is logged in whle opening map screen
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser(){
    setState(() {
      _loggedIn = true;
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);




    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }


        return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: currentLocation,
                        zoom: 15
                    ),
                    zoomControlsEnabled: true,
                    minMaxZoomPreference: const MinMaxZoomPreference(1.5, 500),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    mapToolbarEnabled: true,
                    onCameraMove: (CameraPosition position) {
                      setState(() {
                        _locating = true;
                      });
                      locationData.onCameraMove(position);
                    },
                    onCameraIdle: () {
                      setState(() {
                        _locating = false;
                      });
                      locationData.getMoveCamera();
                    },
                    onMapCreated: onCreated,
                  ),
                  Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: Image.asset('images/marker.png'),
                      )
                  ),
                  const Center(
                    child: SpinKitPulse(
                      color: Colors.black,
                      size: 100.0
                    )
                  ),
                  Positioned(
                    bottom: 0.0,
                    child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _locating ? LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                              ) : Container(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.location_searching_sharp,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    label: Text(
                                      _locating ? 'Locating...' :
                                      locationData.selectedAddress.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black
                                      ),
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      _locating ? '': locationData.selectedAddress.street.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      _locating ? '': locationData.selectedAddress.locality.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                        _locating ? '': locationData.selectedAddress.administrativeArea.toString()
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: AbsorbPointer(
                                    absorbing: _locating ? true : false,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if(_loggedIn == false){
                                          Navigator.pushNamed(context, LoginScreen.id);
                                        } else {
                                          _auth.updateUser(
                                              id: user?.uid,
                                              number: user?.phoneNumber.toString(),
                                              latitude: locationData.latitude,
                                              longitude: locationData.longitude,
                                              address: '${locationData.selectedAddress.name}, ${locationData.selectedAddress.street}, ${locationData.selectedAddress.locality}, ${locationData.selectedAddress.administrativeArea}'
                                          );
                                          Navigator.pushNamed(context, HomeScreen.id);
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: _locating ? const MaterialStatePropertyAll<Color>(Colors.grey) : MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor)
                                      ),
                                      child: const Text("CONFIRM YOUR LOCATION"),

                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  )
                ],
              ),
            )
        );
      }
    }


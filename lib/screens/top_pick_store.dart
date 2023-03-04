import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:piga_luku_customers/services/store_services.dart';
import 'package:piga_luku_customers/services/user_services.dart';

class TopPickStore extends StatefulWidget {
  const TopPickStore({Key? key}) : super(key: key);

  @override
  State<TopPickStore> createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  final StoreServices _storeServices = StoreServices();
  final UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  double? _userLatitude = 0.0;
  double? _userLongitude = 0.0;

  @override
  void initState() {
    _userServices.getUserById(user!.uid).then((result){
      if (user != null) {
        setState(() {
          GeoPoint? userLocation = result['location'];
          _userLatitude = userLocation!.latitude;
          _userLongitude = userLocation.longitude;
          print(_userLatitude);
          print(_userLongitude);
        });
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
    super.initState();
  }

  String getDistance(location){
    print(_userLatitude);
    print(_userLongitude);
    var distance = Geolocator.distanceBetween(_userLatitude!, _userLongitude!, location.latitude, location.longitude);
    return (distance / 1000).toStringAsFixed(2);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
          if(!snapshot.hasData) return const CircularProgressIndicator();

          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                        height: 30,
                        child: Image.asset("images/like.gif")
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Top Picks For You",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    if(double.parse(getDistance(document['location'])) <= 5){
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Card(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: Image.network(
                                        document['url'],
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                ),
                              ),
                              Container(
                                height: 35,
                                child: Text(
                                  document['shopName'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "${getDistance(document["location"])}km",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

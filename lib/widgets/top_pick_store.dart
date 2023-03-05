import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piga_luku_customers/services/store_services.dart';
import 'package:provider/provider.dart';

import '../providers/store_provider.dart';

class TopPickStore extends StatefulWidget {
  const TopPickStore({Key? key}) : super(key: key);

  @override
  State<TopPickStore> createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  final StoreServices _storeServices = StoreServices();
  User? user = FirebaseAuth.instance.currentUser;
  double? _userLatitude = 0.0;
  double? _userLongitude = 0.0;






  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);

    String getDistance(location){
      var distance = Geolocator.distanceBetween(_storeData.userLatitude as double, _storeData.userLongitude as double, location.latitude, location.longitude);
      return (distance / 1000).toStringAsFixed(2);
    }



    return StreamBuilder<QuerySnapshot>(
      stream: _storeServices.getTopPickedStore(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
        if(!snapshot.hasData) return const CircularProgressIndicator();

        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: CachedNetworkImage(
                                        imageUrl: document['url'],
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
                      return Container(
                        child: const Center(
                          child: Text("Unfortunately there are no stores near your location"),
                        ),
                      );
                    }
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

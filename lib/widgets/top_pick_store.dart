import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/screens/vendor_home_screen.dart';
import 'package:piga_luku_customers/services/store_services.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/store_provider.dart';

class TopPickStore extends StatefulWidget {


  const TopPickStore({super.key});

  @override
  State<TopPickStore> createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {

  var i = 0;

  @override
  Widget build(BuildContext context) {

    final StoreServices storeServices = StoreServices();


    final storeData = Provider.of<StoreProvider>(context);
    storeData.getUserLocationData(context);

    String getDistance(location){
      var distance = Geolocator.distanceBetween(
          storeData.userLatitude as double,
          storeData.userLongitude as double,
          location.latitude,
          location.longitude);
      return (distance / 1000).toStringAsFixed(2);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: storeServices.getTopPickedStore(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
        if(!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator()),
          );
        }

        List shopDistance = [];
        for (int i = 0; i <= snapshot.data!.docs.length-1; i++){
          var distance = Geolocator.distanceBetween(
              storeData.userLatitude as double,
              storeData.userLongitude as double,
              snapshot.data!.docs[i]['location'].latitude,
              snapshot.data!.docs[i]['location'].longitude
          );
          var distanceInKm = distance / 1000;
          shopDistance.add(distanceInKm);
        }
        shopDistance.sort();
        if (shopDistance[0] > 5) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Center(child: Text(
                "Unfortunately there are no Top Picked Stores near you at the moment. Come again later!",
                style: storeCardStyle,
              )),
            ),
          );
        }

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
                        return InkWell(
                          onTap: () {
                            storeData.getSelectedStore(document, getDistance(document['location']));
                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                screen: VendorHomeScreen(documentid: document["uid"],),
                                withNavBar: true,
                                settings: const RouteSettings(name: VendorHomeScreen.id),
                            );
                          },
                          child: Padding(
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
                                  SizedBox(
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
                          ),
                        );
                      } else {
                        return Visibility(
                          visible: false,
                          child: Container(),
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

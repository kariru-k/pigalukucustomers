import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/constants.dart';
import 'package:piga_luku_customers/services/store_services.dart';
import 'package:provider/provider.dart';

import '../providers/store_provider.dart';
import '../screens/vendor_home_screen.dart';

class NearByStores extends StatefulWidget {
  const NearByStores({super.key});

  @override
  State<NearByStores> createState() => _NearByStoresState();
}

class _NearByStoresState extends State<NearByStores> {

  double? latitude;
  double? longitude;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final storeData = Provider.of<StoreProvider>(context);
    storeData.determinePosition().then((position){
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
  }


  String getDistance(location){
    var distance = Geolocator.distanceBetween(latitude as double, longitude as double, location.latitude, location.longitude);
    return (distance / 1000).toStringAsFixed(2);
  }

  final StoreServices _storeServices = StoreServices();

  final PaginateRefreshedChangeListener _refreshedChangeListener = PaginateRefreshedChangeListener();


  @override
  Widget build(BuildContext context) {

    final storeData = Provider.of<StoreProvider>(context);
    storeData.getUserLocationData(context);

    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
          stream: _storeServices.getNearbyStorePagination(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
            if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            List shopDistance = [];
            for (int i = 0; i <= snapshot.data!.docs.length-1; i++){
              var distance = Geolocator.distanceBetween(latitude as double, longitude as double, snapshot.data!.docs[i]['location'].latitude, snapshot.data!.docs[i]['location'].longitude);
              var distanceInKm = distance / 1000;
              shopDistance.add(distanceInKm);
            }
            shopDistance.sort();
            if (shopDistance[0] > 5) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text(
                  "Unfortunately there are no Stores near you at the moment. Come again later!",
                  style: storeCardStyle,
                )),
              );
            }




            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RefreshIndicator(
                    onRefresh: () async{
                      _refreshedChangeListener.refreshed = true;
                      },
                    child: PaginateFirestore(
                      query: _storeServices.getNearbyStore(),
                      footer: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    children: [
                                      Image.asset("images/pigaluku_logo.png", height: 50,),
                                      const Center(
                                        child: Text("No more clothing stores yet, but we will add more soon!"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      bottomLoader: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                        ),
                      ),
                      header: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Stores Near You",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                              child: Text(
                                "Find the Best Fashion Wear Near You!",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, document, index){
                        final data = document[index].data() as Map?;
                        if(double.parse(getDistance(data!['location'])) <= 5){
                          return InkWell(
                            onTap: () {
                              storeData.getSelectedStore(document[index], getDistance(data['location']));
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                  context,
                                  screen: VendorHomeScreen(documentid: data["uid"],),
                                  withNavBar: false,
                                  settings: const RouteSettings(name: VendorHomeScreen.id),
                                  pageTransitionAnimation: PageTransitionAnimation.fade
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 110,
                                      child: Card(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4.0),
                                            child: CachedNetworkImage(
                                              imageUrl: data['url'],
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data["shopName"],
                                          style: storeCardStyle,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(data["description"], style: storeDialogCardStyle,),
                                        const SizedBox(height: 3,),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - 250,
                                          child: Text(
                                            data["address"],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          "${getDistance(data["location"])}km",
                                        ),
                                        const SizedBox(height: 3,),
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text("4.5", style: storeCardStyle,)
                                          ],
                                        )
                                      ],
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
                      },
                      itemBuilderType: PaginateBuilderType.listView,
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}


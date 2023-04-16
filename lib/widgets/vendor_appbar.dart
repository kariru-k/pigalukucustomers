import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/store_provider.dart';

class VendorAppBar extends StatelessWidget {
  const VendorAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _store = Provider.of<StoreProvider>(context);

    mapLauncher() async{

      GeoPoint location = _store.storedetails!["location"];

      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: "${_store.storedetails!["shopName"]} is here",
      );
    }


    return SliverAppBar(
      floating: true,
      snap: true,
      expandedHeight: 250,
      flexibleSpace: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top: 85),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            _store.storedetails!["url"]
                        )
                    ),
                  ),
                  child: Container(
                    color: Colors.grey.withOpacity(.7),
                    child: ListView(
                      children: [
                        Text(
                          _store.storedetails!["description"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                        ),
                        Text(
                          _store.storedetails!["address"],
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                        Text(
                          _store.storedetails!["email"],
                          style: const TextStyle(
                              color: Colors.white
                          ),
                        ),
                        Text(
                          "Distance: ${_store.distance.toString()} km",
                          style: const TextStyle(
                              color: Colors.white
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.white,),
                            Icon(Icons.star, color: Colors.white,),
                            Icon(Icons.star, color: Colors.white,),
                            Icon(Icons.star_half, color: Colors.white,),
                            Icon(Icons.star_outline_outlined, color: Colors.white,),
                            SizedBox(width: 5,),
                            Text("{3.5}", style: TextStyle(color: Colors.white),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.phone),
                                onPressed: () {
                                  launchUrlString("tel: 0${_store.storedetails!["storePhoneNumber"]}");
                                },
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.map),
                                onPressed: () {
                                  mapLauncher();
                                },
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(
          color: Colors.white
      ),
      actions: [
        IconButton(
            onPressed: (){

            },
            icon: const Icon(CupertinoIcons.search)
        )
      ],
      title: Text(
        _store.storedetails!['shopName'],
      ),
    );
  }
}

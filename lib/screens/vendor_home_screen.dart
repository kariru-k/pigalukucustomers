import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/providers/store_provider.dart';
import 'package:piga_luku_customers/screens/welcome_screen.dart';
import 'package:piga_luku_customers/widgets/image_slider.dart';
import 'package:piga_luku_customers/widgets/vendor_banner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/my_appbar.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = "vendor-screen";
  const VendorHomeScreen({Key? key, required this.documentid}) : super(key: key);
  final String documentid;

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);



    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              SliverAppBar(
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
                  _store.selectedStore!,
                ),
              )
            ];
          },
          body: Column(
            children: [
              VendorBanner(userid: documentid,),
            ],
          )
      ),
    );
  }
}

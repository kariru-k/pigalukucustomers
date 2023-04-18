import 'package:flutter/material.dart';
import 'package:piga_luku_customers/widgets/vendor_appbar.dart';
import 'package:piga_luku_customers/widgets/vendor_banner.dart';

import '../widgets/categories_widget.dart';
import '../widgets/products/featured_products.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = "vendor-screen";
  const VendorHomeScreen({Key? key, required this.documentid}) : super(key: key);
  final String documentid;

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              const VendorAppBar(),
            ];
          },
          body: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              VendorBanner(userid: documentid,),
              const VendorCategories(),
              const FeaturedProducts(),
            ],
          )
      ),
    );
  }
}

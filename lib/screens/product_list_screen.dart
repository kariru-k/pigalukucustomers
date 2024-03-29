import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/store_provider.dart';
import 'package:piga_luku_customers/widgets/products/product_filter_widget.dart';
import 'package:piga_luku_customers/widgets/products/product_list.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);
  static const String id = "product-list-screen";

  @override
  Widget build(BuildContext context) {

    var storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              floating: true,
              snap: true,
              expandedHeight: 110,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Container(
                  height: 56,
                  color: Colors.pinkAccent,
                  child: const ProductFilterWidget(),
                ),
              ),
              title: Text(
                storeProvider.selectedProductCategory.toString(),
                style: const TextStyle(
                  color: Colors.white
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.white
              ),
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: const [
              ProductList()
            ]
        ),
      ),
    );
  }
}

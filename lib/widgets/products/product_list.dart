import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/services/product_services.dart';
import 'package:piga_luku_customers/widgets/products/product_card_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/store_provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {



  @override
  Widget build(BuildContext context) {

    ProductServices services = ProductServices();
    var storeprovider = Provider.of<StoreProvider>(context);
    late final Future<QuerySnapshot<Object?>>? _future;


    Future<QuerySnapshot<Object?>>? myFuture(){
      return services.products
          .where("published", isEqualTo: true)
          .where("category.categoryName", isEqualTo: storeprovider.selectedProductCategory)
          .where("category.subCategoryName", isEqualTo: storeprovider.selectedSubProductCategory)
          .where("seller.sellerUid", isEqualTo: storeprovider.storedetails!["uid"])
          .get();
    }

    _future = myFuture();

    return FutureBuilder<QuerySnapshot>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }


        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4)
                ),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${snapshot.data!.docs.length} Products",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return ProductCard(document: document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
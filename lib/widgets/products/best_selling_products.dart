import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/store_provider.dart';
import 'package:piga_luku_customers/services/product_services.dart';
import 'package:piga_luku_customers/widgets/products/product_card_widget.dart';
import 'package:provider/provider.dart';

class BestSellingProducts extends StatelessWidget {
  const BestSellingProducts({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    ProductServices services = ProductServices();

    var store = Provider.of<StoreProvider>(context);


    return FutureBuilder<QuerySnapshot>(
      future: services.products
          .where("published", isEqualTo: true)
          .where("collection", isEqualTo: "Best Selling")
          .where("seller.sellerUid", isEqualTo: store.storedetails!["uid"])
          .orderBy("productName")
          .limitToLast(10)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Container();
        }


        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: const Center(
                    child: Text(
                      "Best Selling Products",
                      style: TextStyle(
                          shadows: <Shadow> [
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black
                            )
                          ],
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key, required this.document}) : super(key: key);
  static const String id = "product_details_screen";
  final DocumentSnapshot? document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {

            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.3),
                    border: Border.all(
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 2, top: 2),
                    child: Text(document!["brand"]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(document!["productName"], style: const TextStyle(fontSize: 23),),
            const SizedBox(
              height: 10,
            ),
            Text(document!["gender"], style: const TextStyle(fontSize: 20),),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Kshs ${document!["price"]}", style: const TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(tag: 'product${document!["productName"]}',child: Image.network(document!["productImage"])),
            ),
            Divider(color: Colors.grey[300], thickness: 6,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("About this product", style: TextStyle(fontSize: 20),),
            ),
            Divider(color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpandableText(
                document!["description"],
                expandText: "View more",
                collapseText: "View less",
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            Divider(color: Colors.grey[400]),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Other Product Information", style: TextStyle(fontSize: 20),),
            ),
            Divider(color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item Code: ${document!["itemCode"]}",
                    style: const TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  Text(
                    "Seller: ${document!["seller.shopName"]}",
                    style: const TextStyle(
                        color: Colors.grey
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 60,)
          ],
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                EasyLoading.show(
                  status: "Adding"
                );
                saveForLater().then((value){
                  EasyLoading.showSuccess(
                    "Saved Successfully",
                  );
                });
              },
              child: Container(
                height: 56,
                color: Colors.grey[800],
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(CupertinoIcons.bookmark, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text(
                            "Save for later",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 56,
              color: Colors.red[400],
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.shopping_basket_outlined, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Add to basket"),
                      ],
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void>saveForLater(){
    CollectionReference favourite = FirebaseFirestore.instance.collection("favourites");
    User? user = FirebaseAuth.instance.currentUser;
    print(document!.data());
    return favourite.add(
        {
          "product": document!.data(),
          "customerId": user!.uid
        }
    );
  }
}

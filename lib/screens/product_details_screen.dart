import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/widgets/products/bottom_sheet_container.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key, required this.document}) : super(key: key);
  static const String id = "product_details_screen";
  final DocumentSnapshot? document;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? dropdownValue;



  @override
  Widget build(BuildContext context) {

    Map quantities = widget.document!["quantity"];
    List sizes = [];

    for (var element in quantities.keys) {
      sizes.add(element);
    }





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
          shrinkWrap: true,
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
                    child: Text(widget.document!["brand"]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(child: Text(widget.document!["productName"], style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900), )),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Gender: ", style: TextStyle(
                    fontSize: 20
                ),),
                Text(widget.document!["gender"], style: const TextStyle(fontSize: 20, color: Colors.red),),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Kshs ${widget.document!["price"]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),)
              ],
            ),
            Row(
              children: [
                const Text("Size: ", style: TextStyle(
                  fontSize: 20
                ),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 280,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color:Colors.lightGreen, //background color of dropdown button
                          border: Border.all(color: Colors.black38, width:1), //border of dropdown button
                          borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                          boxShadow: const <BoxShadow>[ //apply shadow on Dropdown button
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                blurRadius: 5) //blur radius of shadow
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: DropdownButton<String>(
                            value: dropdownValue,
                            hint: const Text("Size"),
                            items: sizes.map((value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.purple,
                                  ),
                                ),
                              );
                            }).toList(),
                            icon: const Padding( //Icon at tail, arrow bottom is default icon
                                padding: EdgeInsets.only(left:20),
                                child:Icon(Icons.arrow_circle_down_sharp)
                            ),
                            borderRadius: BorderRadius.circular(5),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            }
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(tag: '${widget.document!["productName"]}',child: CachedNetworkImage(imageUrl: widget.document!["productImage"])),
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
                widget.document!["description"],
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
                    "Item Code: ${widget.document!["itemCode"]}",
                    style: const TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  Text(
                    "Seller: ${widget.document!["seller.shopName"]}",
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
      bottomSheet: BottomSheetContainer(document: widget.document!, size: dropdownValue,),
    );
  }

  Future<void>saveForLater(){
    CollectionReference favourite = FirebaseFirestore.instance.collection("favourites");
    User? user = FirebaseAuth.instance.currentUser;
    return favourite.add(
        {
          "product": widget.document!.data(),
          "customerId": user!.uid
        }
    );
  }
}

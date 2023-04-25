import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/store_provider.dart';
import 'package:piga_luku_customers/services/product_services.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  const ProductFilterWidget({Key? key}) : super(key: key);

  @override
  State<ProductFilterWidget> createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {

  List _subCatList = [];
  ProductServices services = ProductServices();

  @override
  void didChangeDependencies() {
    var store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection("products")
        .where("category.categoryName", isEqualTo: store.selectedProductCategory)
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc){
            setState(() {
              _subCatList.add(doc["category.subCategoryName"]);
            });
          })
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    var storeData = Provider.of<StoreProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: services.category.doc(storeData.selectedProductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          return Container();
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Container(
            height: 75,
            color: Colors.black45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 10,),
                ActionChip(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                  ),
                  label: Text("All ${storeData.selectedProductCategory}"),
                  onPressed: () {
                    storeData.selectedsubCategory(null);
                  },
                  backgroundColor: Colors.white,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _subCatList.contains(data["subCat"][index]["name"]) ? ActionChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        elevation: 4,
                        label: Text("${data["subCat"][index]["name"]}"),
                        onPressed: () {
                          storeData.selectedsubCategory(data["subCat"][index]["name"]);
                        },
                        backgroundColor: Colors.white,
                      ) : Container(),
                    );
                  },
                )
              ],
            ),
          );
      },
    );
  }
}

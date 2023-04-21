import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:piga_luku_customers/providers/store_provider.dart';
import 'package:piga_luku_customers/screens/product_list_screen.dart';
import 'package:piga_luku_customers/services/product_services.dart';
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {
  const VendorCategories({Key? key}) : super(key: key);

  @override
  State<VendorCategories> createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {

  ProductServices services = ProductServices();

  final List _catList = [];
  @override
  void didChangeDependencies() {
    var store = Provider.of<StoreProvider>(context);
    FirebaseFirestore.instance
        .collection("products").where("seller.sellerUid", isEqualTo: store.storedetails!["uid"])
        .get()
        .then((QuerySnapshot querySnapshot){
          for (var doc in querySnapshot.docs) {
            setState(() {
              _catList.add(doc["category.categoryName"]);
            });
          }
    })
    ;
    super.didChangeDependencies();


  }

  @override
  Widget build(BuildContext context) {

    var storeprovider = Provider.of<StoreProvider>(context);



    return FutureBuilder(
      future: services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something Went wrong..."),
          );
        }

        if (_catList.isEmpty) {
          return const Center(
            child: Text("There are currently no categories to show you"),
          );
        }

        if(!snapshot.hasData){
          return Container();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("images/background.jpeg")
                        )
                      ),
                      child: const Center(
                        child: Text(
                          "Shop By Category",
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
                            fontSize: 30
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: snapshot.data!.docs.map((DocumentSnapshot document){
                  return _catList.contains(document["name"])
                      ?
                      InkWell(
                        onTap: () {
                          storeprovider.selectedCategory(document["name"]);
                          storeprovider.selectedsubCategory(null);
                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                              context,
                              screen: const ProductListScreen(),
                              withNavBar: false,
                              settings: const RouteSettings(name: ProductListScreen.id),
                              pageTransitionAnimation: PageTransitionAnimation.fade
                          );
                        },
                        child: SizedBox(
                          width: 120,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: .5
                              )
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Image.network(document["image"]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text(document["name"], textAlign: TextAlign.center,),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      : const Text("");
                }).toList(),
              ),
            ],
          ),
        );


      },
    );
  }
}

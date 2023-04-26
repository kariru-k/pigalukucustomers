import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:piga_luku_customers/services/cart_services.dart';

class CounterForCard extends StatefulWidget {
  const CounterForCard({Key? key, required this.sizes, required this.document}) : super(key: key);
  final List sizes;
  final DocumentSnapshot document;

  @override
  State<CounterForCard> createState() => CounterForCardState();
}

class CounterForCardState extends State<CounterForCard> {
  String? dropdownValue;
  User? user = FirebaseAuth.instance.currentUser;
  CartServices cart = CartServices();
  int _qty = 1;
  String? _docId;
  bool _exists = false;
  bool _updating = false;

  getCartData(){
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('products')
        .where("productId", isEqualTo: widget.document["productId"])
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            for (var doc in querySnapshot.docs) {
              if (doc["productId"] == widget.document["productId"] && doc["size"] == dropdownValue) {
                setState(() {
                  _exists = true;
                  _docId = doc.id;
                  _qty = doc["qty"];
                });
                break;
              } else {
                setState(() {
                  _exists = false;
                });
              }
            }
          } else {
            setState(() {
              _exists = false;
            });
          }
        });
  }

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getCartData();


    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 40,
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
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: DropdownButton<String>(
                  value: widget.sizes.contains(dropdownValue) ? dropdownValue : null,
                  hint: const Text("Size"),
                  items: widget.sizes.map((value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    );
                  }).toList(),
                  icon: const Padding( //Icon at tail, arrow bottom is default icon
                      padding: EdgeInsets.only(left:20),
                      child:Icon(Icons.arrow_circle_down_sharp)
                  ),
                  underline: Container(),
                  onChanged: (String? value) {
                    dropdownValue = value;
                  }
              ),
            ),
          ),
        ),
        _exists ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.pink
              ),
              borderRadius: BorderRadius.circular(4)
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          _updating = true;
                        });
                        if (_qty == 1) {
                          cart.removeFromCart(_docId).then((value){
                            setState(() {
                              _updating = false;
                              _exists = false;
                            });
                            cart.checkData();
                          });
                        }
                        if (_qty> 1) {
                          setState(() {
                            _qty = (_qty- 1);
                          });
                          var total = _qty * widget.document["price"];
                          cart.updateCartQuantity(_docId, _qty, total).then((value){
                            setState(() {
                              _updating = false;
                            });
                          });
                        }
                      },
                      child: Icon(
                        _qty == 1 ? Icons.delete_outline : Icons.remove,
                        color: Colors.pink,
                      )
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: 30,
                  color: Colors.pink[600],
                  child: Center(
                      child: FittedBox(
                          child: !_updating
                              ?
                          Text(
                            _qty.toString(),
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          )
                              :
                          const Center(child: CircularProgressIndicator(),)
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _qty = (_qty + 1);
                        _updating = true;
                      });
                      var total = _qty * widget.document["price"];
                      cart.updateCartQuantity(_docId, _qty, total).then((value){
                        setState(() {
                          _updating = false;
                        });
                      });
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        :
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              if (dropdownValue != null) {
                EasyLoading.show(status: "Adding To Cart");
                cart.checkSeller().then((shopName){
                  if (shopName == widget.document["seller.shopName"] || shopName == null) {
                    setState(() {
                      _exists = true;
                    });
                    cart.addToCart(widget.document, dropdownValue).then((value){
                      EasyLoading.showSuccess("Added to Cart!");
                    });
                    return;
                  } else {
                    EasyLoading.dismiss();
                    showDialog(shopName: shopName);
                    return;
                  }
                });
              } else {
                EasyLoading.showError("Oops! Please add a particular size!", duration: const Duration(seconds: 5));              }
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(4)
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Text("Add", style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showDialog({shopName}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: const Text("Replace Old Cart Items With New Ones"),
        content: Text("Your cart already Contains Items from $shopName. Add these new Items from ${widget.document["seller.shopName"]} and remove the old ones?"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("No", style: TextStyle(color: Colors.red))
          ),
          TextButton(
              onPressed: (){
                cart.deleteCart().then((value){
                  cart.addToCart(widget.document, dropdownValue).then((value){
                    setState(() {
                      _exists = true;
                    });
                    Navigator.pop(context);
                  });
                });
              },
              child: Text("Yes", style: TextStyle(color: Theme.of(context).primaryColor))
          ),
        ],
      );
    });
  }
}

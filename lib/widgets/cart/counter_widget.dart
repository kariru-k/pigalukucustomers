import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/services/cart_services.dart';

import '../products/add_to_cart_widget.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key, required this.document, required this.quantity, required this.docId}) : super(key: key);
  final DocumentSnapshot document;
  final String docId;
  final int quantity;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int? _qty;
  bool _updating = false;
  bool _exists = true;
  CartServices cart = CartServices();

  @override
  Widget build(BuildContext context) {

    setState(() {
      _qty = widget.quantity;
    });



    return _exists ? Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20
      ),
      height: 56,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                    });
                    if (_qty == 1) {
                      cart.removeFromCart(widget.docId).then((value){
                        setState(() {
                          _updating = false;
                          _exists = false;
                        });
                        cart.checkData();
                      });
                    }
                    if (_qty! > 1) {
                      setState(() {
                        _qty = (_qty! - 1);
                      });
                    }
                    cart.updateCartQuantity(widget.docId, _qty).then((value){
                      setState(() {
                        _updating = false;
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                          _qty == 1 ? Icons.delete_outline : Icons.remove,
                          color: Colors.red
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 8,
                    bottom: 8
                  ),
                  child: _updating
                      ?
                  Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                      )
                  )
                      :
                  Text(
                    _qty.toString(),
                    style: const TextStyle(
                      color: Colors.red
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _qty = (_qty! + 1);
                      _updating = true;
                    });
                    cart.updateCartQuantity(widget.docId, _qty).then((value){
                      setState(() {
                        _updating = false;
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red
                      )
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                          Icons.add,
                          color: Colors.red
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ) : AddToCartWidget(document: widget.document,);
  }
}

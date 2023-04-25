import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/widgets/products/add_to_cart_widget.dart';
import 'package:piga_luku_customers/widgets/products/save_for_later.dart';

class BottomSheetContainer extends StatefulWidget {
  const BottomSheetContainer({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot document;

  @override
  State<BottomSheetContainer> createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SaveForLater(document: widget.document,)),
        Expanded(child: AddToCartWidget(document: widget.document,))
      ],
    );
  }
}

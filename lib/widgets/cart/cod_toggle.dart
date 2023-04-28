import 'package:fk_toggle/fk_toggle.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CodToggleSwitch extends StatefulWidget {
  const CodToggleSwitch({Key? key}) : super(key: key);

  @override
  State<CodToggleSwitch> createState() => _CodToggleSwitchState();
}

class _CodToggleSwitchState extends State<CodToggleSwitch> {
  @override
  Widget build(BuildContext context) {

    var cart = Provider.of<CartProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FkToggle(
          width: 150,
          height: 50,
          selectedColor: Theme.of(context).primaryColor,
          onSelected: (index, instance){
            cart.getPaymentMethod(index);
          },
          labels: const ["Cash on Delivery", "Pay Online"],
      ),
    );
  }
}

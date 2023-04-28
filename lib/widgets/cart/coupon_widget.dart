import 'package:flutter/material.dart';

class CouponWidget extends StatefulWidget {
  const CouponWidget({Key? key}) : super(key: key);

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
        child: Row(
          children: [
            Expanded(
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: "Discount Code? Enter it here"
                    ),
                  ),
                )
            ),
            OutlinedButton(
                onPressed: (){},
                child: const Text("Apply")
            )
          ],
        ),
      ),
    );
  }
}

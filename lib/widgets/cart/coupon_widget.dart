import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/coupon_provider.dart';
import 'package:provider/provider.dart';

class CouponWidget extends StatefulWidget {
  final String couponVendor;
  const CouponWidget({Key? key, required this.couponVendor}) : super(key: key);

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {

  bool enabled = true;
  Color color = Colors.grey;
  var couponTitle = TextEditingController();
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    var coupon = Provider.of<CouponProvider>(context);


    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                        height: 35,
                        child: TextField(
                          controller: couponTitle,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey[300],
                              hintText: "Discount Code? Enter it here"
                          ),
                          onChanged: (String value){
                            if (value.length < 3) {
                              setState(() {
                                color = Colors.grey;
                                enabled = false;
                              });
                              if (value.isNotEmpty) {
                                setState(() {
                                  color = Theme.of(context).primaryColor;
                                  enabled = true;
                                });
                              }
                            }
                          },
                        ),
                      )
                  ),
                  AbsorbPointer(
                    absorbing: enabled ? false : true,
                    child: OutlinedButton(
                        onPressed: (){
                          coupon.getCouponDetails(couponTitle.text, widget.couponVendor).then((value){
                            if (coupon.document == null || value["sellerId"] != widget.couponVendor) {
                              setState(() {
                                coupon.discountRate = 0;
                                _visible = false;
                              });
                              showDialog(
                                code: couponTitle.text,
                                validity: "Not Valid"
                              );
                            }
                            if(coupon.expired != true){
                              setState(() {
                                _visible = true;
                                coupon.expired = false;

                              });
                            }
                            else{
                              setState(() {
                                coupon.discountRate = 0;
                                _visible = false;
                                coupon.expired = false;
                              });
                              showDialog(
                                  code: couponTitle.text,
                                  validity: "Expired"
                              );
                            }
                          });
                        },
                        child: Text(
                          "Apply",
                          style: TextStyle(
                            color: color
                          ),
                        )
                    ),
                  )
                ],
              ),
            ),
            coupon.document != null
                ?
            Visibility(
              visible: _visible,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DottedBorder(
                  color: Colors.black,
                  strokeWidth: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.deepOrangeAccent.withOpacity(.4),
                          ),
                          width: MediaQuery.of(context).size.width - 80,
                          height: 100,
                          child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(coupon.document != null ? coupon.document!["title"]: "Nothing"),
                                ),
                                Divider(color: Colors.grey[300],),
                                Text(coupon.document!["details"]),
                                Text("${coupon.discountRate}% discount on all total purchases"),
                                const SizedBox(height: 10,)
                              ]
                          ),
                        ),
                        Positioned(
                          right: -5.0,
                          top: -10,
                          child: SizedBox(
                            height: 10,
                            child: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: (){
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
                :
            Container()
          ],
        ),
      ),
    );
  }
  
  showDialog({code, validity}){
    showCupertinoDialog(
        context: context, 
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: const Text("APPLY COUPON"),
            content: Text("This discount coupon $code that you have entered is $validity"),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
              )
            ],
          );
        }
    );
  }
}

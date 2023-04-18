import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.document}) : super(key: key);

  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey
          )
        )
      ),
      height: 160,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 140,
                width: 130,
                child: Image.network(document["productImage"]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Brand", style: TextStyle(fontSize: 10),),
                      const SizedBox(height: 6,),
                      const Text("Products", style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 6,),
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[200]
                        ),
                        child: Text(
                          "1 Kg",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]
                          ),),
                      ),
                      const SizedBox(height: 6,),
                      Row(
                        children: const [
                          Text(
                            "\$30",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "\$30",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Card(
                              color: Colors.pink,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 30, top: 7, bottom: 7),
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

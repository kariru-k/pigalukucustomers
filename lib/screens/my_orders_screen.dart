import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piga_luku_customers/providers/order_provider.dart';
import 'package:piga_luku_customers/services/order_services.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders', "Ordered", "Rejected", "Cancelled", 'Accepted', "Assigned A Delivery Person", 'Picked Up',
    'On the Way', 'Delivered'
  ];


  @override
  Widget build(BuildContext context) {

    var orderProvider = Provider.of<OrderProvider>(context);


    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: const Icon(CupertinoIcons.search, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: const C2ChipStyle(
                  borderRadius: BorderRadius.all(Radius.circular(3))
              ),
              value: tag,
              onChanged: (val){
                if (val ==0) {
                  setState(() {
                    orderProvider.status = null;
                  });
                }
                setState((){
                  tag = val;
                  orderProvider.status = null;
                  orderProvider.filterOrder(options[val]);
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: orderServices.orders
                .where("userID", isEqualTo: user!.uid)
                .where("orderStatus", isEqualTo: tag > 0 ? orderProvider.status : null)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.size == 0) {
                return Center(
                  child: Text(tag > 0 ? "No ${options[tag]} orders yet" : "No orders yet"),
                );
              }

              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  horizontalTitleGap: 0,
                                  leading: CircleAvatar(
                                    radius: 14,
                                    child: orderServices.statusIcon(document),
                                  ),
                                  title: Text(
                                    data["orderStatus"],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: orderServices.statusColor(document),
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  subtitle: Text(
                                    "On ${DateFormat.yMMMd().format(DateTime.parse(data["timestamp"]))}",
                                    style: const TextStyle(
                                      fontSize: 12
                                    ),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FittedBox(
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Payment Method: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              data["cod"]  ? "Cash on Delivery" : "Online Payment",
                                              style: const TextStyle(
                                                color: Colors.purpleAccent,
                                                fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Amount: Kshs. ${data["total"]}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //TODO: Delivery boy contact, live location and delivery status

                                if (data["deliveryBoy"] != null) ... [
                                  const Text("Delivery Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      child: Card(
                                        elevation: 4,
                                        child: ListTile(
                                          tileColor: Colors.green.withOpacity(.2),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.grey[300],
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20.0),
                                              child: CachedNetworkImage(
                                                imageUrl: data["deliveryBoy"]["image"],
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          title:  Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
                                                  Text(data["deliveryBoy"]["name"],),
                                                ],
                                              ),
                                              const SizedBox(height: 5,)
                                            ],
                                          ),
                                          subtitle: Text(orderServices.statusComment(document)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                ExpansionTile(
                                  title: const Text(
                                    "Order details",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black
                                    ),
                                  ),
                                  subtitle: const Text(
                                    "View order Details",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                    ),
                                  ),
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: data["products"].length,
                                        itemBuilder: (BuildContext context, int index){
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: CachedNetworkImage(
                                                imageUrl: data["products"][index]["productImage"],
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                            title: Text(
                                              data["products"][index]["productName"]
                                            ),
                                            subtitle: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Quantity: ${data["products"][index]["qty"].toString()}",
                                                ),
                                                Text(
                                                  "Size: ${data["products"][index]["size"].toString()}",
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
                                      child: Card(
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("Seller: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Text(data["seller"]["shopName"])
                                                ],
                                              ),
                                              if (data["discount"] != 0 && data["discount"] != null) ...[
                                                Row(
                                                  children: [
                                                    const Text("Discount: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(
                                                      "Kshs. ${data["discount"].toString()}",
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Discount Code Used: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(
                                                      data["discountCode"].toString(),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(height: 3, color: Colors.grey,)
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      )
    );
  }
}

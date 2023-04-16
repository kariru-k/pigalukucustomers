import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/services/store_services.dart';

class VendorBanner extends StatefulWidget {
  const VendorBanner({Key? key, required this.userid}) : super(key: key);
  final String userid;

  @override
  State<VendorBanner> createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {


  StoreServices services = StoreServices();


  int index = 0;
  int datalength = 1;

  Future getImagesFromDb() async{
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore.collection("vendorbanner").where("sellerUid", isEqualTo: widget.userid).get();
    setState(() {
      datalength = snapshot.docs.length;
    });
    return snapshot.docs;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (datalength != 0)... [
            FutureBuilder(
            future: getImagesFromDb(),
            builder: (_, snapShot){
              return snapShot.data == null ? const Center(child: CircularProgressIndicator(),) : Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarouselSlider.builder(
                  itemCount: snapShot.data.length,
                  itemBuilder: (context, int index, int pageViewIndex){
                    DocumentSnapshot sliderImage = snapShot.data[index];
                    Map? getImage = sliderImage.data() as Map?;
                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          imageUrl: getImage!['imageurl'],
                          fit: BoxFit.fill,
                          width: 640,
                          height: 320,
                        )
                    );
                  },
                  options: CarouselOptions(
                      initialPage: 0,
                      height: 180,
                      viewportFraction: 1,
                      autoPlay: true,
                      onPageChanged: (int i, carouselchangeReason){
                        setState(() {
                          index = i;
                        });
                      }
                  ),
                ),
              );
            },
          ),
            DotsIndicator(
            dotsCount: datalength,
            position: index.toDouble(),
            decorator: DotsDecorator(
                size: const Size.square(5.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                activeColor: Theme.of(context).primaryColor
            ),
          ),
          ]else ... [
            const Text("No Banners To Display")
          ]
        ],
      ),
    );
  }
}

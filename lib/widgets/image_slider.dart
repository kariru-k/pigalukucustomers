import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  int index = 0;
  int datalength = 1;


  @override
  void initState() {
    getImagesFromDb();
    super.initState();
  }

  Future getImagesFromDb() async{
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection("slider").get();
    if (mounted) {
      setState(() {
        datalength = snapshot.docs.length;
      });
    }

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: Colors.white,
      child: Column(
        children: [
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
                          imageUrl: getImage!['image'],
                          fit: BoxFit.fill,
                          width: 640,
                          height: 320,
                        )
                    );
                  },
                  options: CarouselOptions(
                    initialPage: 0,
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
        ],
      ),
    );
  }
}

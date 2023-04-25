import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SaveForLater extends StatelessWidget {
  const SaveForLater({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot? document;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EasyLoading.show(
            status: "Adding"
        );
        saveForLater().then((value){
          EasyLoading.showSuccess(
            "Saved Successfully",
          );
        });
      },
      child: Container(
        height: 56,
        color: Colors.grey[800],
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.bookmark, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text(
                    "Save for later",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<void>saveForLater(){
    CollectionReference favourite = FirebaseFirestore.instance.collection("favourites");
    User? user = FirebaseAuth.instance.currentUser;
    return favourite.add(
        {
          "product": document!.data(),
          "customerId": user!.uid
        }
    );
  }
}

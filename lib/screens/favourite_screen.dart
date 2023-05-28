import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const Center(
        child: Text("Favourites"),
      ),
    );
  }
}

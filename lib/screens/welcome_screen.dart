import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:piga_luku_customers/screens/login_screen.dart';
import 'package:piga_luku_customers/screens/map_screen.dart';
import 'package:piga_luku_customers/screens/onboard_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    final locationData = Provider.of<LocationProvider>(
        context,
        listen: false
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.lightBlueAccent
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            )
        ),
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(child: OnBoardScreen()),
                  const Text('Ready to Order from your nearest shop?'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      setState(() {
                        locationData.loading = true;
                      });
                      await locationData.getCurrentPosition();
                      if(locationData.permissionAllowed){
                        locationData.getCurrentPosition().then((value){
                          Navigator.pushReplacementNamed(context, MapScreen.id);
                          setState(() {
                            locationData.loading = false;
                          });
                        });
                      }else {
                        print('Permission has not been granted');
                        setState(() {
                          locationData.loading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                    child: locationData.loading ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Please Wait a Moment!'),
                        SizedBox(width: 10,),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      ],
                    ) : const Text('Set Delivery Location'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () async{
                      await locationData.getCurrentPosition();
                      if(!locationData.serviceEnabled){
                        print("No location enabled!");
                      }
                      if(locationData.permissionAllowed){
                        locationData.getCurrentPosition().then((value){
                          Navigator.pushReplacementNamed(context, LoginScreen.id);
                        });
                      }else {
                        print('Permission has not been granted');
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                          text: "Already a Customer? ",
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.primaries.first
                                ))
                          ]),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/screens/map_screen.dart';
import 'package:piga_luku_customers/services/user_services.dart';
import 'package:provider/provider.dart';

import 'location_provider.dart';

class AuthProvider with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String? error;
  final UserServices _userServices = UserServices();
  bool loading = false;
  final locationProvider = LocationProvider();
  late String screen;


  Future<void>verifyPhone({required BuildContext context, required String number})async{
    loading = true;
    notifyListeners();



    verificationFailed(FirebaseAuthException e){
      loading = false;
      print(e.code);
      error = e.toString();
      notifyListeners();
    }

    smsOtpSend(String verID, int? resendToken){
      verificationId = verID;

      //open dialog to enter received OTP SMS
      smsOtpDialog(context, number);
    }


    try{
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId){
            verificationId = verId;
          }
      );
      
      
    } catch(e){
      print(e);
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<dynamic>smsOtpDialog(BuildContext context, String number){
    return showDialog(
      context: context,
      builder: (BuildContext context){
      return AlertDialog(
        title: Column(
          children: const [
            Text('Verification Code'),
            SizedBox(height: 5,),
            Text(
              'Enter 6 digit OTP received as SMS',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
              ),)
          ],
        ),
        content: SizedBox(
          height: 85,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: (value){
              smsOtp = value;
            },
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async{
                try{
                  PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsOtp
                  );

                  final User? user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                  final LocationProvider locationData = Provider.of<LocationProvider>(context, listen: false);

                  if(user != null){
                    loading = false;
                    notifyListeners();


                    _userServices.getUserById(user.uid).then((snapshot) => {
                      if(snapshot.exists){
                        if(screen == 'Login'){
                          //Since it's login, no new data thus no need to update
                          Navigator.pushReplacementNamed(context, HomeScreen.id)
                        }else {
                          Navigator.pushReplacementNamed(context, MapScreen.id)
                        }
                      }else {
                        //The user data does not exist s we need to create new data
                        locationData.getCurrentPosition(),
                        _createUser(
                          id: user.uid,
                          number: user.phoneNumber.toString(),
                          location: GeoPoint(locationData.latitude as double, locationData.longitude as double),
                          address: locationData.selectedAddress!.name,
                        ),
                        locationData.savePreferences(locationData.latitude as double, locationData.longitude as double, locationData.selectedAddress),
                        Navigator.pushReplacementNamed(context, HomeScreen.id)
                      }
                    });
                  } else {
                    print("Login failed");
                  }



                }catch(e){
                  error = e.toString();
                  notifyListeners();
                  print(e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Done')
          )
        ],
      );
    }).whenComplete((){
      loading = false;
      notifyListeners();
    });
  }

  void _createUser({required String id, required String number, required GeoPoint location, required String? address}){
    locationProvider.getCurrentPosition();
    _userServices.createUserData({
      'id': id,
      'number': number,
      'location': location,
      'address': address
    });
    loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({required String? id, required String? number, required double? latitude, required double? longitude, required String address}) async{
    try{
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'location': GeoPoint(latitude!.toDouble(), longitude!.toDouble()),
        'address': address,
      });

      loading = false;
      notifyListeners();
      return true;
    } catch(e){
      print("Error $e");
      return false;
    }
  }
}
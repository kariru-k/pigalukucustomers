import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/services/user_services.dart';
import 'package:provider/provider.dart';

import 'location_provider.dart';

class AuthProvider with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  late String error = '';
  final UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider? locationProvider = LocationProvider();


  Future<void>verifyPhone({required BuildContext context, required String number})async{
    loading = true;
    notifyListeners();

    verificationCompleted(PhoneAuthCredential credential) async{
      loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    }

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
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId){
            verificationId = verId;
          }
      );
      
      
    } catch(e){
      print(e);
      error = e.toString();
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

                  //Add user data in firebase after registration
                  if (locationProvider?.selectedAddress != null) {
                    print(locationProvider?.selectedAddress);
                    updateUser(
                        id: user?.uid,
                        number: user?.phoneNumber.toString(),
                        latitude: locationProvider?.latitude,
                        longitude: locationProvider?.longitude,
                        address: '${locationProvider?.selectedAddress.name}, ${locationProvider?.selectedAddress.street}, ${locationProvider?.selectedAddress.locality}, ${locationProvider?.selectedAddress.administrativeArea}'
                    );
                  }  else {
                    _createUser(id: user!.uid, number: user.phoneNumber.toString());
                  }


                  //navigate to Home Page Afterwards if fine
                  if(user!=null){
                    Navigator.of(context).pop();
                    //Go to the home screen
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  }else {
                    print('Login Failed');
                  }
                }catch(e){
                  error = 'Invalid OTP';
                  notifyListeners();
                  print(e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Done')
          )
        ],
      );
    }
    );
  }

  void _createUser({required String id, required String number,double? latitude, double? longitude, String? address}){
    _userServices.createUserData({
      'id': id,
      'number': number,
      'location': GeoPoint(latitude!.toDouble(), longitude!.toDouble()),
      'address': address
    });
  }

  void updateUser({required String? id, required String? number, required double? latitude, required double? longitude, required String address}){
    _userServices.updateUserData({
      'id': id,
      'number': number,
      'location': GeoPoint(latitude!.toDouble(), longitude!.toDouble()),
      'address': address,
    });
  }
}
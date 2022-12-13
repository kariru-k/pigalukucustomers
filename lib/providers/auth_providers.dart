import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piga_luku_customers/screens/home_screen.dart';
import 'package:piga_luku_customers/services/user_services.dart';

class AuthProvider with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  late String error = '';
  final UserServices _userServices = UserServices();

  Future<void>verifyPhone(BuildContext context, String number)async{

    verificationCompleted(PhoneAuthCredential credential) async{
      await _auth.signInWithCredential(credential);
    }

    verificationFailed(FirebaseAuthException e){
      print(e.code);
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
            this.verificationId = verId;
          }
      );
      
      
    } catch(e){
      print(e);
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
                  _createUser(id: user!.uid, number: user.phoneNumber.toString());

                  //navigate to Home Page Afterwards if fine
                  if(user!=null){
                    Navigator.of(context).pop();
                    //Go to the home screen
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context)=>const HomeScreen()
                    ));
                  }else {
                    print('Login Failed');
                  }
                }catch(e){
                  this.error = 'Invalid OTP';
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

  void _createUser({required String id, required String number}){
    _userServices.createUserData({
      'id': id,
      'number': number
    });
  }
}
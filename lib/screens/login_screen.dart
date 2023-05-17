import 'package:flutter/material.dart';
import 'package:piga_luku_customers/providers/auth_providers.dart';
import 'package:piga_luku_customers/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    bool validPhoneNumber = false;
    final phoneNumberController = TextEditingController();
    final locationData = Provider.of<LocationProvider>(context);


    setState(() {
      auth.screen = 'Login';
    });


    return Scaffold(
        body: StatefulBuilder(
          builder: (context, StateSetter myState){
            return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.purple
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 36.0,
                                horizontal: 24.0
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Log In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.w800
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Your next outfit is waiting for you!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w300
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                      prefixText: "+254",
                                      labelText: "Enter Your Phone Number (9 digits)"
                                  ),
                                  autofocus: true,
                                  controller: phoneNumberController,
                                  maxLength: 9,
                                  onChanged: (value){
                                    if(value.length == 9){
                                      myState((){
                                        validPhoneNumber = true;
                                      });
                                    } else {
                                      myState((){
                                        validPhoneNumber = false;
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                                Visibility(
                                  visible: auth.error == null ? false: true,
                                  child: Column(
                                    children: [
                                      Text(
                                          '${auth.error}. Please Try Again!',
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      const SizedBox(height: 5,)
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AbsorbPointer(
                                        absorbing: validPhoneNumber ? false:true,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            locationData.getCurrentPosition();
                                            setState(() {
                                              auth.loading = true;
                                              auth.screen = "MapScreen";
                                            });
                                            String number = '+254${phoneNumberController.text}';
                                              auth.verifyPhone(
                                                context: context,
                                                number: number,
                                              ).then((value){
                                                phoneNumberController.clear();
                                                setState(() {
                                                  auth.loading = false;
                                                });
                                              });
                                          },
                                          style: ButtonStyle(
                                              backgroundColor: validPhoneNumber ? MaterialStateProperty.all(Theme.of(context).primaryColor) : MaterialStateProperty.all(Colors.grey)
                                          ),
                                          child: auth.loading  ? const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ) : Text(validPhoneNumber ? 'CONTINUE' : 'ENTER PHONE NUMBER'),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
            );
          },
        )
    );
  }
}

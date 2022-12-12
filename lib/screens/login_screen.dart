import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _validPhoneNumber = false;

  @override
  Widget build(BuildContext context) {
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
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 36.0,
                                horizontal: 24.0
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
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
                                  maxLength: 9,
                                  onChanged: (value){
                                    if(value.length == 9){
                                      myState((){
                                        _validPhoneNumber = true;
                                      });
                                    } else {
                                      myState((){
                                        _validPhoneNumber = false;
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AbsorbPointer(
                                        absorbing: _validPhoneNumber ? false:true,
                                        child: ElevatedButton(
                                          onPressed: () {
                                          },
                                          style: ButtonStyle(
                                              backgroundColor: _validPhoneNumber ? MaterialStateProperty.all(Theme.of(context).primaryColor) : MaterialStateProperty.all(Colors.grey)
                                          ),
                                          child: Text(
                                              _validPhoneNumber ? 'CONTINUE' : 'ENTER PHONE NUMBER'
                                          ),
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

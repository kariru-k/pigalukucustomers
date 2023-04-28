import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:piga_luku_customers/services/user_services.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);
  static const String id = "update-profile";

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserServices userServices = UserServices();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var emailaddress = TextEditingController();
  var mobilenumber = TextEditingController();


  @override
  void initState() {
    userServices.getUserById(user!.uid).then((value){
      if (mounted) {
        setState(() {
          firstName.text = value["firstName"];
          lastName.text = value["lastName"];
          emailaddress.text = value["email"];
          mobilenumber.text = user!.phoneNumber.toString();
        });
      }
    });
    super.initState();
  }

  updateProfile() async{
      return FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
        "firstName": firstName.text,
        "lastName": lastName.text,
        "email": emailaddress.text
      });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Update Profile"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomSheet: InkWell(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            EasyLoading.show(status: "Updating Profile");
            updateProfile().then((value){
              EasyLoading.showSuccess("Updated Successfully");
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 50,
          color: Colors.blueGrey[900],
          child: const Center(
            child: Text(
              "Update",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: firstName,
                        decoration: const InputDecoration(
                          labelText: "First Name",
                          labelStyle: TextStyle(
                            color: Colors.grey
                          ),
                          contentPadding: EdgeInsets.zero
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter First Name";
                          }
                          return null;

                        },
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: TextFormField(
                        controller: lastName,
                        decoration: const InputDecoration(
                            labelText: "Last Name",
                            labelStyle: TextStyle(
                                color: Colors.grey
                            ),
                            contentPadding: EdgeInsets.zero
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter First Name";
                          }
                          return null;

                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: mobilenumber,
                  enabled: false,
                  decoration: const InputDecoration(
                      labelText: "Mobile Number",
                      labelStyle: TextStyle(
                          color: Colors.grey
                      ),
                      contentPadding: EdgeInsets.zero
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Mobile Number";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailaddress,
                  decoration: const InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(
                          color: Colors.grey
                      ),
                      contentPadding: EdgeInsets.zero
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Email Address";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

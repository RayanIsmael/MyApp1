import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp1/auth/login.dart';

class SignUP extends StatefulWidget {
  SignUP({Key key}) : super(key: key);

  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  String email, password, username;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  GlobalKey<FormState> formkey = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double mediaqury = MediaQuery.of(context).size.height;
    return Scaffold(
        key: scaffoldkey,
        body: SingleChildScrollView(
          //physics:NeverScrollableScrollPhysics() ,
          child: Container(
            height: mediaqury,
            color: Colors.green[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Image.asset(
                  "images/auth.png",
                  height: 200,
                  width: 200,
                )),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            //////////////////////
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onSaved: (newValue) {
                              username = newValue;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Is Empty";
                              } else if (value.length < 8) {
                                return "Wrong Input Value";
                              } else if (value.length > 50) {
                                return "Wrong Input Value";
                              } else {
                                return null;
                              }
                            },
                            ///////////////
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(width: 2)),
                                hintText: "UserName",
                                prefixIcon: Icon(Icons.person),
                                labelText: "User Name",
                                labelStyle: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            //////////////////////
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onSaved: (newValue) {
                              email = newValue;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Is Empty";
                              } else if (value.length < 10) {
                                return "Wrong Input Value";
                              } else if (value.length > 50) {
                                return "Wrong Input Value";
                              } else {
                                return null;
                              }
                            },
                            ///////////////
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(width: 2)),
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email),
                                labelText: "Email",
                                labelStyle: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            //////////////////////
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onSaved: (newValue) {
                              password = newValue;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Is Empty";
                              } else if (value.length < 10) {
                                return "Wrong Input Value";
                              } else {
                                return null;
                              }
                            },
                            ///////////////
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(width: 2)),
                                hintText: "Password",
                                prefixIcon: Icon(Icons.password_rounded),
                                labelText: "Password",
                                labelStyle: TextStyle(fontSize: 18)),
                            obscureText: true,
                          ),
                          /////////////////////////
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 65),
                            child: Row(
                              children: [
                                Text(
                                  "If You Have account",
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (contax) => Login()));
                                  },
                                  child: Text(
                                    '  Click Here',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          /////////////////////////
                          InkWell(
                              onTap: () => logup(),
                              child: Container(
                                // this containar maked by Adobe XD
                                margin: EdgeInsets.only(top: 20),
                                alignment: Alignment.center,
                                width: 200.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21.0),
                                  color: Colors.green[700],
                                  border: Border.all(
                                    width: 2.0,
                                    // color: Colors.green[900],//themdata
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }

  logup() async {
    var formdata = formkey.currentState;
    if (formdata.validate()) {
      formdata.save();
      /////////////////////////////
      try {
        showDialog();
        // ignore: unused_local_variable
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);
        ////////// Save name and email in firestore
        await FirebaseFirestore.instance.collection('users').add({
          "username": username,
          "email":email
        });
        //////////////////////////////
        Navigator.of(context).pushReplacementNamed("HomePage");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop(); //to close AlertDialog
          ////////////////////////////
          var snackbar = SnackBar(
            content: Text("The password provided is too weak."),
            duration: Duration(seconds: 1),
          );
          // ignore: deprecated_member_use
          scaffoldkey.currentState.showSnackBar(snackbar);
          ///////////////////////////
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop(); //to close AlertDialog
          ////////////////////////////
          var snackbar = SnackBar(
            content: Text("The account already exists for that email."),
            duration: Duration(seconds: 1),
          );
          // ignore: deprecated_member_use
          scaffoldkey.currentState.showSnackBar(snackbar);
          ///////////////////////////

        } else if (e.code == 'invalid-email') {
          Navigator.of(context).pop(); //to close AlertDialog
          ////////////////////////////
          var snackbar = SnackBar(
            content: Text("invalid-email."),
            duration: Duration(seconds: 1),
          );
          // ignore: deprecated_member_use
          scaffoldkey.currentState.showSnackBar(snackbar);
          ///////////////////////////
        }
      } catch (e) {
        Navigator.of(context).pop(); //to close AlertDialog
        print(e);
      }
      ////////////////////////////

    } else {
      ////////////////////////////
      var snackbar = SnackBar(
        content: Text("invalid-Input"),
        duration: Duration(seconds: 1),
      );
      // ignore: deprecated_member_use
      scaffoldkey.currentState.showSnackBar(snackbar);
      ///////////////////////////
    }
  }

  ////Alert Dialog////
  showDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER, //more
      animType: AnimType.SCALE, //more
      body: Container(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(),
          )),
      ////more....
    )..show();
  }
  ///////////////////
}

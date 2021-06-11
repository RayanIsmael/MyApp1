import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp1/auth/signup.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  GlobalKey<FormState> formkey = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double mediaqury =
        MediaQuery.of(context).size.height; //auto get height phone
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
                              prefixIcon: Icon(Icons.person),
                              labelText: "Email",
                              labelStyle: TextStyle(fontSize: 18),
                            ),
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
                              } else if (value.length < 5) {
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
                                prefixIcon: Icon(Icons.person),
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
                                  "If You Have't account",
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (contax) => SignUP(),
                                    ));
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
                              onTap: () => login(),
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
                                  'Login',
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

  login() async {
    var formatdata = formkey.currentState;
    if (formatdata.validate()) {
      formatdata.save();
      ///////////////////////////
      try {
        showDialog();
        // ignore: unused_local_variable
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context).pushReplacementNamed("HomePage");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          ////////////////////////////
          var snackbar = SnackBar(
            content: Text("No user found for that email."),
            duration: Duration(seconds: 1),
          );

          scaffoldkey.currentState
              // ignore: deprecated_member_use
              .showSnackBar(snackbar);
          ///////////////////////////
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          ////////////////////////////
          var snackbar = SnackBar(
            content: Text("Wrong password provided for that user."),
            duration: Duration(seconds: 1),
          );

          scaffoldkey.currentState
              // ignore: deprecated_member_use
              .showSnackBar(snackbar);
          ///////////////////////////
        } else if (e.code == 'invalid-email') {
          Navigator.of(context).pop();
          ////////////////////////////
          var snackbar = SnackBar(
            content: Text("invalid-email"),
            duration: Duration(seconds: 1),
          );

          scaffoldkey.currentState
              // ignore: deprecated_member_use
              .showSnackBar(snackbar);
          ///////////////////////////
        }
      }
      ///////////////////////////
    } else {
      print("Un Valid");
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

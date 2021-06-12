import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  Add({Key key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  var imagepicker = ImagePicker();
  var image_url;
  @override
  Widget build(BuildContext context) {
    double mediaqury = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Note'),
          titleSpacing: 2,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: mediaqury - 80,
            color: Colors.green[100],
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLength: 20,
                      decoration: InputDecoration(
                          labelText: "Note Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Note Title"),
                    ),
                    ///////////
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLength: 200,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: "Note",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Note"),
                    ),
                    ///////////
                  ],
                )),
                ////////////////////////
                InkWell(
                    onTap: () {
                      Show(context);
                    },
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
                        'Add Image For Note',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    )),
                /////////////////////////////
                InkWell(
                    onTap: () {},
                    child: Container(
                      // this containar maked by Adobe XD
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.center,

                      width: 2000.0,
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
                        'Add Note',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Show(context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.elliptical(150, 30))),
        builder: (context) {
          return Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera_back),
                  title: Text('Studio'),
                  onTap: () async {
                    var imgpick =
                        await imagepicker.getImage(source: ImageSource.gallery);
                    if (imgpick != null) {
                      File file = File(imgpick.path);
                      int random = Random().nextInt(100000);
                      String imagename =
                          "$random" + "${basename(imgpick.path)}";
                      Reference ref = FirebaseStorage.instance
                          .ref("image")
                          .child(imagename);
                      await ref.putFile(file);
                      image_url =await  ref.getDownloadURL();
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    var imgpick =
                        await imagepicker.getImage(source: ImageSource.camera);
                    if (imgpick != null) {
                      File file = File(imgpick.path);
                      int random = Random().nextInt(100000);
                      String imagename =
                          "$random" + "${basename(imgpick.path)}";
                      Reference ref = FirebaseStorage.instance
                          .ref("image")
                          .child(imagename);
                      await ref.putFile(file);
                      image_url =await  ref.getDownloadURL();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}

import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Edit extends StatefulWidget {
  final docid;
  final oldtitle;
  final oldnote;
  final oldimage;
  Edit({Key key, this.docid, this.oldtitle, this.oldnote,this.oldimage}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  CollectionReference refnote = FirebaseFirestore.instance.collection("note");
  Reference ref;
  File file;

  var imagepicker = ImagePicker();
  var title, note, image_url;
  bool checkimage = false;
  Map<String, dynamic> alldata;
  @override
  Widget build(BuildContext context) {
    double mediaqury = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Note'),
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
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: widget.oldtitle,
                          //////
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (newValue) {
                            title = newValue;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Is Empty";
                            } else if (value.length < 2) {
                              return "Wrong Input Value";
                            } else if (value.length > 20) {
                              return "Wrong Input Value";
                            } else {
                              return null;
                            }
                          },
                          ///////
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
                          initialValue: widget.oldnote,
                          //////
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (newValue) {
                            note = newValue;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Is Empty";
                            } else if (value.length < 2) {
                              return "Wrong Input Value";
                            } else if (value.length > 200) {
                              return "Wrong Input Value";
                            } else {
                              return null;
                            }
                          },
                          ///////
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
                        SizedBox(height: 30,),
                        //////Image////
                        Text("Old Image",style: TextStyle(fontSize: 18,color: Colors.black87),),
                        Container(

                          child: Image.network(
                                widget.oldimage,
                                height: 120,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                        ),
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
                      width: 250.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21.0),
                        color: Colors.green[700],
                        border: Border.all(
                          width: 2.0,
                          // color: Colors.green[900],//themdata
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Edit Image For Note',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          checkimage
                              ? Icon(Icons.check_circle_outline_outlined,
                                  color: Colors.white)
                              : Icon(
                                  Icons.report_problem_outlined,
                                  color: Colors.amber,
                                ),
                        ],
                      ),
                    )),
                /////////////////////////////
                InkWell(
                    onTap: () async {
                      await editnote(context);
                    },
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
                        'Edit Note',
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
                      file = File(imgpick.path);
                      int random = Random().nextInt(100000);
                      String imagename =
                          "$random" + "--" + "${basename(imgpick.path)}";
                      ref = FirebaseStorage.instance
                          .ref("image")
                          .child(imagename);
                      setState(() {
                        checkimage = true;
                      });
                      Navigator.of(context).pop();
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
                      file = File(imgpick.path);
                      int random = Random().nextInt(100000);
                      String imagename =
                          "$random" + "--" + "${basename(imgpick.path)}";
                      ref = FirebaseStorage.instance
                          .ref("image")
                          .child(imagename);
                      setState(() {
                        checkimage = true;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  //////Edit Note////
  editnote(context) async {
    var formdata = formkey.currentState;
    if (file == null) {
      if (formdata.validate()) {
        showDialog(context);
        formdata.save();
        refnote.doc(widget.docid).update({
          "title": title,
          "note": note,
        });
        Navigator.of(context).pushNamed("HomePage");
      }
    } else {
      if (formdata.validate()) {
        showDialog(context);
        formdata.save();
        await ref.putFile(file);
        image_url = await ref.getDownloadURL();
        refnote.doc(widget.docid).update({
          "title": title,
          "note": note,
          "image_url": image_url,
        });
        Navigator.of(context).pushNamed("HomePage");
      }
    }
  }

  //////Add Note////
  ////Alert Dialog////
  showDialog(context) {
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
}

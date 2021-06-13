import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp1/auth/login.dart';
import 'package:myapp1/create/editNote.dart';
import 'package:myapp1/create/viewnote.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
/////*************************************/////
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  /////*************************************/////
  FirebaseAuth auth = FirebaseAuth.instance;
  /////*************************************/////
  Map<String, dynamic> noteinfo;
  @override
  void initState() {
    auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Login(),
        ));
      } else {
        /////////////////
        var snackbar = SnackBar(
          content: Text("Hello: ${user.email}"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        ///////////////////////////
      }
    });
    super.initState();
  }

/////*************************************/////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('HOME PAGE'),
        titleSpacing: 2,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      ////////
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("note")
            .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      child: Row(
                        children: [
                          /////////////////////
                          Expanded(
                              flex: 1,
                              child: Image.network(
                                snapshot.data.docs[index].data()["image_url"],
                                height: 80,
                                width: 40,
                                fit: BoxFit.fill,
                              )),
                          ////////////////////
                          Expanded(
                            flex: 4,
                            child: ListTile(
                              onTap: () {
                                /////////
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return View(
                                    title: snapshot.data.docs[index]
                                        .data()["title"],
                                    image: snapshot.data.docs[index]
                                        .data()["image_url"],
                                    note: snapshot.data.docs[index]
                                        .data()["note"],
                                  );
                                }));
                                /////////
                              },
                              title: Text(
                                  snapshot.data.docs[index].data()["title"]),
                              subtitle: Text(
                                  snapshot.data.docs[index].data()["note"]),
                              trailing: Wrap(spacing: 0, children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => Edit(
                                          docid: snapshot.data.docs[index].id,
                                          oldtitle: snapshot.data.docs[index]
                                              .data()["title"],
                                          oldnote: snapshot.data.docs[index]
                                              .data()["note"],
                                          oldimage: snapshot.data.docs[index]
                                              .data()["image_url"],
                                        ),
                                      ));
                                    },
                                    icon: Icon(
                                      Icons.drive_file_rename_outline_outlined,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      showDialog(context);
                                      /////
                                      await FirebaseFirestore.instance
                                          .collection("note")
                                          .doc(snapshot.data.docs[index].id)
                                          .delete();
                                      //////
                                      await FirebaseStorage.instance
                                          .refFromURL(snapshot.data.docs[index]
                                              .data()['image_url'])
                                          .delete();
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red[300],
                                    ))
                              ]),
                            ),
                          ),
                          ////////////////
                        ],
                      ),
                    ),
                    ///////////////////
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Text("Error");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      ///////
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("AddNote");
        },
      ),
    );
  }

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
  ///////////////////
}

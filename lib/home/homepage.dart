import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp1/auth/login.dart';

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
          duration: Duration(seconds: 10),
          backgroundColor: Colors.blue,
          action: SnackBarAction(
            label: "Ok",
            onPressed: () {},
            textColor: Colors.red,
          ),
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
                                height: 60,
                                width: 40,
                                fit: BoxFit.fill,
                              )),
                          ////////////////////
                          Expanded(
                            flex: 4,
                            child: ListTile(
                              title: Text(
                                  snapshot.data.docs[index].data()["title"]),
                              subtitle: Text(
                                  snapshot.data.docs[index].data()["note"]),
                              trailing: Wrap(spacing: 0, children: <Widget>[
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.drive_file_rename_outline_outlined,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                IconButton(
                                    onPressed: () {},
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
          return CircularProgressIndicator();
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
}

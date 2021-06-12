import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp1/auth/login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List note = [
    {"note": "this is  home note,this is  home note", "image": "44no.png"},
    {
      "note": "this is  shoping note,this is  shoping note",
      "image": "22sh.png"
    },
    {"note": "this is  work note,this is  work note", "image": "33w.png"},
    {"note": "this is  fixcar note,this is  fixcar note", "image": "11c.png"},
  ];
/////*************************************/////
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  /////*************************************/////
  FirebaseAuth auth = FirebaseAuth.instance;
  /////*************************************/////
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
        title: Text('Home Page'),
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: note.length,
            itemBuilder: (context, i) {
              return MyList(
                note: note[i],
              );
            }),
      ),
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

class MyList extends StatelessWidget {
  final note;
  MyList({this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Row(
            children: [
              /////////////////////
              Expanded(
                  flex: 1,
                  child: Image.asset(
                    "images/${note['image']}",
                    height: 40,
                    width: 40,
                  )),
              ////////////////////
              Expanded(
                flex: 4,
                child: ListTile(
                  title: Text("Title"),
                  subtitle: Text("${note['note']}"),
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
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp1/create/add.dart';
import 'package:myapp1/create/show.dart';
import 'package:myapp1/home/homepage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
////////////////////// 85 - Theme
      theme: ThemeData(
        primaryColor: Colors.green[900],
        buttonColor: Colors.green[900],
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.w200
          )
        )
      ),

////////////////////////
      routes: {
        "HomePage" :(context) => HomePage(),
        "AddNote" : (context) => Add(),
        "show" : (context) => MyHomePage(),
      },
    
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}

import 'package:flutter/material.dart';

class View extends StatefulWidget {
  final image;
  final title;
  final note;
  View({Key key, this.image, this.title, this.note}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('View Note'),
        ),
        /////////////
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ////
              Container(
                child: Image.network(
                  widget.image,
                  height: 200,
                  width: 300,
                ),
              ),
              ////
              Container(
                margin: EdgeInsets.all(20),
                child: Text(widget.title,
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
              ),
              ////
              Container(
                margin: EdgeInsets.all(20),
                child: Text(widget.note,
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
              ),
              ////
            ],
          ),
        )
        /////////////
        );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CourseSelector extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
            child: ListTile(
          title: Text("The Talons at Country Hills"),
          trailing: Icon(Icons.navigate_next),
        )),
        Card(
            child: ListTile(
          title: Text("The Ridge at Country Hills"),
          trailing: Icon(Icons.navigate_next),
        ))
      ],
    );
  }
}

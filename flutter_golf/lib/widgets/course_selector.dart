import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'course_selector.g.dart';

@widget
Widget courseSelector() {
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

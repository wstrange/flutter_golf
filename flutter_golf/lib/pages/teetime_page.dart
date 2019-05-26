import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';

part 'teetime_page.g.dart';

// Widget to book a tee time on the course at the given date and time
@widget
Widget teeTimePage(String courseId, DateTime date, String teeTimeRef) {
  return SafeArea(
    child: Scaffold(
        appBar: AppBar(title: Text("Course $courseId")),
        body: Column(
          children: [
            Expanded(child: Text("date $date")),
            Text('Booking tee time...'),
            CircularProgressIndicator(),
          ],
        )),
  );
}

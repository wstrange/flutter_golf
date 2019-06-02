import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';
import '../svc/teetimes_svc.dart';

// Widget to book a tee time on the course at the given date and time

class TeeTimePage extends HookWidget {
  String courseId;
  DateTime date;
  String teeTimeRef;

  TeeTimePage({Key key, this.courseId, this.date, this.teeTimeRef})
      : super(key: key);

  Widget build(BuildContext context) {
    final teeTimeSvc = useMemoized(() => TeeTimeService());
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Course $courseId")),
          body: Column(
            children: [
              Text("date $date"),
              Text('Booking tee time... for $courseId'),
              RaisedButton(
                  child: Text("Book Time"),
                  onPressed: () {
                    teeTimeSvc.bookTeeTime(courseId, date, teeTimeRef);
                  }),
            ],
          )),
    );
  }
}

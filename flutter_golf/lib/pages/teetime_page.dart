import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';
import '../svc/teetimes_svc.dart';

// Widget to book a tee time on the course at the given date and time

class TeeTimePage extends HookWidget {
  TeeTime teeTime;

  TeeTimePage({Key key, this.teeTime}) : super(key: key);

  Widget build(BuildContext context) {
    final teeTimeSvc = useMemoized(() => TeeTimeService());
    final numberSpots = useState( () => value: this.teeTime.availableSpots);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Course ${teeTime.courseID}")),
          body: Column(
            children: [
              Text("date ${teeTime.dateTime}"),
              RaisedButton(
                  child: Text("Book Time"),
                  onPressed: () {
                    teeTimeSvc.bookTeeTime(teeTime, 1);
                  }),
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_golf/pages/teetime_page.dart';
import 'package:flutter_golf/svc/teetimes_svc.dart';
import '../util/date_format.dart' as util;
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';
import 'package:provider/provider.dart';

class TeeSheetPage extends StatelessWidget {
  final Course course;
  final DateTime date;

  TeeSheetPage({Key key, this.course, this.date}) : super(key: key);

  Widget build(BuildContext context) {
    print("Build TeeSheetPage");
    var svc = Provider.of<TeeTimeService>(context);
    var teeTimeStream = svc.getTeeTimes(course.id, date);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text(course.name)),
          body: Column(
            children: [
              Expanded(
                  child: StreamBuilder<List<TeeTime>>(
                      stream: teeTimeStream,
                      builder: (context, snapshot) {
                        return _CreateTeeSheet(snap: snapshot, course: course);
                      })),
            ],
          )),
    );
  }
}

class _CreateTeeSheet extends StatefulWidget {
  final AsyncSnapshot<List<TeeTime>> snap;
  final Course course;

  _CreateTeeSheet({Key key, this.snap, this.course}) : super(key: key);

  @override
  _TeeSheetState createState() => _TeeSheetState();
}

class _TeeSheetState extends State<_CreateTeeSheet> {
  @override
  Widget build(BuildContext context) {
    if (!widget.snap.hasData) {
      return Text("Tee Sheet not available for this day!");
    }

    var times = widget.snap.data;
    return ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, position) {
          return _TeeTimeSlot(teeTime: times[position], course: widget.course);
        });
  }
}

class _TeeTimeSlot extends StatelessWidget {
  final TeeTime teeTime;
  final Course course;

  _TeeTimeSlot({this.teeTime, this.course});

  @override
  Widget build(BuildContext context) {
    int openSpots = teeTime.availableSpots;
    if (openSpots < 0) openSpots = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.golf_course),
            Text(
              util.dateToHHMM(teeTime.dateTime),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            for (int i = 0; i < openSpots; ++i) Icon(Icons.person_outline),
            Expanded(child: SizedBox()),
            RaisedButton(
              child: Icon(Icons.chevron_right),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TeeTimePage(teeTime: teeTime, course: course)));
              },
            )
          ],
        ),
        Card(
          margin: EdgeInsets.all(4.0),
          color: Colors.grey,
          child: Row(
            children: <Widget>[
              Text("Availabe ${teeTime.availableSpots}"),
              for (int i = 0; i < openSpots; ++i) Icon(Icons.person_outline),
            ],
          ),
        ),
      ],
    );
  }
}

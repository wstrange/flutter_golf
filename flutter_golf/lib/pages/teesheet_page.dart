import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../svc/teetimes_svc.dart';
import '../util/date_format.dart' as util;
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';
import 'teetime_page.dart';

class TeeSheetPage extends HookWidget {
  final String courseId;
  final DateTime date;

  TeeSheetPage({Key key, this.courseId, this.date}) : super(key: key);

  Widget build(BuildContext context) {
    final svc = TeeTimeService();
    final stream = useMemoized(() => svc.getTeeSheetStream(courseId, date));
    final teeTimeStream = useStream(stream);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Country Hills Talons")),
          body: Column(
            children: [
              Expanded(
                  child:
                      _CreateTeeSheet(snap: teeTimeStream, courseId: courseId)),
            ],
          )),
    );
  }
}

class _CreateTeeSheet extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> snap;
  final String courseId;

  _CreateTeeSheet({Key key, this.snap, this.courseId}) : super(key: key);

  @override
  _TeeSheetState createState() => _TeeSheetState();
}

class _TeeSheetState extends State<_CreateTeeSheet> {
  @override
  Widget build(BuildContext context) {
    if (!widget.snap.hasData) {
      return Text("Tee Sheet not available for this day!");
    }

    var teeTime = TeeSheet.fromMap(widget.snap.data.data);
    var times = teeTime.teeTimes;
    //print("tee Times $times");
    var l = times.keys.toList()..sort();
    return ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, position) {
          var k = l[position];
          var v = times[k].toString();
          return _CreateTile(courseId: widget.courseId, time: k, teeTimeRef: v);
        });
  }
}

class _CreateTile extends StatelessWidget {
  final String courseId;
  final DateTime time;
  final String teeTimeRef;

  _CreateTile({Key key, this.courseId, this.time, this.teeTimeRef})
      : super(key: key);

  Widget build(BuildContext context) {
    var t = "available";
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        leading: Text(util.dateToHHMM(time)),
        title: Text(t),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20.0),
        dense: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeeTimePage(
                      courseId: courseId, date: time, teeTimeRef: teeTimeRef)));
          print("Tee time $time selected!");
        },
      ),
    );
  }
}

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
    final stream = useMemoized(() => svc.getTeeTimes(courseId, date));
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
  final AsyncSnapshot<List<TeeTime>> snap;
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

    var times = widget.snap.data;
    //print("tee Times $times");
    return ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, position) {
          return _CreateTile(
              courseId: widget.courseId, teeTime: times[position]);
        });
  }
}

class _CreateTile extends StatelessWidget {
  final String courseId;
  final TeeTime teeTime;

  _CreateTile({Key key, this.courseId, this.teeTime}) : super(key: key);

  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        leading: Text(util.dateToHHMM(teeTime.dateTime)),
        title: Text("Available: ${teeTime.availableSpots}"),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20.0),
        dense: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeeTimePage(teeTime: teeTime)));
        },
      ),
    );
  }
}

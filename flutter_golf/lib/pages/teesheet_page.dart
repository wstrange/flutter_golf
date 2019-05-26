import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../svc/teetimes_svc.dart';
import '../util/date_format.dart' as util;
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';
import 'teetime_page.dart';

part 'teesheet_page.g.dart';

@widget
Widget teeSheetPage(String courseId, DateTime date) {
  final svc = TeeTimeService();
  final stream = useMemoized(() => svc.getTeeSheetStream(courseId, date));
  final teeTimeStream = useStream(stream);

  return SafeArea(
    child: Scaffold(
        appBar: AppBar(title: Text("Country Hills Talons")),
        body: Column(
          children: [
            Expanded(child: _CreateTeeSheet(teeTimeStream, courseId)),
          ],
        )),
  );
}

@widget
Widget _createTeeSheet(AsyncSnapshot<DocumentSnapshot> snap, String courseId) {
  if (!snap.hasData) {
    return Text("Tee Sheet not available for this day!");
  }

  var teeTime = TeeSheet.fromMap(snap.data.data);
  var times = teeTime.teeTimes;
  //print("tee Times $times");
  var l = times.keys.toList()..sort();
  return ListView.builder(
      itemCount: times.length,
      itemBuilder: (context, position) {
        var k = l[position];
        var v = times[k].toString();
        return _CreateTile(courseId, k, v);
      });
}

@widget
Widget _createTile(
    BuildContext context, String courseId, DateTime time, String teeTimeRef) {
  print("Cfreate tile");
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
                builder: (context) => TeeTimePage(courseId, time, teeTimeRef)));
        print("Tee time $time selected!");
      },
    ),
  );
}

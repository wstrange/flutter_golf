import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../svc/teetimes_svc.dart';
import 'package:provider/provider.dart';
import '../util/date_format.dart' as util;
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';

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
            Expanded(child: _CreateTeeSheet(teeTimeStream)),
            MaterialButton(
              child: Text("Reload"),
              onPressed: () {
                var d = date;
                svc.refreshTeeSheet(courseId, d);
              },
            )
          ],
        )),
  );
}

@widget
Widget _createTeeSheet(AsyncSnapshot<DocumentSnapshot> snap) {
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
        return _CreateTile(util.dateToHHMM(k), v);
      });
}

@widget
Widget _createTile(String time, String teeTimeRef) {
  var t = "available";
  return Card(
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      leading: Text(time),
      title: Text(t),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20.0),
      dense: true,
      onTap: () {
        print("Tee time $time selected!");
      },
    ),
  );
}
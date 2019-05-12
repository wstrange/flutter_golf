import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../svc/teetimes_svc.dart';
import 'package:provider/provider.dart';
import '../util/date_format.dart' as util;

class TeeSheetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TeeSheetPageState();
}

class _TeeSheetPageState extends State<TeeSheetPage> {
  String course = "ECS1WnnFLNrn2wPe8WUc";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Country Hills Talons")),
          body: Column(
            children: [
              Expanded(child: _createTeeSheet()),
              MaterialButton(
                child: Text("Reload"),
                onPressed: () {
                  var svc = Provider.of<TeetimeService>(context);
                  var d = DateTime(2019, 5, 5, 8);
                  svc.refreshTeeSheet(course, d);
                },
              )
            ],
          )),
    );
  }

  Widget _createTeeSheet() {
    return Consumer<TeetimeService>(builder: (context, tsvc, _) {
      var teeSheet = tsvc.teeSheet;
      if (teeSheet == null || teeSheet.teeTimes == null) {
        return Text("Tee Sheet not available for this day!");
      }
      var times = teeSheet.teeTimes;
      var l = times.keys.toList()..sort();
      return ListView.builder(
          itemCount: times.length,
          itemBuilder: (context, position) {
            var k = l[position];
            var v = times[k].toString();
            return _createTile(util.dateToHHMM(k), v);
          });
    });
  }

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
          print("Tee time $time selected");
        },
      ),
    );
  }
}

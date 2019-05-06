import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../svc/repo_service.dart';

class TeeSheetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TeeSheetPageState();
}

class _TeeSheetPageState extends State<TeeSheetPage> {
  Map<String, String> teeSheet;

  @override
  void initState() {
    super.initState();

    teeSheet = RepoService().emptyTeeSheet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Country Hills Talons")),
            body: Row(
              children: [Expanded(child: _createTeeSheet(teeSheet))],
            )));
  }

  Widget _createTeeSheet(Map<String, String> teeSheet) {
    var teeTimes = teeSheet.keys.toList();

    return ListView.builder(
        itemCount: teeSheet.length,
        itemBuilder: (context, position) {
          var t = teeTimes[position];
          return _createTile(t, teeSheet[t]);
        });
  }
//  }
//
//  List<Widget> _oldTile(String time, String teeTimeRef) => [
//    Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Text(time,
//          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
//    ),
//    Padding(
//      padding: const EdgeInsets.fromLTRB(30.0, 6.0, 12.0, 12.0),
//      child: Text(teeSheet[teeTimeRef],
//          style: TextStyle(fontSize: 18.0)),
//    ),
//  ];
//
//  ),
//  Divider(
//  height: 2.0,
//  color: Colors.grey,
//  )
//  ];

  Widget _createTile(String time, String teeTimeRef) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Text(time),
      title: Text(teeTimeRef),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
    onTap: () { print("Tee time $time selected");},);
}

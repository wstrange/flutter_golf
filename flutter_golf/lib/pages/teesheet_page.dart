import 'package:flutter/material.dart';
import 'package:flutter_golf/pages/teetime_page.dart';
import 'package:flutter_golf/svc/teetimes_svc.dart';
import '../util/date_format.dart' as util;
import '../model/models.dart';
import 'package:provider/provider.dart';

class TeeSheetPage extends StatefulWidget {
  final Course course;
  final DateTime date;

  TeeSheetPage({this.course, this.date});

  @override
  State<StatefulWidget> createState() {
    return _TeeSheetPage();
  }
}

class _TeeSheetPage extends State<TeeSheetPage> {
  _TeeSheetPage();
  TeeTimeService svc;
  Stream<List<TeeTime>> teeTimeStream;

  @override
  void initState() {
    super.initState();
    svc = Provider.of<TeeTimeService>(context, listen: false);
    teeTimeStream = svc.getTeeTimeStream(widget.course.id, widget.date);
  }

  Widget build(BuildContext context) {
    print("Build TeeSheetPage");

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text(widget.course.name)),
          body: Column(
            children: [
              Expanded(
                  child: StreamBuilder<List<TeeTime>>(
                      stream: teeTimeStream,
                      builder: (context, snapshot) {
                        return _CreateTeeSheet(
                            snap: snapshot, course: widget.course);
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

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TeeTimePage(teeTime: teeTime, course: course)));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.golf_course),
                Text(
                  util.dateToHHMM(teeTime.dateTime),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ..._createPlayerRows(),
          ],
        ),
      ),
    );
  }

  final playerTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  List<Widget> _createPlayerRows() {
    List<Row> rows = [];
    int numPlayers = teeTime.playerDisplayNames.length;
    int total = teeTime.availableSpots + numPlayers;
    int playerIndex = 0;
    var available = Expanded(
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              "Available",
              style: playerTextStyle,
            ),
          ),
          color: Colors.lightGreen),
    );

    int numRows = total ~/ 2;

    for (int i = 0; i < numRows; ++i) {
      List<Widget> _t = [];
      for (int j = 0; j < 2; ++j) {
        if (playerIndex < numPlayers)
          _t.add(Expanded(
              child: Card(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      teeTime.playerDisplayNames[playerIndex++],
                      style: playerTextStyle,
                    ),
                  ))));
        else
          _t.add(available);
      }
      rows.add(Row(
        children: _t,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ));
    }
    return rows;
  }
}

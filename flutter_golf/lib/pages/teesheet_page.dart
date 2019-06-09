import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../svc/teetimes_svc.dart';
import '../util/date_format.dart' as util;
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';
import 'teetime_page.dart';
import 'package:provider/provider.dart';

class TeeSheetPage extends HookWidget {
  final String courseId;
  final DateTime date;

  TeeSheetPage({Key key, this.courseId, this.date}) : super(key: key);

  Widget build(BuildContext context) {
    final svc = Provider.of<TeeTimeService>(context);
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
    return ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, position) {
          return _TeeTimeSlot(teeTime: times[position]);
        });
  }
}

class _CreateTile extends StatelessWidget {
  final String courseId;
  final TeeTime teeTime;

  _CreateTile({Key key, this.courseId, this.teeTime}) : super(key: key);

  Widget build(BuildContext context) {
    var availableSlots = teeTime.availableSpots > 0;
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        leading: Text(util.dateToHHMM(teeTime.dateTime)),
        title: _SlotWidget(teeTime),
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

const max_slots = 4; // todo- get this from the tee sheet

class _SlotWidget extends StatelessWidget {
  final TeeTime _teeTime;

  _SlotWidget(this._teeTime);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _genSLots(),
    );
  }

  List<Widget> _genSLots() {
    List<Widget> l = [];
    for (int i = 0; i < 4; ++i) {
      l.add(Container(
        margin: EdgeInsets.all(1.0),
        color: Colors.green,
        child: Text("Available"),
      ));
    }
    return l;
  }
}

class _TeeTimeSlot extends StatelessWidget {
  final TeeTime teeTime;

  _TeeTimeSlot({this.teeTime});

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
                        builder: (context) => TeeTimePage(teeTime: teeTime)));
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

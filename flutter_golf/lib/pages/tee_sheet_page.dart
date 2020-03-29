import 'package:flutter/material.dart';
import 'package:flutter_golf/mobx/tee_sheet_store.dart';
import 'package:flutter_golf/pages/teetime_page.dart';
import 'package:flutter_golf/svc/services.dart';
import '../util/date_format.dart' as util;
import 'package:provider/provider.dart';
import '../model/model.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

final _textStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

/// A TeeSheet shows a list of Tee times for course on a date

class TeeSheetPage extends StatefulWidget {
  Course course;
  DateTime date;

  TeeSheetPage({this.course, this.date});
  @override
  State<StatefulWidget> createState() {
    return _TeeSheetPageState();
  }
}

class _TeeSheetPageState extends State<TeeSheetPage> {
  TeeSheetStore teeSheetStore;

  @override
  initState() {
    super.initState();
    var svc = Provider.of<FireStore>(context, listen: false);
    teeSheetStore = TeeSheetStore(widget.course, widget.date, svc);
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(widget.course.name)),
            body: Observer(
                builder: (_) => Column(
                      children: <Widget>[
                        _dateTab(),
                        if (teeSheetStore.teeTimeList.isEmpty)
                          Text("Tee Sheet not available for this day!"),
                        Expanded(
                            child: ListView.builder(
                                itemCount: teeSheetStore.teeTimeList.length,
                                itemBuilder: (context, position) =>
                                    _TeeTimeSlot(
                                        teeTime:
                                            teeSheetStore.teeTimeList[position],
                                        course: widget.course)))
                      ],
                    ))));
  }

  // Render the top tab that lets the user navigate the course date
  Widget _dateTab() {
    var d = teeSheetStore.date;
    var s = util.dateToDay(d);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => teeSheetStore.decrementDate()),
        Expanded(
            child: Text(
          "$s",
          textAlign: TextAlign.center,
          style: _textStyle,
        )),
        IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () => teeSheetStore.incrementDate()),
      ],
    );
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
            _createPlayerRows(),
          ],
        ),
      ),
    );
  }

  // available widget - shows time slot is available
  final Widget _available = Card(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          "Available",
          style: _textStyle,
        ),
      ),
      color: Colors.lightGreen);

  // player or guest widget - shows name of player
  Widget _playerText(String name) => Card(
      color: Colors.transparent,
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(name, style: _textStyle)));

  Widget _createPlayerRows() {
    List<Widget> _t = [];
    teeTime.players.forEach((id, user) {
      _t.add(_playerText(user.displayName));
      // todo: add guests of booking...
    });

    // the rest of the spots are available..
    for (int i = 0; i < teeTime.availableSpots; ++i) _t.add(_available);

    return Column(children: _createGrid(_t, 2));
  }

  // break up w into a list of rows - each row with column items
  // Each element needs to be Expanded so it fills the row
  List<Widget> _createGrid(List<Widget> w, int columns) {
    var l = List<Widget>();
    for (int i = 0; i < w.length; i += columns) {
      l.add(Row(
          children: w
              .sublist(i, i + 2 <= w.length ? i + 2 : i + 1)
              .map((w) => Expanded(
                    child: w,
                  ))
              .toList()));
    }
    return l;
  }
}

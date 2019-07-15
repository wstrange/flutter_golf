import 'package:flutter/material.dart';
import 'package:flutter_golf/pages/teetime_page.dart';
import 'package:flutter_golf/svc/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../util/date_format.dart' as util;
import '../model/models.dart';
import 'package:provider/provider.dart';

final _textStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

class TeeSheetPage extends HookWidget {
  final Course course;
  DateTime date;

  TeeSheetPage({this.course, this.date});

  TeeTimeService svc;
  Stream<List<TeeTime>> teeTimeStream;

  Widget build(BuildContext context) {
    var svc = Provider.of<FireStore>(context, listen: false).teeTimeService;
    var selectedDate = useState(this.date);
    print(
        "Build TeeSheetPage for course ${course.id} date ${selectedDate.value}");

    var stream = useMemoized(
        () => svc.getTeeTimeStream(course.id, selectedDate.value),
        [course.id, selectedDate.value]);
    var teeTimeSnap = useStream(stream);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(course.name)),
            body: Column(
              children: <Widget>[
                _dateTab(selectedDate),
                Expanded(
                    child: _CreateTeeSheet(snap: teeTimeSnap, course: course)),
              ],
            )));
  }

  // Render the top tab that lets the user update the course date
  Widget _dateTab(ValueNotifier<DateTime> selectedDate) {
    var s = util.dateToDay(selectedDate.value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => selectedDate.value =
              selectedDate.value.subtract(const Duration(days: 1)),
        ),
        Expanded(
            child: Text(
          "$s",
          textAlign: TextAlign.center,
          style: _textStyle,
        )),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () => selectedDate.value =
              selectedDate.value.add(const Duration(days: 1)),
        ),
      ],
    );
  }
}

// todo: This can prolly be a statelesswidget... or just a method
class _CreateTeeSheet extends HookWidget {
  final AsyncSnapshot<List<TeeTime>> snap;
  final Course course;

  _CreateTeeSheet({Key key, this.snap, this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!snap.hasData || snap.data.length == 0) {
      return Text("Tee Sheet not available for this day!");
    }

    var times = snap.data;
    return ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, position) {
          return _TeeTimeSlot(teeTime: times[position], course: course);
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
            _createPlayerRows(),
          ],
        ),
      ),
    );
  }

  // available widget
  Widget _available = Card(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          "Available",
          style: _textStyle,
        ),
      ),
      color: Colors.lightGreen);

  // player or guest widget
  Widget _playerText(String name) => Card(
      color: Colors.transparent,
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(name, style: _textStyle)));

  Widget _createPlayerRows() {
    int numPlayers = teeTime.playerNames.length;
    int total = teeTime.availableSpots + numPlayers;
    int numRows = total ~/ 2;

    List<Widget> _t = [];
    teeTime.playerNames.forEach((name) {
      _t.add(_playerText(name));
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

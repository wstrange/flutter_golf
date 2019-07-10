import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../model/models.dart';
import '../svc/teetimes_svc.dart';
import '../util/date_format.dart' as util;

// Widget to book a tee time on the course at the given date and time

const TextStyle _style = TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

class TeeTimePage extends HookWidget {
  final TeeTime teeTime;
  final Course course;

  TeeTimePage({Key key, this.teeTime, this.course}) : super(key: key);

  Widget build(BuildContext context) {
    print("Build TeeTimePage");
    var s = util.dateToTeeTime(teeTime.dateTime);
    final teeTimeSvc = Provider.of<TeeTimeService>(context, listen: false);
    final resStream =
        useMemoized(() => teeTimeSvc.getBookingsForTeeTime(teeTime));
    final bookings = useStream(resStream);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("${course.name}")),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$s",
                textAlign: TextAlign.center,
                style: _style,
              ),
              SizedBox(
                height: 50.0,
              ),
              ..._drawSlots(bookings),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                  child: Text("Book Time"),
                  onPressed: () async {
                    await teeTimeSvc.bookTeeTime(course, teeTime);
                    Navigator.pop(context);
                  }),
            ],
          )),
    );
  }

  // Draw the list of players in each slot, or "available" if
  // the slot is open
  List<Widget> _drawSlots(AsyncSnapshot<List<Booking>> bookSnap) {
    List<Widget> _t = [];
    if (bookSnap.hasData) {
      // Draw player slots
      bookSnap.data.forEach((b) {
        // todo: Create a wrapper here for the booking. Each booking is
        // independent.
        var bw = List<Widget>();

        b.players.forEach((playerRef) {
          // todo: Need to lookup playerRef!!
          bw.add(_createCard(playerRef, onTap: () {
            print('Card tapped - player $playerRef}');
          }));
        });

        var c = ListTile(leading: Icon(Icons.delete), title: Row(children: bw));
        // add
        _t.add(c);
      });
    }

    // Add "free Slots"
    for (int i = 0; i < teeTime.availableSpots; ++i) {
      _t.add(_createCard("Available", onTap: () {
        print('Card tapped.');
      }));
    }

    return _t;
  }

  _createCard(String text, {GestureTapCallback onTap}) {
    return Card(
        elevation: 4.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: onTap,
          child: Container(
            width: 300.0,
            height: 50.0,
            alignment: Alignment(0.1, 0.5),
            child: Text(
              text,
              style: _style,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

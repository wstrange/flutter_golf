import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../svc/services.dart';
import '../util/date_format.dart' as util;

// Widget to book a tee time on the course at the given date and time

const TextStyle _style = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

class TeeTimePage extends HookWidget {
  final TeeTime teeTime;
  final Course course;
  FireStore svc;

  TeeTimePage({Key key, this.teeTime, this.course}) : super(key: key);

  Widget build(BuildContext context) {
    print("Build TeeTimePage");
    var dateTimeString = util.dateToTeeTime(teeTime.dateTime);
    svc = Provider.of<FireStore>(context, listen: false);
    final resStream =
        useMemoized(() => svc.teeTimeService.getBookingsForTeeTime(teeTime));
    final bookings = useStream(resStream);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("${course.name}")),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "$dateTimeString",
                  textAlign: TextAlign.center,
                  style: _style,
                ),
              ),
              if (teeTime.availableSpots > 0)
                Text(
                  "Available Spots: ${teeTime.availableSpots}",
                  textAlign: TextAlign.end,
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
                  child: Text("Create New Booking"),
                  onPressed: () async {
                    var user = svc.userService.user;
                    await svc.teeTimeService.bookTeeTime(teeTime, user);
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
      // Iterate over each Booking
      bookSnap.data.forEach((b) {
        //_t.add(BookingWidget(booking: b, teeTime: teeTime));
        _t.add(_bookingWidget(b, teeTime));
      });
    }

    return _t;
  }

  // Create the widget that displays a single booking
  Widget _bookingWidget(Booking booking, TeeTime teeTime) {
    var players = booking.players.keys.map((playerId) {
      var name = booking.players[playerId].displayName;
      return Text("${name}");
    });
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(15.0),
      color: Colors.amberAccent,
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Booked by: ${booking.createdByUser.displayName}",
                  style: _style,
                  textScaleFactor: 0.75,
                ),
              )),
          Text("Players"),
          ...players,
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,

            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text("Add Player"),
                onPressed: () => print("todo - add player"),
              ),
              RaisedButton(
                child: Text("Cancel"),
                onPressed: () {
                  print("cancel booing ${booking.id}");
                  svc.teeTimeService.cancelBooking(teeTime, booking);
                },
              )
            ],
          )
        ],
      ),
    );
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

class BookingWidget extends HookWidget {
  final Booking booking;
  final TeeTime teeTime;
  FireStore svc;

  BookingWidget({this.booking, this.teeTime});

  @override
  Widget build(BuildContext context) {
    svc = Provider.of<FireStore>(context, listen: false);
    // player selection map - set to false to start
    var selectedMap =
        useState(booking.players.map((k, v) => MapEntry(k, false)));
    var selected = useState(false);

    var players = booking.players.keys.map((playerId) {
      var p = booking.players[playerId];
      var t = CheckboxListTile(
        value: selectedMap.value[playerId],
        // toggle whether the player is selected or not
        onChanged: ((b) {
          var m = selectedMap.value;
          // todo: Booking is immutable.
          //m[playerId] = !m[playerId];
          selected.value = m.containsValue(true);
          print("selected = ${selected.value}");
          selectedMap.notifyListeners();
        }),
        title: new Text(
          p.displayName,
          style: _style,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        //subtitle: new Text('Subtitle'),
        //secondary: new Icon(Icons.archive),
        activeColor: Colors.red,
      );

      //return Row(children: [Flexible(child: t)]);
      return t;
    });

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("teeTime Ref ${booking.teeTimeId}"),
          ],
        ),
        ...players,
        Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              child: Text("Add Player"),
              onPressed: () {
                print("Add player");
                //svc.teeTimeService.bookTeeTime(teeTime)
              },
            ),
            RaisedButton(
                child: Text("Cancel Time"),
                onPressed:
                    selected.value ? () => _cancel(teeTime, booking) : null)
          ],
        )
      ],
    );
  }

  _cancel(TeeTime t, Booking b) {
    print("Cancel Booking");
    svc.teeTimeService.cancelBooking(t, b);
  }
}

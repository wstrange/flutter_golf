import 'package:flutter/material.dart';
import 'package:flutter_golf/mobx/mobx.dart';
import 'package:flutter_golf/mobx/user_store.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../svc/services.dart';
import '../util/date_format.dart' as util;
import 'package:flutter_mobx/flutter_mobx.dart';

// Widget to book a tee time on the course at the given date and time

const TextStyle _style = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

class TeeTimePage extends StatelessWidget {
  final TeeTime teeTime;
  final Course course;

  TeeTimePage({Key key, this.teeTime, this.course}) : super(key: key);

  Widget build(BuildContext context) {
    print("Build TeeTimePage");
    var dateTimeString = util.dateToTeeTime(teeTime.dateTime);
    var svc = Provider.of<FireStore>(context, listen: false);
    var userStore = Provider.of<UserStore>(context);
    var teeTimeStore = Provider.of<TeeTimeStore>(context, listen: false);

    // todo: This is async - so view may not be ready.
    teeTimeStore.getTeeTime(teeTime.id);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("${course.name}")),
          body: Observer(
              builder: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "$dateTimeString",
                          textAlign: TextAlign.center,
                          style: _style,
                        ),
                      ),
                      if (teeTimeStore.teeTime.availableSpots > 0)
                        Text(
                          "Available Spots: ${teeTimeStore.teeTime.availableSpots}",
                          textAlign: TextAlign.end,
                          style: _style,
                        ),
                      SizedBox(
                        height: 50.0,
                      ),
                      ..._drawSlots(teeTimeStore.teeTimeBookingsList,
                          teeTimeStore.teeTime),
                      SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                          child: Text("Create New Booking"),
                          onPressed: () async {
                            await teeTimeStore.createBooking(userStore.user);
                            Navigator.pop(context);
                          }),
                    ],
                  ))),
    );
  }

  // Draw the list of players in each slot, or "available" if
  // the slot is open
  List<Widget> _drawSlots(List<Booking> bookings, TeeTime teeTime) {
    return bookings
        .map((b) => _bookingWidget(b, teeTime))
        .toList(growable: false);
  }

  // Create the widget that displays a single booking
  Widget _bookingWidget(Booking booking, TeeTime teeTime) {
    var players = booking.players.keys.map((playerId) {
      var name = booking.players[playerId].displayName;
      return Text("$name");
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
                  // todo: fix passing booking store. Make this stateful???
                  // Provider.of<TeeTimeService>().cancelBooking(teeTime, booking);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

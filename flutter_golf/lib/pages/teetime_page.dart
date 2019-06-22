import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../model/models.dart';
import '../svc/teetimes_svc.dart';

// Widget to book a tee time on the course at the given date and time

class TeeTimePage extends HookWidget {
  final TeeTime teeTime;
  final Course course;

  TeeTimePage({Key key, this.teeTime, this.course}) : super(key: key);

  Widget build(BuildContext context) {
    final teeTimeSvc = Provider.of<TeeTimeService>(context);
    var numberSpots = useState(this.teeTime.availableSpots);
    var requestedSpots = useState(1);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("${course.name}")),
          body: Column(
            children: [
              Text("date ${teeTime.dateTime}"),
              Row(
                children: <Widget>[
                  IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (requestedSpots.value < numberSpots.value)
                          requestedSpots.value = requestedSpots.value + 1;
                      }),
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (requestedSpots.value >= 1)
                          requestedSpots.value = requestedSpots.value - 1;
                      }),
                  Text("Booked ${requestedSpots.value}"),
                ],
              ),
              RaisedButton(
                  child: Text("Book Time"),
                  onPressed: () async {
                    await teeTimeSvc.bookTeeTime(
                        course, teeTime, requestedSpots.value);
                    Navigator.pop(context);
                  }),
            ],
          )),
    );
  }
}

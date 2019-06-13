import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../model/models.dart';
import '../svc/teetimes_svc.dart';

// Widget to book a tee time on the course at the given date and time

class TeeTimePage extends HookWidget {
  TeeTime teeTime;

  TeeTimePage({Key key, this.teeTime}) : super(key: key);

  Widget build(BuildContext context) {
    //final teeTimeSvc = useMemoized(() => TeeTimeService());
    final teeTimeSvc = Provider.of<TeeTimeService>(context);
    var numberSpots = useState(this.teeTime.availableSpots);
    var requestedSpots = useState(0);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Course ${teeTime.courseID}")),
          body: Column(
            children: [
              Text("date ${teeTime.dateTime}"),
              Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.add),
                    onPressed: () => numberSpots.value--,
                  ),
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => numberSpots.value++),
                  Text("${numberSpots.value}"),
                ],
              ),
              RaisedButton(
                  child: Text("Book Time"),
                  onPressed: () {
                    teeTimeSvc.bookTeeTime(teeTime, 1);
                  }),
            ],
          )),
    );
  }
}

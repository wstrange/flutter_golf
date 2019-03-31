import 'package:flutter/material.dart';

class TeeTimeForm extends StatefulWidget {
  @override
  TeeTimeFormState createState() => TeeTimeFormState();
}

// Define a corresponding State class. This class will hold the data related to
// the form.
class TeeTimeFormState extends State<TeeTimeForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Scaffold(
      appBar: AppBar(title: Text("TeeTime")),
      body: _teeTimeDateSelector(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
              print("Add time");
            }),
        tooltip: 'Add TeeTime',
        child: Icon(Icons.add),
      ),
    );
  }

  static const ONE_DAY = Duration(days: 1);
  static const SEVEN_DAYS =  Duration(days: 7);

  Widget _teeTimeDateSelector() {
    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.date_range),
            tooltip: 'Select date',
            onPressed: () async {
              var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(ONE_DAY),
                  lastDate: DateTime.now().add(SEVEN_DAYS),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.dark(),
                      child: child,
                    );
                  });
              print("New date $date");

              setState( () {
                print("set date $date");
                selectedDate = date;
              });
            }),
        Text("${selectedDate}"),
      ],
    );
  }
}

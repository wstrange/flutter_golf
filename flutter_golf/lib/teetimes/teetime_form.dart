import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../svc/teetimes_svc.dart';
import 'bloc.dart';

class CreateTeetimeForm extends StatefulWidget {
  @override
  CreateTeetimeFormState createState() => CreateTeetimeFormState();
}

// Define a corresponding State class. This class will hold the data related to
// the form.
class CreateTeetimeFormState extends State<CreateTeetimeForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  CreateTeetimeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<CreateTeetimeBloc>(context);
  }

  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    return BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, CreateTeetimeState state) {
          if (state is InitialCreateTeetimeState) {
          }
          if( state is Creating ) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Booking tee time...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
          if (state is Success ) {
            Navigator.of(context).pop();
          }
          if (state is Error) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tee time booking Failure'),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }

        },
        child: BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, CreateTeetimeState state) {

              var enableButton = state is ReadyToBookState ? true: false;

              return Column(children: <Widget>[
                _teeTimeDateSelector(),
                FloatingActionButton(
                    onPressed: (enableButton ? _bookTeeTime : null),
                    tooltip: 'Add TeeTime',
                    child: Icon(Icons.add))
              ]);
            }));
  }

  _bookTeeTime() {
    print("Book tee time time");
    _bloc.dispatch(BookTeetimeEvent());
  }

  static const ONE_DAY = Duration(days: 1);
  static const SEVEN_DAYS = Duration(days: 7);



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
              print("set date $date");
              selectedDate = date;
              _bloc.dispatch(SelectTimeEvent(date));
            }),
        if (selectedDate != null )
          Text("${selectedDate.day}-${selectedDate.month}-${selectedDate.year}")
        else
          Text("Select a Time")
      ],
    );
  }

  @override
  void dispose() {
//    _emailController.dispose();
//    _passwordController.dispose();
    super.dispose();
  }
}

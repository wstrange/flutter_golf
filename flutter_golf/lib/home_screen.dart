import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golf/svc/teetimes_svc.dart';
import 'package:provider/provider.dart';
import 'authentication_bloc/bloc.dart';
import 'teetimes/teetime_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/teesheet_page.dart';
//import 'pages/course_selector.dart';
import 'widgets/course_selector.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).dispatch(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(child: Text('Welcome $name!')),
          MaterialButton(
            child: Text("Generate Data"),
            onPressed: () async {
              await TeeTimeService().generateSampleData();
            },
          ),
          MaterialButton(
            child: Text("Tee Sheet"),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                          builder: (context) => TeeTimeService(),
                          child: TeeSheetPage(
                              "ECS1WnnFLNrn2wPe8WUc", DateTime.now()))));
            },
          ),
          Expanded(
            child: CourseSelector(),
          ),
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                var user = await FirebaseAuth.instance.currentUser();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateTeetimeScreen(user: user)));
              })
        ],
      ),
    );
  }
}

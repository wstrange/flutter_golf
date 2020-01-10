import 'package:flutter/material.dart';
import 'package:flutter_golf/svc/services.dart';
import 'package:provider/provider.dart';
import 'mobx/user_store.dart';
import 'widgets/course_selector.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserStore>(context);
    var svc = Provider.of<FireStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  userRepo.signOut();
                })
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(child: Text('Welcome $name!')),
              MaterialButton(
                child: Text("Generate Sample Data"),
                onPressed: () async {
                  await svc.createSampleData();
                },
              ),
              Expanded(child: CourseSelector()),
            ]));
  }
}

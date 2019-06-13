import 'package:flutter/material.dart';
import 'package:flutter_golf/pages/teesheet_page.dart';
import 'package:flutter_golf/svc/teetimes_svc.dart';
import 'package:flutter_golf/svc/user_repository.dart';
import 'package:provider/provider.dart';
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
                  var userRepo = Provider.of<UserRepository>(context);
                  userRepo.signOut();
                })
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(child: Text('Welcome $name!')),
              MaterialButton(
                child: Text("Generate Data"),
                onPressed: () async {
                  var t = DateTime.now();
                  var start = DateTime(t.year, t.month, t.day, 7);
                  await TeeTimeService().generateTeeTimes(
                      "ECS1WnnFLNrn2wPe8WUc",
                      start,
                      start.add(Duration(hours: 10)));
                },
              ),
              MaterialButton(
                child: Text("Tee Sheet"),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeeSheetPage(
                              courseId: "ECS1WnnFLNrn2wPe8WUc",
                              date: DateTime.now())));
                },
              ),
              Expanded(child: CourseSelector()),
            ]));
  }
}

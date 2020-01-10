import 'package:flutter/material.dart';
import '../model/model.dart';
import 'package:flutter_golf/pages/tee_sheet_page.dart';
import 'package:flutter_golf/svc/firestore_svc.dart';
import 'package:provider/provider.dart';

// https://stackoverflow.com/questions/55013944/cloud-firestore-keeps-re-downloading-documents-flutter

class CourseSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var svc = Provider.of<FireStore>(context);

    return FutureBuilder<List<Course>>(
        future: svc.courseService.getCoursesList(),
        builder: (context, AsyncSnapshot<List<Course>> snapshot) {
          if (!snapshot.hasData) return Text("No courses!");

          return ListView(children: _build(context, snapshot.data));
        });
  }

  List<Widget> _build(BuildContext context, List<Course> courses) {
    //print("Building course widget = $courses");
    return courses
        .map((course) => Card(
            child: ListTile(
                title: Text(course.name),
                trailing: Icon(Icons.navigate_next),
                onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TeeSheetPage(course: course, date: DateTime.now());
                    })))))
        .toList();
  }
}

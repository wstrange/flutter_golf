import 'package:flutter/material.dart';
import 'package:flutter_golf/model/models.dart';
import 'package:flutter_golf/pages/teesheet_page.dart';
import 'package:flutter_golf/svc/course_svc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

// https://stackoverflow.com/questions/55013944/cloud-firestore-keeps-re-downloading-documents-flutter

class CourseSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CourseSelecState();
}

class _CourseSelecState extends State<CourseSelector> {
  List<Course> courses = [];

  @override
  void initState() {
    // why doesnt this work???
//    var svc = Provider.of<CourseService>(context);
////    svc.getCoursesList().then((c) => setState(() => courses = c));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var svc = Provider.of<CourseService>(context);
    svc.getCoursesList().then((c) => setState(() => courses = c));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Building course");
    var l = courses
        .map((course) => Card(
            child: ListTile(
                title: Text(course.name),
                trailing: Icon(Icons.navigate_next),
                onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TeeSheetPage(course: course, date: DateTime.now());
                    })))))
        .toList();

    return ListView(children: l);
  }
}
//
//
//class CourseSelector extends HookWidget {
//  Widget build(BuildContext context) {
//    final courseService =
//        useMemoized(() => Provider.of<CourseService>(context));
//    //final courseService = Provider.of<CourseService>(context);
//    final courses = useFuture(courseService.getCoursesList());
//
//    print("build CourseSelector called");
//    if (!courses.hasData) return Text("No Courses!");
//
//    var l = courses.data
//        .map((course) => Card(
//            child: ListTile(
//                title: Text(course.name),
//                trailing: Icon(Icons.navigate_next),
//                onTap: () => Navigator.push(context,
//                        MaterialPageRoute(builder: (context) {
//                      return TeeSheetPage(course: course, date: DateTime.now());
//                    })))))
//        .toList();
//
//    return ListView(children: l);
//  }
//}

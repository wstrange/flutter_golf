import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import '../svc/course_svc.dart';
import '../model/models.dart';

part 'course_selector.g.dart';

@widget
Widget courseSelector(BuildContext context) {
  final courseSvc = useMemoized(() => CourseService());
  final courseSnapshot = useStream(courseSvc.getCoursesStream());
  final courseQuery = useFuture(courseSvc.getCoursesList());

  return Scaffold(
      appBar: AppBar(title: Text("Courses")),
      body: Column(
        children: <Widget>[
          Text("Courses"),
//          Expanded(
//            child: ListView(
//              padding: const EdgeInsets.all(8.0),
//              children: _courseList(courseSnapshot.data ?? []),
//            ),
//          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: _courseList(courseQuery.data ?? []),
            ),
          ),
        ],
      ));
}

List<Widget> _courseList(List<Course> courses) => courses
    .map((course) => Card(child: Text("Course ${course.name}")))
    .toList();

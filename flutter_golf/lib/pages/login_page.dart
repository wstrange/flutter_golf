import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_golf/svc/user_repository.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/models.dart';

part 'login_page.g.dart';

@widget
Widget loginPage() {
  final userRepo = useListenable(UserRepository());
}

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './teetimes/teetime_form.dart';
import './register_page.dart';
import './signin_page.dart';
import './home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: SignInPage(),
      routes: <String, WidgetBuilder>{
        '/landingpage': (BuildContext context) => MyApp(),
        //'/signup': (BuildContext context) => new SignupPage(),
        '/homepage': (BuildContext context) => HomePage(),
        '/teetime_form' : (BuildContext context) => TeeTimeForm(),

      },
    );
  }
}

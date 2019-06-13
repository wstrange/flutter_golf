import 'package:flutter/material.dart';
import 'package:flutter_golf/svc/services.dart';
import 'util/simple_bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<CourseService>.value(value: CourseService()),
          ChangeNotifierProvider<TeeTimeService>.value(value: TeeTimeService()),
          ChangeNotifierProvider<UserRepository>.value(value: UserRepository())
        ],
        child: MaterialApp(
            home: Consumer<UserRepository>(builder: (context, userRepo, child) {
          switch (userRepo.status) {
            case Status.Uninitialized:
              return SplashScreen();
            case Status.Unauthenticated:
            case Status.Authenticating:
            case Status.Error:
              return LoginPage();
            case Status.Authenticated:
              return HomeScreen(name: userRepo.user.email);
          }
        })));
  }
}

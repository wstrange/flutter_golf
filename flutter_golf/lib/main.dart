import 'package:flutter/material.dart';
import 'package:flutter_golf/splash_screen.dart';
import 'package:flutter_golf/svc/services.dart';
import 'home_screen.dart';
import 'pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_golf/svc/firestore_svc.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<FireStore>.value(value: FireStore()),
          ChangeNotifierProvider<UserRepository>.value(value: UserRepository())
        ],
        child: MaterialApp(
            home: Consumer<UserRepository>(builder: (context, userRepo, child) {
          switch (userRepo.status) {
            case Status.Uninitialized:
              return SplashScreen();
            case Status.Authenticated:
              return HomeScreen(name: userRepo.firebaseUser.email);
            case Status.Unauthenticated:
            case Status.Authenticating:
            case Status.Error:
            default:
              return LoginPage();
          }
        })));
  }
}

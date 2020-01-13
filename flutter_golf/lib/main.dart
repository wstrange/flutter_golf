import 'package:flutter/material.dart';
import 'package:flutter_golf/splash_screen.dart';
import 'package:flutter_golf/svc/services.dart';
import 'package:logging/logging.dart';
import 'home_screen.dart';
import 'mobx/mobx.dart';
import 'pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_golf/svc/firestore_svc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.message}');
  });

  runApp(App());
}

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    var _userStore = UserStore();

    return MultiProvider(
        providers: [
          Provider<FireStore>.value(value: FireStore()),
          Provider<UserStore>.value(value: _userStore),
          ProxyProvider<FireStore, TeeTimeStore>(
              update: (_, dbService, __) =>
                  TeeTimeStore(dbService.teeTimeService)),
        ],
        child: MaterialApp(home: Observer(builder: (_) {
          switch (_userStore.status) {
            case Status.Uninitialized:
              // todo: this does not work because we need to observe the change
              // Do we really need a splash screen?
              _userStore.status = Status.Unauthenticated;
              return SplashScreen();
            case Status.Authenticated:
              return HomeScreen(name: _userStore.user.email);
            case Status.Unauthenticated:
            case Status.Authenticating:
            case Status.Error:
            default:
              return LoginPage();
          }
        })));
  }
}

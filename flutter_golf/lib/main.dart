
import 'package:flutter/material.dart';
import 'util/simple_bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'svc/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_bloc/bloc.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'login/login.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}



class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is InitialAuthenticationState) {
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is Authenticated) {
              return HomeScreen(name: state.displayName);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}



//
//class MyApp extends StatelessWidget {
//
//
////  @override
////  Widget build(BuildContext context) {
////    return new MaterialApp(
////      home: SignInPage(),
////      routes: <String, WidgetBuilder>{
////        '/landingpage': (BuildContext context) => MyApp(),
////        //'/signup': (BuildContext context) => new SignupPage(),
////        '/homepage': (BuildContext context) => HomePage(),
////        '/teetime_form' : (BuildContext context) => TeeTimeForm(),
////
////      },
////    );
////  }
//}

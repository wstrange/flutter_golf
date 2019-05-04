import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_bloc/bloc.dart';
import 'teetimes/teetime_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              BlocProvider.of<AuthenticationBloc>(context).dispatch(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(child: Text('Welcome $name!')),
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                var user = await FirebaseAuth.instance.currentUser();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateTeetimeScreen(user: user)));
              })
        ],
      ),
    );
  }
}

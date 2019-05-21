import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../svc/teetimes_svc.dart';
import 'bloc.dart';
import 'teetime_form.dart';

class CreateTeetimeScreen extends StatefulWidget {
  final TeeTimeService teetimeService;
  final FirebaseUser user;

  CreateTeetimeScreen({Key key, this.teetimeService, @required this.user})
      : super(key: key);

  State<CreateTeetimeScreen> createState() => _CreateTeetimeScreenState();
}

class _CreateTeetimeScreenState extends State<CreateTeetimeScreen> {
  CreateTeetimeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CreateTeetimeBloc(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CreateTeetime')),
      body: Center(
        child: BlocProvider<CreateTeetimeBloc>(
          bloc: _bloc,
          child: CreateTeetimeForm(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

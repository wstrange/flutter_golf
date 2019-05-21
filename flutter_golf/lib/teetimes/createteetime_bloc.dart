import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_golf/model/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './bloc.dart';
import '../svc/teetimes_svc.dart';

class CreateTeetimeBloc extends Bloc<CreateTeetimeEvent, CreateTeetimeState> {
  final FirebaseUser _user;
  final TeeTimeService _svc;
  final FSTeetime _teetime;

  @override
  CreateTeetimeState get initialState => InitialCreateTeetimeState();

  CreateTeetimeBloc(this._user)
      //: _svc = TeetimeService(_user),
      : _svc = TeeTimeService(),
        _teetime = FSTeetime(_user) {}

  @override
  Stream<CreateTeetimeState> mapEventToState(
    CreateTeetimeEvent event,
  ) async* {
    print("Event is $event");
    if (event is AddPlayerEvent) {
      _teetime.players.add(event.player);
      yield BuildingState();
    } else if (event is BookTeetimeEvent) {
      yield* _mapFormSubmittedToState();
    } else if (event is SelectTimeEvent) {
      _teetime.time = Timestamp.fromDate(event.time);
      yield readyToBook();
    } else if (event is SelectCourseEvent) {
      // Todo:
      //_teetime.course =event.course;
      _teetime.setCourse("AIJwXrIv0Q1lgefcSxbo");
      yield readyToBook();
    }
  }

  Stream<CreateTeetimeState> _mapFormSubmittedToState() async* {
    yield Creating();
    try {
      await _svc.createTeetime(_teetime);
      yield Success();
    } catch (error) {
      yield Error(error.toString());
    }
  }

  // Check if the tee time is in a valid state
  // return the next state
  CreateTeetimeState readyToBook() {
    if (_teetime.course != null && _teetime.time != null)
      return ReadyToBookState();
    return BuildingState();
  }
}

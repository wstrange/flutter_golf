import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_golf/model/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './bloc.dart';
import '../svc/teetimes_svc.dart';

class CreateTeetimeBloc extends Bloc<CreateTeetimeEvent, CreateTeetimeState> {
  final FirebaseUser _user;
  final TeetimeService _svc;
  final Teetime _teetime;

  @override
  CreateTeetimeState get initialState => InitialCreateTeetimeState();

  CreateTeetimeBloc(this._user)
      : _svc = TeetimeService(_user),
        _teetime = Teetime(_user) {}

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
    }
    else if( event is SelectTimeEvent) {
      _teetime.time = Timestamp.fromDate(event.time);
      yield BuildingState();
      yield ReadyToBookState();
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

}

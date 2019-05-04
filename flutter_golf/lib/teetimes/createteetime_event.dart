import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../model/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
abstract class CreateTeetimeEvent extends Equatable {
  CreateTeetimeEvent([List props = const []]) : super(props);
}

class SetUserEvent extends CreateTeetimeEvent {
  final DocumentReference user;
  SetUserEvent(this.user) : super([user]);

  @override
  String toString() => "SetUser event $user";

}

class AddPlayerEvent extends CreateTeetimeEvent {
  final DocumentReference player;

  AddPlayerEvent({@required this.player}): super ([player]);

  @override
  String toString() => "Add Player Event $player";
}

class SelectTimeEvent extends CreateTeetimeEvent {
  final DateTime time;
  SelectTimeEvent(this.time);

  String toString() => "Select Time Event t=$time";
}

class SelectCourse extends CreateTeetimeEvent {

}


class BookTeetimeEvent extends CreateTeetimeEvent {

  @override
  String toString() => "Book Teetime Event";

}


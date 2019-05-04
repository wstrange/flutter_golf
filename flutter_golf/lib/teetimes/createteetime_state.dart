import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
abstract class CreateTeetimeState extends Equatable {

  CreateTeetimeState([List props = const[]]): super(props);
}

class InitialCreateTeetimeState extends CreateTeetimeState {

  String toString() => " InitialCreateTeetimeState";

}

// request is in the process of being created
class Creating extends CreateTeetimeState {
  String toString() => " Creating Tee Time";
}


class Success extends CreateTeetimeState {
  String toString() => " Success Creating Tee Time";
}


class Error extends CreateTeetimeState {
  final String errorMessage;

  Error(this.errorMessage ): super([errorMessage]);
  String toString() => " Error Creating tee time $errorMessage";
}

// Tee time is valid and ready to be created
class ReadyToBookState extends CreateTeetimeState {

  @override
  String toString() => "Ready to Book Tee Time State";

}

// Tee time is being built.
class BuildingState extends CreateTeetimeState {
  @override
  String toString() => "Building Tee Time State";
}




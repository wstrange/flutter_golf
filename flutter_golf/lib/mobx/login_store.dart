import 'package:flutter_golf/util/validators.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  String email = "";

  @observable
  String password = "";

  LoginErrors errors = LoginErrors();

  List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword)
    ];
  }

  void dispose() {
    for (var d in _disposers) {
      d();
    }
  }

  @action
  void validateEmail(String value) {
    errors.email = Validators.isValidEmail(value) ? null : 'Not a valid email';
  }

  @action
  void validatePassword(String value) {
    errors.password =
        Validators.isValidPassword(password) ? null : 'Enter password';
  }

  void validateAll() {
    validatePassword(password);
    validateEmail(email);
  }

  String toString() => "LoginStore $email,$password";
}

class LoginErrors = _LoginErrors with _$LoginErrors;

abstract class _LoginErrors with Store {
  @observable
  String email;

  @observable
  String password;

  @computed
  bool get hasErrors => email != null || password != null;
}

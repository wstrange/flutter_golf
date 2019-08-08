import 'package:flutter/material.dart';
import 'package:flutter_golf/svc/user_svc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../util/validators.dart';

const style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

class LoginPage extends HookWidget {
  Widget build(BuildContext context) {
    final repo = Provider.of<UserService>(context);
    final userRepo = useListenable(repo);

    final _email = useMemoized(() => TextEditingController(text: ""));
    final _password = useMemoized(() => TextEditingController(text: ""));
    final _formKey = useMemoized(() => GlobalKey<FormState>());
    final _key = useMemoized(() => GlobalKey<ScaffoldState>());

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _email,
                  autovalidate: true,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => !Validators.isValidEmail(value)
                      ? "Please Enter valid Email"
                      : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (value) => !Validators.isValidPassword(value)
                      ? "Please Enter a valid Password"
                      : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                      border: OutlineInputBorder()),
                ),
              ),
              if (userRepo.status != Status.Authenticating)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.blueAccent,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (!await userRepo.signInWithCredentials(
                              _email.text, _password.text)) {
                            _key.currentState.showSnackBar(SnackBar(
                              content: Text("Login Failed"),
                            ));
                          }
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              userRepo.status == Status.Authenticating
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SignInButton(Buttons.Google, onPressed: () async {
                        await Provider.of<UserService>(context)
                            .signInWithGoogle();
                      }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

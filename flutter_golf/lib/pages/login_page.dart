import 'package:flutter/material.dart';
import 'package:flutter_golf/mobx/mobx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../util/validators.dart';

const style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

final log = Logger("LoginPage");

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginStore loginStore = LoginStore();

  initState() {
    super.initState();
    loginStore.setupValidations();
  }

  dispose() {
    loginStore.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final userStore = Provider.of<UserStore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        child: Center(
          child: Observer(
            builder: (_) => ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) => loginStore.email = value,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: style,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        errorText: loginStore.errors.email),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) => loginStore.password = value,
                    obscureText: true,
                    autocorrect: false,
                    style: style,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        errorText: loginStore.errors.password),
                  ),
                ),
                if (userStore.status != Status.Authenticating)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MaterialButton(
                      color: Colors.blueAccent,
                      disabledColor: Colors.grey,
                      // todo: set this to null
                      onPressed: loginStore.errors.hasErrors
                          ? null
                          : () {
                              loginStore.validateAll();
                              if (!loginStore.errors.hasErrors) {
                                log.fine("Log on with ${loginStore}");
                                userStore.signInWithCredentials(
                                    loginStore.email, loginStore.password);
                              }
                            },
                      child: Text(
                        "Sign In",
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                userStore.status == Status.Authenticating
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child:
                            SignInButton(Buttons.Google, onPressed: () async {
                          await userStore.signInWithGoogle();
                        }),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

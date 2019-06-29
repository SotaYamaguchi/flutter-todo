import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> _signIn(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (user.uid.length > 0 && user.uid != null) {
      Navigator.pushNamed(context, '/home');
    }
    return user;
  }

  Widget _showBody() {
    return Center(
      child: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal:
                  16.0), // horizontal : left = horizontal, right = horizontal
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _showIcon(),
              const SizedBox(height: 250.0),
              _showEmailForm(),
              const SizedBox(height: 24.0),
              _showPasswordForm(),
              const SizedBox(height: 24.0),
              _showLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showIcon() {
    return Center(
      child: Image.asset(
        'assets/flutter.png',
        width: 100.0,
      ),
    );
  }

  Widget _showEmailForm() {
    return TextFormField(
      controller: emailInputController,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: 'Email',
      ),
    );
  }

  Widget _showPasswordForm() {
    return TextFormField(
      controller: passwordInputController,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: 'Password',
      ),
    );
  }

  Widget _showLoginButton() {
    return Center(
      child: RaisedButton(
        child: const Text('Login'),
        onPressed: () {
          var email = emailInputController.text;
          var password = passwordInputController.text;
          return _signIn(email, password)
              .then((FirebaseUser user) => print(user))
              .catchError((e) => print(e));
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showBody(),
    );
  }
}

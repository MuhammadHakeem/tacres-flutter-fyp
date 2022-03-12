import 'package:flutter/material.dart';
import 'package:tacres_draft/authenticate/register.dart';
import 'package:tacres_draft/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleViewAuth() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleViewAuth);
    } else {
      return Register(toggleView: toggleViewAuth);
    }
  }
}

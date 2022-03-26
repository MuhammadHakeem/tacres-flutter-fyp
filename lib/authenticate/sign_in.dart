import 'package:flutter/material.dart';
import 'package:tacres_draft/services/auth.dart';
import 'package:tacres_draft/shared/constant.dart';
import 'package:tacres_draft/shared/loading.dart';
import 'package:tacres_draft/authenticate/register.dart';

class SignIn extends StatefulWidget {
  // final Function toggleView;
  // SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/icon-tacres.png"),
                              fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Treat Asthma Climate Region Experience System",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0)),
                        child: Text(
                          "Log In",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error =
                                    'Could Not Sign In With Those Credential';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't Have An Account?"),
                          SizedBox(width: 10),
                          GestureDetector(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                    // ignore: prefer_const_constructors
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              }),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                )));
  }
}

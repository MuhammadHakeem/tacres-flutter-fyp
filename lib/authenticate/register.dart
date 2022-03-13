// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tacres_draft/services/auth.dart';
import 'package:tacres_draft/shared/constant.dart';
import 'package:tacres_draft/shared/loading.dart';

var valRulesReg;

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  // ignore: prefer_final_fields
  var _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = "";
  String password = "";
  String error = "";
  String radioBoxError = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text("Sign Up in to TACRES"),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 80),
                      Text("Register Your Account",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      SizedBox(height: 40),
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
                      SizedBox(height: 10),
                      //here the code for rules and regulation

                      ListTile(
                        title: GestureDetector(
                          child: Text(
                            "Agree to the Terms and Conditions",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                SingleChildScrollView(
                              child: AlertDialog(
                                title: Text(
                                  'Privacy Policy: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                    'This policy sets out the basis on which any personal data we collect from you, or you provide us will be processed by us. Before we process any of your data, we will need your explicit consent. \n 1. Information we collect from you \n 2. Information you gave us. \n 3. Information we collect from you. \n 4. Anonymised data. \nConsents: \n1. I confirm that I have read and understood how and why my data will be collected. \n2. I confirm that I have read and understood the contents of this Privacy Policy. \n3. I acknowledge my right to withdraw consent to the processing of sensitive personal data. \nHere are the main things to know: \n 1. We are a responsible software company. We respect your privacy and we have taken steps to protect data. \n 2. We may vary our terms from time to time. But you will be notified. \n \n TACRES is an application that inform chances of asthma exacerbation based on ACT score and giving health recommendation that based on current weather. \n For any enquiry, contact us through: 1191301566@student.mmu.edu.my'),
                                actions: <Widget>[
                                  TextButton(
                                    // onPressed: () => Navigator.pop(context, 'OK'),
                                    onPressed: () {
                                      Navigator.pop(context, 'Ok');
                                    },

                                    child: const Text('Ok'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        leading: Radio(
                          value: 1,
                          groupValue: valRulesReg,
                          onChanged: (value) {
                            setState(() {
                              valRulesReg = value;
                            });
                          },
                          toggleable: true,
                        ),
                      ),
                      Text(
                        radioBoxError,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0)),
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (valRulesReg == null) {
                            setState(() {
                              radioBoxError =
                                  'Please agree to the terms and conditions';
                            });
                          } else {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Email has been registered or incorrect email format';
                                  loading = false;
                                });
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already Have An Account?"),
                          SizedBox(width: 10),
                          GestureDetector(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async => await widget.toggleView()),
                        ],
                      ),
                      // Text(valRulesReg.toString())
                    ],
                  ),
                )));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tacres_draft/homePage.dart';
import 'package:tacres_draft/resultACT.dart';
import 'package:dart_date/dart_date.dart'; //to get formatted date
import 'package:tacres_draft/services/auth.dart';

class asthContTest extends StatelessWidget {
  String currentWeather;

  asthContTest({required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffBFC0C2),
      appBar: AppBar(
        title:
            const Text('Asthma Control Test', style: TextStyle(fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: Theme.of(context).textTheme.headline6,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }),
                );
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              question1(),
              question2(),
              question3(),
              question4(),
              question5(),
              submitButton(
                currentWeather2: currentWeather,
              ),
              // debug()
            ],
          ),
        ),
      ),
    );
  }
}

enum answer1 {
  choice1,
  choice2,
  choice3,
  choice4,
  choice5
} //code from internet, no need to update

enum answer2 {
  choice1,
  choice2,
  choice3,
  choice4,
  choice5
} // by default, will choose first choice

enum answer3 { choice1, choice2, choice3, choice4, choice5 }

enum answer4 { choice1, choice2, choice3, choice4, choice5 }

enum answer5 { choice1, choice2, choice3, choice4, choice5 }

// ignore: camel_case_types

int q1 = 1;
int q2 = 1;
int q3 = 1;
int q4 = 1;
int q5 = 1;

void setAlltoDefault() {
  q1 = 1;
  q2 = 1;
  q3 = 1;
  q4 = 1;
  q5 = 1;
}

int cumACTscore = 0;
String ACTdesc = '';

void changeQ1(value) {
  q1 = value;
}

void changeQ2(value) {
  q2 = value;
}

void changeQ3(value) {
  q3 = value;
}

void changeQ4(value) {
  q4 = value;
}

void changeQ5(value) {
  q5 = value;
}

int updateCumACTscore(int val1, int val2, int val3, int val4, int val5) {
  cumACTscore = 0;
  cumACTscore = val1 + val2 + val3 + val4 + val5;

  if (cumACTscore >= 0 && cumACTscore <= 15) {
    ACTdesc = "Very Poorly Controlled Asthma";
  } else if (cumACTscore >= 16 && cumACTscore <= 20) {
    ACTdesc = "Poorly Controlled Asthma";
  } else {
    ACTdesc = "Well-Controlled Asthma";
  }

  return val1 + val2 + val3 + val4 + val5;
}

// var q1 = 1, q2 = 1, q3 = 1, q4 = 1, q5 = 1;

class question1 extends StatefulWidget {
  const question1({Key? key}) : super(key: key);

  @override
  State<question1> createState() => _question1State();
}

class _question1State extends State<question1> {
  answer1? _answer1 = answer1.choice1;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.red,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Question 1",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.green,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "In the past 4 weeks, how much of the time did your asthma keep you from getting as much done at work, school or at home?",
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        children: <Widget>[
                          RadioListTile<answer1>(
                            title: Text('All of the time',
                                style: TextStyle(fontSize: 14)),
                            value: answer1.choice1,
                            groupValue: _answer1,
                            onChanged: (answer1? value) {
                              setState(() {
                                _answer1 = value;
                                changeQ1(1);
                                // print(objAnsSubm.q1);
                                // ans = 1;
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer1>(
                            title: const Text(
                              'Most of the time',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: answer1.choice2,
                            groupValue: _answer1,
                            onChanged: (answer1? value) {
                              setState(() {
                                _answer1 = value;
                                changeQ1(2);
                                // print(objAnsSubm.q1);
                                // q1 = 2;
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer1>(
                            title: const Text('Some of the time',
                                style: TextStyle(fontSize: 14)),
                            value: answer1.choice3,
                            groupValue: _answer1,
                            onChanged: (answer1? value) {
                              setState(() {
                                _answer1 = value;
                                changeQ1(3);
                                // print(objAnsSubm.q1);
                                // q1 = 3;
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer1>(
                            title: const Text('A little of the time',
                                style: TextStyle(fontSize: 14)),
                            value: answer1.choice4,
                            groupValue: _answer1,
                            onChanged: (answer1? value) {
                              setState(() {
                                _answer1 = value;
                                changeQ1(4);
                                // q1 = 4;
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer1>(
                            title: const Text('None of the time',
                                style: TextStyle(fontSize: 14)),
                            value: answer1.choice5,
                            groupValue: _answer1,
                            onChanged: (answer1? value) {
                              setState(() {
                                _answer1 = value;
                                changeQ1(5);
                                // q1 = 5;
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}

class question2 extends StatefulWidget {
  const question2({Key? key}) : super(key: key);

  @override
  _question2State createState() => _question2State();
}

class _question2State extends State<question2> {
  answer2? _answer2 = answer2.choice1;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 290,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.red,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Question 2",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.green,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "During the past 4 weeks, how often have you had shortness of breath?",
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        children: <Widget>[
                          RadioListTile<answer2>(
                            title: const Text('More than once a day',
                                style: TextStyle(fontSize: 14)),
                            value: answer2.choice1,
                            groupValue: _answer2,
                            onChanged: (answer2? value) {
                              setState(() {
                                _answer2 = value;
                                changeQ2(1);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer2>(
                            title: const Text(
                              'Once a day',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: answer2.choice2,
                            groupValue: _answer2,
                            onChanged: (answer2? value) {
                              setState(() {
                                _answer2 = value;
                                changeQ2(2);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer2>(
                            title: const Text('3 to 6 times a week',
                                style: TextStyle(fontSize: 14)),
                            value: answer2.choice3,
                            groupValue: _answer2,
                            onChanged: (answer2? value) {
                              setState(() {
                                _answer2 = value;
                                changeQ2(3);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer2>(
                            title: const Text('Once or twice a week',
                                style: TextStyle(fontSize: 14)),
                            value: answer2.choice4,
                            groupValue: _answer2,
                            onChanged: (answer2? value) {
                              setState(() {
                                _answer2 = value;
                                changeQ2(4);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer2>(
                            title: const Text('Not at all',
                                style: TextStyle(fontSize: 14)),
                            value: answer2.choice5,
                            groupValue: _answer2,
                            onChanged: (answer2? value) {
                              setState(() {
                                _answer2 = value;
                                changeQ2(5);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}

class question3 extends StatefulWidget {
  const question3({Key? key}) : super(key: key);

  @override
  _question3State createState() => _question3State();
}

class _question3State extends State<question3> {
  answer3? _answer3 = answer3.choice1;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 320,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.red,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Question 3",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.green,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "During the past 4 weeks, how often did your asthma symptoms(wheezing, coughing, shortness of breath, chest tightness or pain) wake you up at night or earlier than usual in the morning?",
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        children: <Widget>[
                          RadioListTile<answer3>(
                            title: const Text('4 or more nights a week',
                                style: TextStyle(fontSize: 14)),
                            value: answer3.choice1,
                            groupValue: _answer3,
                            onChanged: (answer3? value) {
                              setState(() {
                                _answer3 = value;
                                changeQ3(1);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer3>(
                            title: const Text(
                              '2 or 3 nights a week',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: answer3.choice2,
                            groupValue: _answer3,
                            onChanged: (answer3? value) {
                              setState(() {
                                _answer3 = value;
                                changeQ3(2);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer3>(
                            title: const Text('Once a week',
                                style: TextStyle(fontSize: 14)),
                            value: answer3.choice3,
                            groupValue: _answer3,
                            onChanged: (answer3? value) {
                              setState(() {
                                _answer3 = value;
                                changeQ3(3);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer3>(
                            title: const Text('Once or twice',
                                style: TextStyle(fontSize: 14)),
                            value: answer3.choice4,
                            groupValue: _answer3,
                            onChanged: (answer3? value) {
                              setState(() {
                                _answer3 = value;
                                changeQ3(4);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer3>(
                            title: const Text('Not at all',
                                style: TextStyle(fontSize: 14)),
                            value: answer3.choice5,
                            groupValue: _answer3,
                            onChanged: (answer3? value) {
                              setState(() {
                                _answer3 = value;
                                changeQ3(5);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}

class question4 extends StatefulWidget {
  const question4({Key? key}) : super(key: key);

  @override
  _question4State createState() => _question4State();
}

class _question4State extends State<question4> {
  answer4? _answer4 = answer4.choice1;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 320,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.red,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Question 4",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.green,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "During the past 4 weeks, how often have you used your blue puffer or reliever medication(such as Ventolin, Asmol, Airomir, Apo-Salbutamol or Bricanyl)?",
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        children: <Widget>[
                          RadioListTile<answer4>(
                            title: const Text('3 or more times per day',
                                style: TextStyle(fontSize: 14)),
                            value: answer4.choice1,
                            groupValue: _answer4,
                            onChanged: (answer4? value) {
                              setState(() {
                                _answer4 = value;
                                changeQ4(1);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer4>(
                            title: const Text(
                              '1 or 2 times per day',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: answer4.choice2,
                            groupValue: _answer4,
                            onChanged: (answer4? value) {
                              setState(() {
                                _answer4 = value;
                                changeQ4(2);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer4>(
                            title: const Text('2 or 3 times per week',
                                style: TextStyle(fontSize: 14)),
                            value: answer4.choice3,
                            groupValue: _answer4,
                            onChanged: (answer4? value) {
                              setState(() {
                                _answer4 = value;
                                changeQ4(3);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer4>(
                            title: const Text('Once a week or less',
                                style: TextStyle(fontSize: 14)),
                            value: answer4.choice4,
                            groupValue: _answer4,
                            onChanged: (answer4? value) {
                              setState(() {
                                _answer4 = value;
                                changeQ4(4);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer4>(
                            title: const Text('Not at all',
                                style: TextStyle(fontSize: 14)),
                            value: answer4.choice5,
                            groupValue: _answer4,
                            onChanged: (answer4? value) {
                              setState(() {
                                _answer4 = value;
                                changeQ4(5);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}

class question5 extends StatefulWidget {
  const question5({Key? key}) : super(key: key);

  @override
  _question5State createState() => _question5State();
}

class _question5State extends State<question5> {
  answer5? _answer5 = answer5.choice1;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 280,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.red,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Question 5",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.green,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "How would you rate your asthma control during the past 4 weeks?",
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        children: <Widget>[
                          RadioListTile<answer5>(
                            title: const Text('Not controlled at all',
                                style: TextStyle(fontSize: 14)),
                            value: answer5.choice1,
                            groupValue: _answer5,
                            onChanged: (answer5? value) {
                              setState(() {
                                _answer5 = value;
                                changeQ5(1);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer5>(
                            title: const Text(
                              'Poorly controlled',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: answer5.choice2,
                            groupValue: _answer5,
                            onChanged: (answer5? value) {
                              setState(() {
                                _answer5 = value;
                                changeQ5(2);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer5>(
                            title: const Text('Somewhat controlled',
                                style: TextStyle(fontSize: 14)),
                            value: answer5.choice3,
                            groupValue: _answer5,
                            onChanged: (answer5? value) {
                              setState(() {
                                _answer5 = value;
                                changeQ5(3);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer5>(
                            title: const Text('Well controlled',
                                style: TextStyle(fontSize: 14)),
                            value: answer5.choice4,
                            groupValue: _answer5,
                            onChanged: (answer5? value) {
                              setState(() {
                                _answer5 = value;
                                changeQ5(4);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          RadioListTile<answer5>(
                            title: const Text('Completely controlled',
                                style: TextStyle(fontSize: 14)),
                            value: answer5.choice5,
                            groupValue: _answer5,
                            onChanged: (answer5? value) {
                              setState(() {
                                _answer5 = value;
                                changeQ5(5);
                              });
                            },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}

class submitButton extends StatelessWidget {
  String currentWeather2;
  submitButton({required this.currentWeather2});

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: 100,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          children: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                  onPressed: () {
                    updateCumACTscore(q1, q2, q3, q4, q5);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => resultACT(
                              localACTscore1: cumACTscore,
                            )));
                    FirebaseFirestore.instance
                        .collection('draft-act-record')
                        .add({
                      'ACT_Score': cumACTscore,
                      'ACT_Desc': ACTdesc,
                      'ACT_Weather': currentWeather2,
                      'ACT_Date': DateTime.now().format('y-MM-dd H:m'),
                      'Uid': AuthService().giveMyUid(),
                    });
                    setAlltoDefault();
                  },
                  child: const Text('Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white))),
            )
          ],
        ));
  }
}

class debug extends StatefulWidget {
  const debug({Key? key}) : super(key: key);

  @override
  _debugState createState() => _debugState();
}

class _debugState extends State<debug> {
  // ansSubmission objAnsSubm = ansSubmission();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("q1 value:" + q1.toString()),
          Text("q2 value:" + q2.toString()),
          Text("q3 value:" + q3.toString()),
          Text("q4 value:" + q4.toString()),
          Text("q5 value:" + q5.toString()),
          Text("cumACTscore value:" +
              updateCumACTscore(q1, q2, q3, q4, q5).toString()),
        ],
      ),
    );
  }
}

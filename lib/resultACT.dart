import 'package:flutter/material.dart';
import 'package:tacres_draft/homePage.dart';

class resultACT extends StatelessWidget {
  int localACTscore1;

  resultACT({required this.localACTscore1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffBFC0C2),
      appBar: AppBar(
        title: Text('Asthma Control Test', style: TextStyle(fontSize: 17.0)),
        backgroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ACTscore(
                localACTscore2: localACTscore1,
              ),
              scoreDescription(
                localACTscore3: localACTscore1,
              ),
              backHomeButton()
            ],
          ),
        ),
      ),
    );
  }
}

class ACTscore extends StatelessWidget {
  int localACTscore2;
  ACTscore({required this.localACTscore2});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            localACTscore2.toString(),
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
          ),
          Text(
            "Here's your ACT score",
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}

class scoreDescription extends StatelessWidget {
  int localACTscore3;
  scoreDescription({required this.localACTscore3});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 200,
      child: Column(
        children: <Widget>[
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: localACTscore3 <= 15 ? Colors.blue[300] : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("0-15       Very Poorly Controlled Asthma",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: localACTscore3 <= 20 && localACTscore3 >= 16
                      ? Colors.blue[300]
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("16-20            Poorly Controlled Asthma",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: localACTscore3 <= 25 && localACTscore3 >= 21
                      ? Colors.blue[300]
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("21-25       Well-Controlled Asthma",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class backHomeButton extends StatelessWidget {
  const backHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        SizedBox(
          width: 150,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }),
                );
              },
              child: Text('Back to HomePage',
                  style: TextStyle(color: Colors.black, fontSize: 12))),
        )
      ],
    ));
  }
}

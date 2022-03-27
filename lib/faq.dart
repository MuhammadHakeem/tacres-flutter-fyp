import 'package:flutter/material.dart';
import 'package:tacres_draft/homePage.dart';
import 'package:expandable/expandable.dart';
import 'dart:math' as math;

class faq extends StatelessWidget {
  // const recordACT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ', style: TextStyle(fontSize: 17.0)),
        backgroundColor: Colors.white,
        centerTitle: true,
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
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            cardFaq(
              cardTitle: whatIsTacres,
              cardSubs: whatIsTacresDesc,
              cardNo: 2,
            ),
            cardFaq(
              cardTitle: whatIsAct,
              cardSubs: whatIsActDesc,
              cardNo: 3,
            ),
            cardFaq(
              cardTitle: whatIsAqi,
              cardSubs: whatIsAqiDesc,
              cardNo: 4,
            ),
            cardFaq(
              cardTitle: howManyAct,
              cardSubs: howManyActDesc,
              cardNo: 5,
            ),
          ],
        ),
      ),
    );
  }
}

const whatIsTacres = "What is TACRES?";
const whatIsAct = "What is Asthma Control Test?";
const whatIsAqi = "What is AQI?";
const howManyAct = "How many times should I take the Asthma Control Test?";

const whatIsTacresDesc =
    "Treat Asthma Climate Region Experience System (TACRES) is a mobile applications that can helps asthmatic patient on monitoring their asthma exacerbations and also gives health recommendation based on current weather.";
const whatIsActDesc =
    "Asthma Control Test (ACT) is a tool that can help a user and the doctor figure out if the asthma symptoms are under control. \nThere are five questions provided for the user to answer. \nThe score is divided to three parts, very poorly controlled asthma, poorly controlled asthma and well-controlled asthma.";
const whatIsAqiDesc =
    "Air Quality Index (AQI) is the measure of how polluted or clean the air is. \nThe greater the increase in the AQI number, the greater the risk to human health.";
const howManyActDesc =
    "It is recommended to take the test monthly. That way, it can help to understand how the asthma is changing over time.";
const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class cardFaq extends StatelessWidget {
  String cardTitle;
  String cardSubs;
  int cardNo = 1;
  cardFaq(
      {required this.cardTitle, required this.cardSubs, required this.cardNo});

  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(label),
      );
    }

    buildList() {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        // margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: <Widget>[
            Text(cardSubs, textAlign: TextAlign.justify),
            SizedBox(
              height: 10,
            ),
            returnAqiImage(cardNo)
          ],
        ),
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            this.cardTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: Container(),
                expanded: buildList(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

returnAqiImage(int value) {
  switch (value) {
    case 2:
      return const Image(
        image: AssetImage("assets/icon-tacres-circle.png"),
        height: 100,
      );
    case 3:
      return const Image(
        image: AssetImage("assets/actScoreRange.JPG"),
        height: 120,
      );
    case 4:
      return const Image(
        image: AssetImage("assets/aqiDesc.JPG"),
        height: 180,
      );
    case 5:
      return const Image(
        image: AssetImage("assets/calendar.png"),
        height: 50,
      );
    default:
      return Text("");
  }
}

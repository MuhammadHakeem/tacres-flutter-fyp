import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tacres_draft/homePage.dart';
import 'package:tacres_draft/services/auth.dart';

class recordACT extends StatelessWidget {
  // const recordACT({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> act_record = FirebaseFirestore.instance
      .collection('act-record')
      .where('Uid', isEqualTo: AuthService().giveMyUid())
      .orderBy('ACT_Date', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ACT Record', style: TextStyle(fontSize: 17.0)),
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
      body: Container(
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: StreamBuilder<QuerySnapshot>(
              stream: act_record,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong.');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }
                if (snapshot.data?.size == 0) {
                  // got data from snapshot but it is empty
                  return Padding(
                      padding:
                          EdgeInsets.all(20), //apply padding to all four sides
                      child: Text(
                          "Please complete the Asthma Control Test(ACT) to display the records here."));
                }
                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Container(
                        height: 60,
                        color: Colors.white,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.docs[index]['ACT_Date'],
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.grey,
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                decoration: BoxDecoration(
                                  color: changeBackColorBasedACTScore(
                                      data.docs[index]['ACT_Score']),
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(25))
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        data.docs[index]['ACT_Score']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            // const VerticalDivider(
                            //   color: Colors.grey,
                            // ),
                            // Flexible(
                            //   flex: 1,
                            //   fit: FlexFit.tight,
                            //   child: Column(
                            //     children: [
                            //       returIcon(data.docs[index]['ACT_Score'])
                            //     ],
                            //   ),
                            // ),
                            const VerticalDivider(
                              color: Colors.grey,
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(data.docs[index]['ACT_Desc'].toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0)),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.grey,
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      data.docs[index]['ACT_Weather']
                                          .toString(),
                                      style: TextStyle(fontSize: 12.0))
                                ],
                              ),
                            ),
                          ],
                        )));
                  },
                );
              })),
    );
  }
}

returIcon(int value) {
  // ignore: unnecessary_null_comparison
  if (value > 0 && value <= 15) {
    return const Icon(
      Icons.circle,
      color: Colors.redAccent,
    );
  } else if (value >= 16 && value <= 20) {
    return const Icon(
      Icons.circle,
      color: Colors.orangeAccent,
    );
  } else if (value >= 21 && value <= 25) {
    return const Icon(
      Icons.circle,
      color: Colors.greenAccent,
    );
  } else {
    return const Icon(
      Icons.circle,
      color: Colors.white,
    );
  }
}

changeBackColorBasedACTScore(int value) {
  // ignore: unnecessary_null_comparison
  if (value > 0 && value <= 15) {
    return Colors.redAccent;
  } else if (value >= 16 && value <= 20) {
    return Colors.orangeAccent;
  } else if (value >= 21 && value <= 25) {
    return Colors.greenAccent;
  } else {
    return Colors.white;
  }
}

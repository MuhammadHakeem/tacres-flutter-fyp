import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tacres_draft/homePage.dart';

class recordACT extends StatelessWidget {
  // const recordACT({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> act_record =
      FirebaseFirestore.instance.collection('act-record').snapshots();

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

                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    // return Text(data.docs[index]['ACT_Weather'] +
                    //     "  " +
                    //     data.docs[index]['ACT_Score'].toString() +
                    //     "  " +
                    //     data.docs[index]['ACT_Date'].toString() +
                    //     "  " +
                    //     data.docs[index]['Acc_ID'].toString());
                    return Container(
                        height: 50,
                        color: Colors.white,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [Text(data.docs[index]['ACT_Date'])],
                            ),
                            Column(
                              children: [
                                Text(data.docs[index]['ACT_Score'].toString())
                              ],
                            ),
                            Column(
                              children: [
                                Text(data.docs[index]['ACT_Desc'].toString())
                              ],
                            ),
                            Column(
                              children: [
                                Text(data.docs[index]['ACT_Weather'].toString())
                              ],
                            ),
                          ],
                        )));
                  },
                );
              })),
    );
  }
}

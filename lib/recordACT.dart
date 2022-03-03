import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class recordACT extends StatelessWidget {
  const recordACT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ACT Record', style: TextStyle(fontSize: 17.0)),
        backgroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

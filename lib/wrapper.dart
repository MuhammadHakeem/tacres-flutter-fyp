import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacres_draft/authenticate/authenticate.dart';
import 'package:tacres_draft/homePage.dart';
import 'package:tacres_draft/model/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wrapperUser = Provider.of<myUser?>(context);
    // print(wrapperUser);

    //return either homePage or Authenticate widget
    if (wrapperUser == null) {
      return const Authenticate();
    } else {
      return HomePage();
    }
  }
}

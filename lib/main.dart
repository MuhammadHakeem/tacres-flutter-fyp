import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacres_draft/homePage.dart';
import 'package:tacres_draft/model/user.dart';
import 'package:tacres_draft/services/auth.dart';
import 'package:tacres_draft/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<myUser?>.value(
      catchError: (_, __) {},
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'TACRES Mobile Apps',
        home: Wrapper(),
        //homePage()
      ),
    );
  }
}

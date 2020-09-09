import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'widget/screen/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Firebase Login',
        theme: new ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: new SplashScreen()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/viewModel/HomeScreenViewModel.dart';
import 'package:provider/provider.dart';

import 'SplashScreen.dart';


// ignore: must_be_immutable
class HomeScreen extends StatefulWidget with RouteAware {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final HomeScreenViewModel viewModel = HomeScreenViewModel();

  @override
  Widget build(BuildContext context) {

    // 認証確認
    viewModel.readAuthStatus();

    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: HomeScreenPage(),
    );
  }

}

class HomeScreenPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: Text(
          context.select((HomeScreenViewModel viewModel) => viewModel.displayText()),
        ),
      ),
      drawer: drawerMenu(context),
    );
  }

  Widget drawerMenu(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("メニュー"),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.png'),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ),
          ListTile(
            title: Text("サインアウト"),
            onTap: () {
              context.read<HomeScreenViewModel>().signOut(context);
            },
          )
        ],
      ),
    );
  }
}

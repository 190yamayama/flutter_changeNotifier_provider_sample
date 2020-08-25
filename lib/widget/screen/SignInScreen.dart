import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/viewModel/SignInScreenViewModel.dart';
import 'package:flutter_firebase_app/widget/component/PrimaryButton.dart';
import 'package:provider/provider.dart';


class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  static final formKey = new GlobalKey<FormState>();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInScreenViewModel(),
      child: SignInScreenPage(),
    );
  }

}

class SignInScreenPage extends StatelessWidget {

  bool validateAndSave() {
    final form = SignInScreen.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: new Center(
        child: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget> [
              logoImage(),
              hintText(context),
              const SizedBox(height: 10.0),
              new Center(
                  child: new Form(
                      key: SignInScreen.formKey,
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            emailText(context),
                            passwordText(context),
                            signInButton(context),
                            signUpButton(context),
                          ]
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget logoImage() {
    return const SizedBox(
      height: 200.0,
      width: 200.0,
      child: Image(
        image: AssetImage('assets/splash.png'),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget emailText(BuildContext context) {
    return padded(child: new TextFormField(
      key: new Key("email"),
      decoration: new InputDecoration(labelText: "Email"),
      autocorrect: false,
      validator: (val) => val.isEmpty ? "emailを入力してください" : null,
      onSaved: (val) => {
        context.read<SignInScreenViewModel>().setEmail(val)
      },
    ));
  }

  Widget passwordText(BuildContext context) {
    return padded(child: new TextFormField(
      key: new Key("password"),
      decoration: new InputDecoration(labelText: "Password"),
      obscureText: true,
      autocorrect: false,
      validator: (val) => val.isEmpty ? "パスワードを入力してください" : null,
      onSaved: (val) => {
        context.read<SignInScreenViewModel>().setPassword(val)
      },
    ));
  }

  Widget signInButton(BuildContext context) {
    return new PrimaryButton(
        key: new Key("signIn"),
        text: "サインイン",
        height: 44.0,
        onPressed: () {
          if (!validateAndSave() || context.read<SignInScreenViewModel>().isEmpty()) {
            return;
          }
          context.read<SignInScreenViewModel>().signIn(context);
        }
    );
  }

  Widget signUpButton(BuildContext context) {
    return new FlatButton(
      key: new Key("need-account"),
      textColor: Colors.green,
      child: new Text(
          "初めて利用する方\n（サインアップ）",
          textAlign: TextAlign.center
      ),
      onPressed: () => context.read<SignInScreenViewModel>().moveSignUpScreen(context),
    );
  }

  Widget hintText(BuildContext context) {
    return new Container(
      //height: 80.0,
      padding: const EdgeInsets.all(32.0),
      child: new Text(
          context.select((SignInScreenViewModel viewModel) => viewModel.authentication?.errorMessage ?? ""),
          key: new Key("hint"),
          style: new TextStyle(fontSize: 18.0, color: Colors.grey),
          textAlign: TextAlign.center
      ),
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
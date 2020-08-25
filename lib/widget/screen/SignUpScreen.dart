import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/viewModel/SignUpScreenViewModel.dart';
import 'package:flutter_firebase_app/widget/component/PrimaryButton.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  static final formKey = new GlobalKey<FormState>();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpScreenViewModel(),
      child: SignUpScreenPage(),
    );
  }

}

class SignUpScreenPage extends StatelessWidget {

  bool validateAndSave() {
    final form = SignUpScreen.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sign Up Screen"),
        ),
        backgroundColor: Colors.grey[300],
        body: new SingleChildScrollView(child: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
                children: [
                  hintText(context),
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Container(
                                padding: const EdgeInsets.all(16.0),
                                child: new Form(
                                    key: SignUpScreen.formKey,
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        displayNameText(context),
                                        emailText(context),
                                        passwordText(context),
                                        singUpButton(context),
                                        signInButton(context),
                                      ],
                                    )
                                )
                            ),
                          ])
                  ),
                ]
            )
        ))
    );
  }


  Widget displayNameText(BuildContext context) {
    return padded(child: new TextFormField(
      key: new Key('displayName'),
      decoration: new InputDecoration(labelText: 'DisplayName'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? '表示名称を入力してください' : null,
      onSaved: (val) => context.read<SignUpScreenViewModel>().setDisplayName(val),
    ));
  }

  Widget emailText(BuildContext context) {
    return padded(child: new TextFormField(
      key: new Key("email"),
      decoration: new InputDecoration(labelText: "Email"),
      autocorrect: false,
      validator: (val) => val.isEmpty ? "emailを入力してください" : null,
      onSaved: (val) => context.read<SignUpScreenViewModel>().setEmail(val),
    ));
  }

  Widget passwordText(BuildContext context) {
    return padded(child: new TextFormField(
      key: new Key("password"),
      decoration: new InputDecoration(labelText: "Password"),
      obscureText: true,
      autocorrect: false,
      validator: (val) => val.isEmpty ? "パスワードを入力してください" : null,
      onSaved: (val) => context.read<SignUpScreenViewModel>().setPassword(val),
    ));
  }

  Widget singUpButton(BuildContext context) {
    return new PrimaryButton(
        key: new Key("singUp"),
        text: "サインアップ",
        height: 44.0,
        onPressed: () {
          if (!validateAndSave() || context.read<SignUpScreenViewModel>().isEmpty()) {
            return;
          }
          context.read<SignUpScreenViewModel>().signIn(context);
        }
    );
  }

  Widget signInButton(BuildContext context) {
    return new FlatButton(
      key: new Key("signIn"),
      textColor: Colors.green,
      child: new Text(
          "既にアカウントをお持ちの方\n（サインイン）",
          textAlign: TextAlign.center
      ),
      onPressed: () => context.read<SignUpScreenViewModel>().moveSignInScreen(context),
    );
  }

  Widget hintText(BuildContext context) {
    return new Container(
      //height: 80.0,
      padding: const EdgeInsets.all(32.0),
      child: new Text(
          context.select((SignUpScreenViewModel viewModel) => viewModel.authentication?.errorMessage ?? ""),
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

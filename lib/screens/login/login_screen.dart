import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/screens/login/login_view_model.dart';
import 'package:donationsystem/screens/signup/sign-up-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final Future<String> Function(String, String) signIn;
  final Future<String> Function() signInWithGoogle;

  LoginScreen(this.signIn, this.signInWithGoogle);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel viewModel;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = new LoginViewModel();
    emailController
        .addListener(() => viewModel.emailSink.add(emailController.text));
    passwordController
        .addListener(() => viewModel.passwordSink.add(passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 50, right: 50, top: 200),
      decoration: BoxDecoration(color: Colors.black87),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Sign",
                        style: TextStyle(
                            fontSize: 34,
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3.0,
                                color: Colors.black,
                              ),
                            ])),
                    Text("In",
                        style: TextStyle(
                            fontSize: 38,
                            fontFamily: "Roboto",
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w400,
                            shadows: [])),
                  ],
                )),
            Container(
                margin: new EdgeInsets.only(bottom: 10),
                height: 50,
                child: TextFormField(
                  controller: emailController,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      //border: Border.all(color: Colors.white, width: 1),
                      prefixIcon: Icon(Icons.account_box, color: Colors.white)),
                )),
            Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: passwordController,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      )),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                    buttonColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    minWidth: 200.0,
                    height: 40,
                    hoverColor: Colors.transparent,
                    child: RaisedButton(
                        color: Colors.white,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4),
                            side: BorderSide(color: Colors.black)),
                        onPressed: () async {
                          await widget
                              .signIn(
                                  emailController.text, passwordController.text)
                              .whenComplete(() => setState(() {
                                    isLogin = false;
                                  }));
                        },
                        child: Text('Login',
                            style: TextStyle(color: Colors.black))))
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Or",
                style: TextStyle(
                    fontFamily: "roboto", color: Colors.white, fontSize: 16),
              ),
            ),
            FlatButton(
                onPressed: () => {widget.signInWithGoogle()},
                child: Container(
                    width: 200,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: Image.asset("assets/images/google.jpg",
                              fit: BoxFit.cover),
                        ),
                        Container(child: Text("Sign In With Google")),
                      ],
                    ))),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Don't have an account ?",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    )
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.blue),
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}

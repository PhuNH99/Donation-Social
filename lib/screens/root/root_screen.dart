import 'package:donationsystem/repository/user_repository.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'dart:convert';
import 'package:donationsystem/screens//main/main_screen.dart';
import 'package:donationsystem/screens/login/login_screen.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:donationsystem/services/Auth.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State {
  final Auth auth = new Auth();
  UserRepository userRepository = new UserRepository();
  User currentUser;
  bool onMessage = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    _firebaseMessaging.autoInitEnabled().then((bool enabled) => print(enabled));
    _firebaseMessaging.setAutoInitEnabled(true).then((_) => _firebaseMessaging
        .autoInitEnabled()
        .then((bool enabled) => print(enabled)));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.onTokenRefresh.listen((data) {
      print('Refresh Token: $data');
    }, onDone: () => print('Refresh Token Done'));
  }

  setMessage() {
    this.setState(() {
      onMessage = false;
    });
  }

  @override
  Future<String> _updateToken(String id, String token) async {
    String url =
        'https://swdapi.azurewebsites.net/api/Campaign/tokenOfUser/$id/$token';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await put(url, headers: headers, body: token);
    int statusCode = response.statusCode;
    String body = response.body;
    return "OK";
  }

  @override
  Future<User> fetchUserByEmail(String email) async {
    User user;
    final response = await http
        .get('https://swdapi.azurewebsites.net/api/user/CurrentUser/$email');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      user = User.fromJson(data[0]);
    }
    return user;
  }

  @override
  Future<String> signIn(String email, String password) async {
    try {
      auth.signIn(email, password);
      userRepository
          .fetchUserByEmail(email.toString().trim())
          .then((value) => currentUser = value);
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String> signInGoogle() async {
    try {
      await auth.signInWithGoogle();
      await auth.getCurrentUser().then((value) async {
        var result = await userRepository
            .fetchUserByEmail(value.email.toString().trim());
      });
    } catch (e) {
      await auth.getCurrentUser().then((value) async {
        User user = new User(
            id: 0,
            count: 0,
            email: value.email.trim(),
            firstName:
                value.displayName.substring(0, value.displayName.indexOf(" ")),
            balance: 10,
            lastName: value.displayName.substring(
                value.displayName.indexOf(" ") + 1, value.displayName.length),
            image: value.photoUrl,
            roleId: 1);
        UserRepository repo = new UserRepository();
        await repo.insertUser(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<String>(
            stream: auth.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  String email;
                  Auth auth = new Auth();
                  auth.getCurrentUser().then((value1) =>
                      fetchUserByEmail(value1.email).then((value2) =>
                          _firebaseMessaging.getToken().then((value3) =>
                              _updateToken(value2.id.toString(), value3))));
                  return MainScreen(auth.signOut);
                } else {
                  return LoginScreen(signIn, signInGoogle);
                }
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: LoadingCircle(50, Colors.black),
              );
            }));
  }
}

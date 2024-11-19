import 'dart:async';

import 'package:donationsystem/services/Auth.dart';
import 'package:donationsystem/services/Validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class LoginViewModel extends ChangeNotifier {
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _btnLoginSubject = BehaviorSubject<bool>();

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    sink.add(Validation.validateEmail(email));
  });
  var passwordValidation = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    sink.add(Validation.validatePassword(password));
  });

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passwordStream =>
      _passwordSubject.stream.transform(passwordValidation);
  Sink<String> get passwordSink => _passwordSubject.sink;

  Stream<bool> get btnLoginStream => _btnLoginSubject.stream;
  Sink<bool> get btnLoginSink => _btnLoginSubject.sink;

  LoginViewModel() {
    Observable.combineLatest2(_emailSubject, _passwordSubject,
        (email, password) {
      return Validation.validateEmail(email) == null &&
          Validation.validatePassword(password) == null;
    }).listen((result) {
      btnLoginSink.add(result);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailSubject.close();
    _btnLoginSubject.close();
    _passwordSubject.close();
  }
}

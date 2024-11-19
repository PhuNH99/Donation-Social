import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class PushNotification {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();


  Future<String> getToken(String userId) async {
    print(userId + " co user");
    var empData = await http.get("https://swdapi.azurewebsites.net/api/user/GetToken/$userId");
    var token = json.decode(empData.body);
    return token["deviceToken"];
  }

final String serverToken = "AAAAySqQXNM:APA91bFlj_fsnmeZrS6sYEKXtrzo4hMjLM_NR31VuA4BuvxjVY106G73x94tL90TU_BQDcWgGpksSK7E4VJKzTRWqQSXdAue1xqLSTEFRuTj5b0mgZhI0YzWSOSxDUr76uuwG5HazNOa";
Future<Map<String, dynamic>> sendMessage(String userId, String body, String title) async {
  print(" co chay dc ne nha");
  String token = await getToken(userId);
  print(token + " token   ");
  print(userId);
  print(body);
  await http.post(
    'https://fcm.googleapis.com/fcm/send',
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'key=$serverToken',
     },
     body: jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': '$body',
         'title': '$title'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': '$token',
     },
    ),
  ).then((value) => print(value.body));

  final Completer<Map<String, dynamic>> completer =
     Completer<Map<String, dynamic>>();
    firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    },
  );

  return completer.future;
}

}

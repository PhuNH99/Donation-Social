
import 'package:donationsystem/screens/root/root_screen.dart';
import 'package:donationsystem/style.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootScreen(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(headline6: AppBarTextStyle)
          ),
          textTheme: TextTheme(
              headline6: TitleTextStyle,
              bodyText2: BodyTextStyle,
              headline5: CardTitle
          )
      ),
    );
  }

}

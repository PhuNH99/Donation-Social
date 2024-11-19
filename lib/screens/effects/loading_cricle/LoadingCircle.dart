import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {

  final double size;
  final Color color;

  LoadingCircle(this.size, this.color);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 3,
        ),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
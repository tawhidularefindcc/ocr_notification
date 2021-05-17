import 'package:flutter/material.dart';

class Chips extends StatelessWidget {

  final String name;
  final int index;

  const Chips({this.name, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(name, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
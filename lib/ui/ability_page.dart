import 'package:flutter/material.dart';

class AbilityPage extends StatelessWidget {
  final String name;
  final String ability;

  AbilityPage({this.name, this.ability});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('Hello'),
        ),
      ),
    );
  }
}

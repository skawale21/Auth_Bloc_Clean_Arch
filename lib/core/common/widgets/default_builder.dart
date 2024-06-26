import 'package:flutter/material.dart';

class DefaultStateBuilder extends StatelessWidget {
  const DefaultStateBuilder({super.key, required this.blocName});
  final String blocName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Default build State from $blocName'),
    );
  }
}

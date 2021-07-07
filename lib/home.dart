import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 300,
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).highlightColor),
          ),
        ),
      ),
      Container(
        width: 300,
        child: Center(
          child: Text(context.watch<User?>()!.email!),
        ),
      ),
    ]);
  }
}

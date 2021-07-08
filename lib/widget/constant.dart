import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({this.color, Key? key}) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Theme.of(context).primaryColor,
      size: 25.0,
    );
  }
}

class LoadingFullScreen extends StatelessWidget {
  const LoadingFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          color: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}

class ErrorFullScreen extends StatelessWidget {
  const ErrorFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Une erreur est survenue',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.red),
        ),
      ),
    );
  }
}

class LoadingConversation extends StatelessWidget {
  const LoadingConversation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      trailing: Container(
        child: CircleAvatar(
          radius: 9,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
      ),
      title: Container(
        height: 17,
        width: 170,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      subtitle: Container(
        height: 13,
        width: 170,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}

//
class IntroChatting extends StatelessWidget {
  const IntroChatting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bienvenue sur LYLA',
          style: Get.isDarkMode
              ? ThemeData.dark().textTheme.headline4
              : ThemeData.light().textTheme.headline4,
        ),
      ),
    );
  }
}

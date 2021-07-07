import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({this.color, Key? key}) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: color ?? Theme.of(context).primaryColor,
        size: 30.0,
      ),
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

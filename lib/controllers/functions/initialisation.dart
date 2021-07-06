import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

initHive() async {
  if (Hive.box('Settings').get('theme') == null)
    Hive.box('Settings')
        .put('theme', {'isDarkMode': false, 'colortheme': 'blue'});
}

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(SettingsState(setDarkMode: true, colorTheme: 'red'));
  changeDarkMode(dark) {
    return emit(state.copyWith(setDarkMode: dark));
  }

  changecoloTheme(color) {
    return emit(state.copyWith(colorTheme: color));
  }

  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState(
        setDarkMode: json['isDarkMode'], colorTheme: json['colorTheme']);
  }

  @override
  Map<String, dynamic> toJson(SettingsState state) {
    return {'isDarkMode': state.setDarkMode, 'colorTheme': state.colorTheme};
  }
}

part of 'settings_cubit.dart';

class SettingsState {
  bool? setDarkMode;
  String? colorTheme;
  SettingsState({
    this.setDarkMode,
    this.colorTheme,
  });

  SettingsState copyWith({
    bool? setDarkMode,
    String? colorTheme,
  }) {
    return SettingsState(
      setDarkMode: setDarkMode ?? this.setDarkMode,
      colorTheme: colorTheme ?? this.colorTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'setDarkMode': setDarkMode,
      'colorTheme': colorTheme,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      setDarkMode: map['setDarkMode'],
      colorTheme: map['colorTheme'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsState.fromJson(String source) =>
      SettingsState.fromMap(json.decode(source));

  @override
  String toString() =>
      'SettingsState(setDarkMode: $setDarkMode, colorTheme: $colorTheme)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsState &&
        other.setDarkMode == setDarkMode &&
        other.colorTheme == colorTheme;
  }

  @override
  int get hashCode => setDarkMode.hashCode ^ colorTheme.hashCode;
  //? Methode

  getColor() {
    switch (colorTheme) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'grey':
        return Colors.grey;
      case 'amber':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  getThemeMode() {
    if (setDarkMode!)
      return ThemeMode.dark;
    else
      return ThemeMode.light;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked_themes/src/locator_setup.dart';
import 'package:stacked_themes/src/services/shared_preferences_service.dart';

/// Provides functionality to manage the current theme for the application
class ThemeManager {
  final _sharedPreferences = locator<SharedPreferencesService>();

  /// A list of themes that the application can swap to
  final List<ThemeData> themes;

  /// The theme to be used when not using the darkTheme
  final ThemeData lightTheme;

  /// The theme to be used when not using the lightTheme
  final ThemeData darkTheme;

  /// Indicates if you want the system setting for light or dark to take effect
  /// default value is true. Set this to false if you want the app to determine your theme
  final bool useSystemTheme;

  /// A builder function that provides you with the new selected theme that expects you to
  /// return a color for the status bar.
  final Color Function(ThemeData) statusBarColorBuilder;

  /// Indicates if you want the darkmode supplied to be the first theme supplied to the application
  final bool startInDarkMode;

  BehaviorSubject<ThemeData> _themesController;

  Stream<ThemeData> get themesStream => _themesController.stream;

  ThemeManager({
    this.themes,
    this.useSystemTheme,
    this.statusBarColorBuilder,
    this.startInDarkMode,
    this.darkTheme,
    this.lightTheme,
  }) {
    var hasMultipleThemes = themes != null && themes.length > 1;
    var hasLightAndDarkThemes = darkTheme != null && lightTheme != null;
    assert(hasMultipleThemes || hasLightAndDarkThemes,
        '''You have to supply themes if you want to use themes. You have supplied no themes. Don\'t do that. Supply themes.
You can supply either a list of ThemeData objects to the themes property or a lightTheme and a darkTheme to be swapped between.
        ''');

    var storedThemeIndex = _sharedPreferences.themeIndex;

    _themesController = BehaviorSubject<ThemeData>.seeded(themes.first);
  }

  /// Broadcasts the theme at the index over the [themesStream]
  void selectThemeAtIndex(int themeIndex) {
    _themesController.add(themes[themeIndex]);
    _sharedPreferences.themeIndex = themeIndex;
  }
}

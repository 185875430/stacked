import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_themes/src/theme_manager.dart';

import 'test_setup.dart';

void main() {
  group('ThemeManagerTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('Construction -', () {
      test(
          'When constructed and last theme index is 1, should broadcast theme at 1 as selected theme',
          () async {
        getAndRegisterSharedPreferencesServiceMock(themeIndex: 1);

        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];

        var themeManager = ThemeManager(themes: themes);
        themeManager.themesStream.listen(expectAsync1((theme) {
          expect(theme[SelectedTheme], themes[1]);
        }));
      });

      test(
          'When constructed and last theme index is 2, if the new theme manager has less themes, broadcast first',
          () async {
        getAndRegisterSharedPreferencesServiceMock(themeIndex: 2);

        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];

        var themeManager = ThemeManager(themes: themes);
        themeManager.themesStream.listen(expectAsync1((theme) {
          expect(theme[SelectedTheme], themes.first);
        }));
      });

      test(
          'When constructed and last theme index is 2, if the new theme manager has less themes, reset theme',
          () async {
        var sharedPreferences =
            getAndRegisterSharedPreferencesServiceMock(themeIndex: 2);

        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];

        ThemeManager(themes: themes);
        verify(sharedPreferences.themeIndex = null);
      });

      test(
          'When constructed and no theme has been selected we broadcast the first theme',
          () async {
        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];

        var themeManager = ThemeManager(themes: themes);
        themeManager.themesStream.listen(expectAsync1((theme) {
          expect(theme[SelectedTheme], themes.first);
        }));
      });

      test(
          'When constructed with dark and light theme, should broadcast the light theme as selected and darkTheme as darkTheme',
          () async {
        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];

        var themeManager =
            ThemeManager(lightTheme: themes.first, darkTheme: themes.last);
        themeManager.themesStream.listen(expectAsync1((theme) {
          expect(theme[SelectedTheme], themes.first);
          expect(theme[DarkTheme], themes.last,
              reason: 'Should broadcast dark theme if 1 is supplied');
        }));
      });
    });

    group('themesStream -', () {
      test('After construction, should broadcast the first theme from themes',
          () {
        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];
        var themeManager = ThemeManager(themes: themes);
        themeManager.themesStream.listen(expectAsync1((theme) {
          expect(theme[SelectedTheme], themes.first);
        }));
      });
    });

    group('selectThemeAtIndex -', () {
      test(
          'When called with index 1, should broadcast the theme at 1 over the themesStream',
          () {
        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];
        var themeManager = ThemeManager(themes: themes);
        bool alreadyCalled = false;
        themeManager.themesStream.listen(expectAsync1((theme) {
          if (alreadyCalled) {
            expect(theme[SelectedTheme], themes[1]);
          }
          alreadyCalled = true;
        }, count: 2));

        themeManager.selectThemeAtIndex(1);
      });
    });

    group('Theme Persistence -', () {
      test(
          'When a theme changes the index should be persisted into shared preferences',
          () {
        var sharedPreferences = getAndRegisterSharedPreferencesServiceMock();
        var themes = [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ];
        var themeManager = ThemeManager(themes: themes);
        themeManager.selectThemeAtIndex(1);
        verify(sharedPreferences.themeIndex = 1);
      });

      test(
          'When theme manager contructed, should get the themeIndex from the shared preferences',
          () {
        var sharedPreferences = getAndRegisterSharedPreferencesServiceMock();
        ThemeManager(themes: [
          ThemeData(primaryColor: Colors.blue),
          ThemeData(primaryColor: Colors.yellow),
        ]);
        verify(sharedPreferences.themeIndex);
      });
    });
  });
}

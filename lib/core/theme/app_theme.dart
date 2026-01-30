import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey.shade400,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blueAccent,
    brightness: Brightness.light,
    onSurface: Colors.blueGrey.shade600,
    surfaceContainer: Colors.white54,
    secondaryContainer: const Color.fromARGB(255, 157, 170, 188),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 108, 159, 225),
    foregroundColor: Colors.white,
    iconSize: 24,
    shape: const CircleBorder(),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.blueGrey),
    ),
  ),
  iconTheme: IconThemeData(color: Colors.blueGrey),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.blueGrey),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo.shade400,
    brightness: Brightness.dark,
    onSurface: Colors.blueGrey.shade200,
    surfaceContainer: Colors.white12,
    secondaryContainer: Colors.blueGrey.shade900,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.indigo.shade400,
    foregroundColor: Colors.white,
    iconSize: 24,
    shape: const CircleBorder(),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade600),
    ),
  ),
  iconTheme: IconThemeData(color: Colors.blueGrey.shade600),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.blueGrey),
);

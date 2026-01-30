import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class ThemeState {
  final ThemeMode themeMode;
  ThemeState({required this.themeMode});
}

class ThemeViewModel extends StateNotifier<ThemeState> {
  ThemeViewModel() : super(ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    state = ThemeState(
      themeMode: state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}

final themeViewModelProvider =
    StateNotifierProvider<ThemeViewModel, ThemeState>(
      (ref) => ThemeViewModel(),
    );

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ThemeController {
  final themeMode = signal<ThemeMode>(ThemeMode.light);
  
  late final isLightMode = computed(() => themeMode.value == ThemeMode.light);

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

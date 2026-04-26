import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart' as AppTheme;
import 'core/theme/theme_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  final themeController = injector.get<ThemeController>();

  runApp(
    Watch(
      (_) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Injustice App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routerConfig: AppRouter.router,
      ),
    ),
  );
}

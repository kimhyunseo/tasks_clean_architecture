import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tasks/core/routes/app_route.dart';
import 'package:tasks/firebase_options.dart';
import 'package:tasks/core/theme/app_theme.dart';
import 'package:tasks/ui/theme_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ko_KR', '');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return MaterialApp.router(
      routerConfig: router,
      themeMode: themeState.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}

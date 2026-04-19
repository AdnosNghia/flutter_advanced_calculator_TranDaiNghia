import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'providers/calculator_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/history_provider.dart';
import 'screens/calculator_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalculatorProvider(storageService)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(storageService)..init(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Advanced Calculator',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            home: const CalculatorScreen(),
          );
        },
      ),
    );
  }
}

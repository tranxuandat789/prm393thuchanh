import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/book_provider.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

void main() {
  // Ensure Flutter binding is initialized for SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => BookProvider(),
      child: const BookifyApp(),
    ),
  );
}

class BookifyApp extends StatelessWidget {
  const BookifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        return MaterialApp(
          title: 'Bookify',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: bookProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}

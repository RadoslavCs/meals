import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals/screens/tabs.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  // základ z tmavej témy, aby bol text svetlý (nie tmavý na tmavom pozadí)
  textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: theme, // vlastná tmavá téma s písmom Lato
      home: const TabsScreen(), // hlavná navigácia aplikácie
    );
  }
}

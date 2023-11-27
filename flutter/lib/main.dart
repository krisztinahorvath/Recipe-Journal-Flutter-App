import 'package:flutter/material.dart';
import 'package:flutter_app/repository/repository.dart';
import 'package:flutter_app/views/add_screen.dart';
import 'package:flutter_app/views/details_screen.dart';
import 'package:flutter_app/views/list_screen.dart';
import 'package:flutter_app/views/update_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Repository(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(205, 31, 127, 201),
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.dancingScript(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          centerTitle: true,
        ),
      ),
      home: const RecipeListScreen(),
      routes: {
        '/details': (context) => const RecipeDetailsScreen(),
        '/add': (context) => RecipeAddScreen(),
        '/update': (context) => const RecipeUpdateScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/features/auth/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6FFF),
          primary: const Color(0xFF4A6FFF),
        ),
        useMaterial3: false,
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      home: Splashscreen(),
    );
  }
}

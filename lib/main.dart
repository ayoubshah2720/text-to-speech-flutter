import 'package:flutter/material.dart';
import 'package:voice_text/home_page.dart';
import 'package:voice_text/pallet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// open_AI_Key
// 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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Pallete.whiteColor,
          appBarTheme: AppBarTheme(backgroundColor: Pallete.whiteColor)),
      home: const HomePage(),
    );
  }
}

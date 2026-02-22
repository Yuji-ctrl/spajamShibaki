import 'package:flutter/material.dart';
import 'home.dart';
import 'punish.dart';
import 'result.dart';
import 'report.dart';
import 'thanks.dart';//なんかここを付けると↑4行が未使用になる

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'しばきアプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/shibaki': (context) => const ShibakiScreen(),
        '/result': (context) => const ResultScreen(),
        '/info': (context) => const InfoScreen(),
        '/thanks': (context) => const ThanksScreen(),
      },
    );
  }
}












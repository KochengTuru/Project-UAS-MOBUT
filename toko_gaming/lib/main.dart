import 'package:flutter/material.dart';
import 'pages/splash_router.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Gaming',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashRouter(),
    );
  }
}

import 'package:flutter/material.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dialogTheme: const DialogTheme(
          backgroundColor: Color.fromRGBO(196, 196, 196, 0.83),
        ),
        textTheme: const TextTheme(
          titleSmall: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      home: const HomePage(),
    ),
  );
}

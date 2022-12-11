import 'package:flutter/material.dart';

import 'database.dart';
import 'page/home_page.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseRepository.instance.database;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LocThemeData.data,
      home: const HomePage(),
    ),
  );
}

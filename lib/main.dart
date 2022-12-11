import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database.dart';
import 'pages/home_page.dart';
import 'providers/localization_provider.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseRepository.instance.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LocThemeData.data,
        home: const HomePage(),
      ),
    ),
  );
}

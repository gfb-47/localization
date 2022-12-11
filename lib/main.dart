import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home_page.dart';
import 'utils/consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openLazyBox<Map<String, dynamic>>(AppConsts.latLongBox);

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

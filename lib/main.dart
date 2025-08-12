import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_app/app/core/theme/theme.dart';
import 'package:pharma_app/app/data/database/database_helper.dart';

import 'app/routes/app_pages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initializeDatabase();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pharma App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.lightTheme,
    ),
  );
}

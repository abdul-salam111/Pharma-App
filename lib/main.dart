import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_app/app/core/theme/theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pharma App",
      initialRoute: Routes.ALL_PRODUCTS,
      getPages: AppPages.routes,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.lightTheme,
    ),
  );
}

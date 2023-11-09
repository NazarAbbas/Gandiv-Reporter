import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gandiv/route_management/all_pages.dart';
import 'package:gandiv/route_management/routes.dart';
import 'package:gandiv/ui/binding/screen_binding.dart';
import 'package:gandiv/constants/values/app_language.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'constants/constant.dart';
import 'constants/dependency_injection/dependency_injection.dart';
import 'constants/emuns.dart';
import 'network/my_http_overrides.dart';

void main() async {
  await DependencyInjection.init();
  await GetStorage.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final String language;
    final String country;
    final languageId = GetStorage().read(Constant.selectedLanguage);
    if (languageId == Language.english) {
      language = Constant.englishLanguage;
      country = Constant.englishCountry;
    } else {
      language = Constant.hindiLanguage;
      country = Constant.hindiCountry;
    }
    return GetMaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: true,
        translations: Languages(),
        locale: Locale(language, country),
        fallbackLocale: Locale(language, country),
        theme: ThemeData(
          primaryColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.grey),
          ),
          fontFamily: AppFontFamily.hindiFontStyle,
        ),
        // theme: ThemeData(
        //   // UI
        //   primaryColor: AppColors.colorPrimary,
        //   accentColor: const Color(0xffF05523),
        //   // font
        //   // fontFamily: 'Georgia',
        //   //text style
        //   // textTheme: const TextTheme(
        //   //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //   //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        //   // ),
        // ),
        initialRoute: Routes.splashPage,
        initialBinding: ScreenBindings(),
        getPages: AllPages.getPages());
  }
}

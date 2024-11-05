import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'doctor/contact_inbox_page.dart';
import 'doctor/order_cart.dart';
import 'doctor/prescription.dart';
import 'pharmacy/create_medicine_page.dart';
import 'pharmacy/pharmacy_home_page.dart';
import 'pharmacy/stock_page.dart';

import 'doctor/doctor_home_page.dart';
import 'login.dart';
import 'patient/patient_home_page.dart';
import 'pharmacy/add_medicine_page.dart';
import 'pharmacy/edit_medicine_page.dart';
import 'pharmacy/order_detail_page.dart';
import 'services/theme_services.dart';
import 'theme.dart';

void main() async{
  await GetStorage.init(); // Initialize get_storage

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,

      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

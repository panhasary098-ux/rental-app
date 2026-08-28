import 'package:final_project/model/property.dart';
import 'package:final_project/view/auth/login_screen.dart';
import 'package:final_project/view/house_owner/post_property/post_step1.dart';
import 'package:final_project/view/renter/filter_screen.dart';
import 'package:final_project/view/renter/home_screen.dart';
import 'package:final_project/widget/bottom_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //home: BottomNav(properties: propertyList),
      //home: LoginScreen()
      //home: FilterScreen(),
      //home: HomeScreen(),
      home: PostStep1(),
    );
  }
}

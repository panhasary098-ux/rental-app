import 'package:final_project/view/admin/admin_dashboard_screen.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:final_project/widget/admin_bottom_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //home: BottomNav(properties: propertyList),
       home: LoginScreen()
     // home: AdminDashboardScreen()
     // home: AdminBottomNav()
    );
  }
}

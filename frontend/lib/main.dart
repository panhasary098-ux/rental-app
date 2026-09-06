import 'package:final_project/model/property.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:final_project/view/house_owner/house_owner_account_screen.dart';
import 'package:final_project/view/renter/renter_account_screen.dart';
import 'package:final_project/widget/admin_bottom_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // Keep your authentication flow as the starting screen
      home: LoginScreen(),
      //home: OwnerAccountScreen()
      //home: RenterAccountScreen(),

      // Testing screens if needed later:
      // home: AdminDashboardScreen(),
      // home: AdminBottomNav(),
      // home: BottomNav(properties: propertyList),
      // home: FilterScreen(),
      // home: HomeScreen(),
      // home: PostStep1(),
      //home: Postpropertyscreen(),
    );
  }
}
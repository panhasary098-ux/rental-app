
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
      //home: LoginScreen(),
      //home: OwnerAccountScreen()
      //home: RenterAccountScreen(),
      //home: OwnerBottomNav(),

      // Testing screens if needed later:
      // home: AdminDashboardScreen(),
      // home: AdminBottomNav(),
      //home: BottomNav(),
      // home: FilterScreen(),
      // home: HomeScreen(),
      // home: PostStep1(),
      //home: Postpropertyscreen(),
      //home: AllPropertiesScreen(properties: properties),
    );
  }
}

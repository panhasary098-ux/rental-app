import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/admin_nav_controller.dart';
import '../view/admin/admin_dashboard_screen.dart';
import '../view/admin/pending_verification_screen.dart';
import '../view/admin/manage_properties_screen.dart';
import '../view/admin/manage_users_screen.dart';

class AdminBottomNav extends StatelessWidget {
  AdminBottomNav({super.key});

  final AdminNavController controller =
      Get.put(AdminNavController());

  final List<Widget> screens = [
    AdminDashboardScreen(),
    PendingVerificationScreen(),
    ManagePropertiesScreen(),
    ManageUsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: screens[controller.selectedIndex.value],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,

          onTap: (index) {
            controller.changePage(index);
          },

          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,

          selectedItemColor: Color(0xFF198754),
          unselectedItemColor: Color(0xFF9CA3AF),

          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
          ),

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.verified_outlined),
              activeIcon: Icon(Icons.verified_rounded),
              label: "Verify",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work_outlined),
              activeIcon: Icon(Icons.home_work_rounded),
              label: "Properties",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: "Users",
            ),
          ],
        ),
      ),
    );
  }
}
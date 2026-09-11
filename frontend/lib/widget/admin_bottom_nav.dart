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
        backgroundColor: Color(0xFFF7FAF8),

        body: screens[controller.selectedIndex.value],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            border: Border(
              top: BorderSide(
                color: Color(0xFFE8E8F0),
                width: 1,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: Offset(0, -3),
              ),
            ],
          ),

          child: SafeArea(
            top: false,

            child: Padding(
              padding: EdgeInsets.fromLTRB(
                12,
                8,
                12,
                8,
              ),

              child: Row(
                children: [
                  buildNavItem(
                    index: 0,
                    icon: Icons.dashboard_outlined,
                    selectedIcon: Icons.dashboard_rounded,
                    label: "Dashboard",
                  ),

                  buildNavItem(
                    index: 1,
                    icon: Icons.verified_outlined,
                    selectedIcon: Icons.verified_rounded,
                    label: "Verify",
                  ),

                  buildNavItem(
                    index: 2,
                    icon: Icons.home_work_outlined,
                    selectedIcon: Icons.home_work_rounded,
                    label: "Properties",
                  ),

                  buildNavItem(
                    index: 3,
                    icon: Icons.people_outline,
                    selectedIcon: Icons.people_rounded,
                    label: "Users",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    bool isSelected =
        controller.selectedIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          controller.changePage(index);
        },

        borderRadius: BorderRadius.circular(22),

        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 4,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 180),

                width: isSelected ? 62 : 46,
                height: 32,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(0xFF03045E)
                      : Colors.transparent,

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(
                  isSelected
                      ? selectedIcon
                      : icon,

                  size: 22,

                  color: isSelected
                      ? Colors.white
                      : Color(0xFF8E8AA8),
                ),
              ),

              SizedBox(height: 4),

              Text(
                label,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 10.5,

                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,

                  color: isSelected
                      ? Color(0xFF03045E)
                      : Color(0xFF8E8AA8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:final_project/view/house_owner/house_owner_account_screen.dart';
import 'package:final_project/view/house_owner/my_property.dart';
import 'package:final_project/view/house_owner/owner_homescreen.dart';
import 'package:final_project/view/house_owner/post_property/PostPropertyScreen.dart';
import 'package:flutter/material.dart';

class OwnerBottomNav extends StatefulWidget {
  OwnerBottomNav({super.key});

  @override
  State<OwnerBottomNav> createState() => _OwnerBottomNavState();
}

class _OwnerBottomNavState extends State<OwnerBottomNav> {
  int selectedIndex = 0;

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),

      body: IndexedStack(
        index: selectedIndex,
        children: [
          OwnerHomeScreen(),
          OwnerPropertiesScreen(),
          Postpropertyscreen(),
          OwnerAccountScreen(),
        ],
      ),

      bottomNavigationBar: Container(
        height: 76,

        decoration: BoxDecoration(
          color: Colors.white,

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.16),
              blurRadius: 14,
              offset: Offset(0, -3),
            ),
          ],
        ),

        child: SafeArea(
          top: false,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              buildNavItem(
                icon: Icons.home_rounded,
                label: "Home",
                index: 0,
              ),

              buildNavItem(
                icon: Icons.home_work_outlined,
                label: "Properties",
                index: 1,
              ),

              buildNavItem(
                icon: Icons.add_home_work_outlined,
                label: "Post",
                index: 2,
              ),

              buildNavItem(
                icon: Icons.person_outline_rounded,
                label: "Account",
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BOTTOM NAV ITEM
  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool selected = selectedIndex == index;

    return InkWell(
      onTap: () {
        changePage(index);
      },

      child: SizedBox(
        width: 78,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 5,
              ),

              decoration: BoxDecoration(
                color: selected
                    ? Color(0xFFE8E9FF)
                    : Colors.transparent,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Icon(
                icon,
                size: 24,

                color: selected
                    ? Color(0xFF03045E)
                    : Color(0xFF98A2B3),
              ),
            ),

            SizedBox(height: 3),

            Text(
              label,

              style: TextStyle(
                fontSize: 10.5,

                fontWeight:
                    selected ? FontWeight.bold : FontWeight.w500,

                color: selected
                    ? Color(0xFF03045E)
                    : Color(0xFF98A2B3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TEMPORARY SCREEN
  Widget buildTemporaryScreen({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: Color(0xFFF8FAFC),

      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 80,
                height: 80,

                decoration: BoxDecoration(
                  color: Color(0xFFE8E9FF),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  icon,
                  size: 36,
                  color: Color(0xFF03045E),
                ),
              ),

              SizedBox(height: 18),

              Text(
                title,

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045E),
                ),
              ),

              SizedBox(height: 6),

              Text(
                subtitle,

                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7D8990),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
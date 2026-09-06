import 'package:final_project/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAF9),

      appBar: AppBar(
        backgroundColor: Color(0xFFF8FAF9),
        elevation: 0,
        toolbarHeight: 45,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 4,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // LOGO
              Center(
                child: Container(
                  width: 56,
                  height: 56,

                  decoration: BoxDecoration(
                    color: Color(0xFF03045E),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

              SizedBox(height: 12),

              // TITLE
              Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ),

              SizedBox(height: 4),

              Center(
                child: Text(
                  "Join our trusted rental community.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),

              SizedBox(height: 18),

              // ROLE
              buildLabel("Register as"),

              SizedBox(height: 7),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectRole("Renter");
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: controller.selectedRole.value == "Renter"
                                ? Color(0xFF03045E)
                                : Colors.white,

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(
                              color: controller.selectedRole.value == "Renter"
                                  ? Color(0xFF03045E)
                                  : Color(0xFFE5E7EB),

                              width: 1.5,
                            ),

                            boxShadow:
                                controller.selectedRole.value == "Renter"
                                    ? [
                                        BoxShadow(
                                          color: Color(0xFF03045E)
                                              .withOpacity(0.12),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                          ),

                          child: Column(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                size: 23,

                                color: controller.selectedRole.value == "Renter"
                                    ? Colors.white
                                    : Color(0xFF6B7280),
                              ),

                              SizedBox(height: 3),

                              Text(
                                "Renter",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,

                                  color:
                                      controller.selectedRole.value == "Renter"
                                          ? Colors.white
                                          : Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectRole("House Owner");
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color:
                                controller.selectedRole.value == "House Owner"
                                    ? Color(0xFF03045E)
                                    : Colors.white,

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(
                              color:
                                  controller.selectedRole.value == "House Owner"
                                      ? Color(0xFF03045E)
                                      : Color(0xFFE5E7EB),

                              width: 1.5,
                            ),

                            boxShadow:
                                controller.selectedRole.value == "House Owner"
                                    ? [
                                        BoxShadow(
                                          color: Color(0xFF03045E)
                                              .withOpacity(0.12),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                          ),

                          child: Column(
                            children: [
                              Icon(
                                Icons.home_work_outlined,
                                size: 23,

                                color:
                                    controller.selectedRole.value ==
                                            "House Owner"
                                        ? Colors.white
                                        : Color(0xFF6B7280),
                              ),

                              SizedBox(height: 3),

                              Text(
                                "House Owner",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,

                                  color:
                                      controller.selectedRole.value ==
                                              "House Owner"
                                          ? Colors.white
                                          : Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14),

              // Name
              buildLabel("Full Name"),

              SizedBox(height: 5),

              buildField(
                controller: controller.nameController,
                hint: "Enter your full name",
                icon: Icons.person_outline,
              ),

              SizedBox(height: 10),

              // Email
              buildLabel("Email"),

              SizedBox(height: 5),

              buildField(
                controller: controller.emailController,
                hint: "Enter your email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 10),

              // Phone
              buildLabel("Phone Number"),

              SizedBox(height: 5),

              buildField(
                controller: controller.phoneController,
                hint: "Enter your phone number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 10),

              // Password
              buildLabel("Password"),

              SizedBox(height: 5),

              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.hidePassword.value,

                  decoration: inputDecoration(
                    hint: "Create your password",
                    icon: Icons.lock_outline,

                    suffix: IconButton(
                      onPressed: () {
                        controller.togglePassword();
                      },

                      icon: Icon(
                        controller.hidePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,

                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Confirm pass
              buildLabel("Confirm Password"),

              SizedBox(height: 5),

              Obx(
                () => TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.hideConfirmPassword.value,

                  decoration: inputDecoration(
                    hint: "Confirm your password",
                    icon: Icons.lock_outline,

                    suffix: IconButton(
                      onPressed: () {
                        controller.toggleConfirmPassword();
                      },

                      icon: Icon(
                        controller.hideConfirmPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,

                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Register button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.register();
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF03045E),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),

                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 22,
                            height: 22,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 4),

              // Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Get.back();
                    },

                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF03045E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,

      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,

      decoration: inputDecoration(
        hint: hint,
        icon: icon,
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        fontSize: 14,
        color: Color(0xFF9CA3AF),
      ),

      prefixIcon: Icon(
        icon,
        color: Color(0xFF6B7280),
        size: 21,
      ),

      suffixIcon: suffix,

      filled: true,
      fillColor: Colors.white,

      isDense: true,

      contentPadding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide(
          color: Color(0xFF03045E),
          width: 1.5,
        ),
      ),
    );
  }
}
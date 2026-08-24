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
          padding: EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Center(
                child: Container(
                  width: 64,
                  height: 64,

                  decoration: BoxDecoration(
                    color: Color(0xFF198754),
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),

              SizedBox(height: 22),

              Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ),

              SizedBox(height: 8),

              Center(
                child: Text(
                  "Join our trusted rental community.",
                  style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                ),
              ),

              SizedBox(height: 30),

              // ROLE
              Text(
                "Register as",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),

              SizedBox(height: 10),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectRole("Renter");
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),

                          decoration: BoxDecoration(
                            color: controller.selectedRole.value == "Renter"
                                ? Color(0xFFEAF7F0)
                                : Colors.white,

                            borderRadius: BorderRadius.circular(14),

                            border: Border.all(
                              color: controller.selectedRole.value == "Renter"
                                  ? Color(0xFF198754)
                                  : Color(0xFFE5E7EB),

                              width: 1.5,
                            ),
                          ),

                          child: Column(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                size: 28,

                                color: controller.selectedRole.value == "Renter"
                                    ? Color(0xFF198754)
                                    : Color(0xFF6B7280),
                              ),

                              SizedBox(height: 6),

                              Text(
                                "Renter",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,

                                  color:
                                      controller.selectedRole.value == "Renter"
                                      ? Color(0xFF198754)
                                      : Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectRole("House Owner");
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),

                          decoration: BoxDecoration(
                            color:
                                controller.selectedRole.value == "House Owner"
                                ? Color(0xFFEAF7F0)
                                : Colors.white,

                            borderRadius: BorderRadius.circular(14),

                            border: Border.all(
                              color:
                                  controller.selectedRole.value == "House Owner"
                                  ? Color(0xFF198754)
                                  : Color(0xFFE5E7EB),

                              width: 1.5,
                            ),
                          ),

                          child: Column(
                            children: [
                              Icon(
                                Icons.home_work_outlined,
                                size: 28,

                                color:
                                    controller.selectedRole.value ==
                                        "House Owner"
                                    ? Color(0xFF198754)
                                    : Color(0xFF6B7280),
                              ),

                              SizedBox(height: 6),

                              Text(
                                "House Owner",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,

                                  color:
                                      controller.selectedRole.value ==
                                          "House Owner"
                                      ? Color(0xFF198754)
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

              SizedBox(height: 25),

              // NAME
              buildLabel("Full Name"),

              SizedBox(height: 8),

              buildField(
                controller: controller.nameController,
                hint: "Enter your full name",
                icon: Icons.person_outline,
              ),

              SizedBox(height: 18),

              // EMAIL
              buildLabel("Email"),

              SizedBox(height: 8),

              buildField(
                controller: controller.emailController,
                hint: "Enter your email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 18),

              // PHONE
              buildLabel("Phone Number"),

              SizedBox(height: 8),

              buildField(
                controller: controller.phoneController,
                hint: "Enter your phone number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 18),

              // PASSWORD
              buildLabel("Password"),

              SizedBox(height: 8),

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
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18),

              // CONFIRM PASSWORD
              buildLabel("Confirm Password"),

              SizedBox(height: 8),

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
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28),

              // REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.register();
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF198754),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),

                  TextButton(
                    onPressed: () {
                      Get.back();
                    },

                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF198754),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151)),
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

      decoration: inputDecoration(hint: hint, icon: icon),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon, color: Color(0xFF6B7280)),

      suffixIcon: suffix,

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFFE5E7EB)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFFE5E7EB)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFF198754), width: 1.5),
      ),
    );
  }
}

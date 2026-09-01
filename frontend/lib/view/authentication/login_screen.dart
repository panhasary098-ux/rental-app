import 'package:final_project/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAF9),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 55),

              // Logo
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),

              SizedBox(height: 28),

              Center(
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ),

              SizedBox(height: 8),

              Center(
                child: Text(
                  "Find a trusted place that feels like home.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                ),
              ),

              SizedBox(height: 40),

              // Email
              Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),

              SizedBox(height: 8),

              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,

                decoration: InputDecoration(
                  hintText: "Enter your email",

                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Color(0xFF6B7280),
                  ),

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
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Password
              Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),

              SizedBox(height: 8),

              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.hidePassword.value,

                  decoration: InputDecoration(
                    hintText: "Enter your password",

                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF6B7280),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.togglePassword();
                      },
                      icon: Icon(
                        controller.hidePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),

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
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    controller.forgotPassword();
                  },
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 28),

              
              Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFE5E7EB))),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                ],
              ),

              SizedBox(height: 22),

              // Social login buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,

                      child: OutlinedButton(
                        onPressed: () {
                          controller.loginWithGoogle();
                        },

                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,

                          side: BorderSide(color: Color(0xFFE5E7EB)),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              width: 30,
                              height: 30,

                              decoration: BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                shape: BoxShape.circle,
                              ),

                              alignment: Alignment.center,

                              child: Text(
                                "G",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                            ),

                            SizedBox(width: 8),

                            Text(
                              "Google",
                              style: TextStyle(
                                color: Color(0xFF374151),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 54,

                      child: OutlinedButton(
                        onPressed: () {
                           controller.loginWithFacebook();
                        },

                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,

                          side: BorderSide(color: Color(0xFFE5E7EB)),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.facebook,
                              color: Color(0xFF1877F2),
                              size: 28,
                            ),

                            SizedBox(width: 8),

                            Text(
                              "Facebook",
                              style: TextStyle(
                                color: Color(0xFF374151),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),

                  TextButton(
                    onPressed: () {
                      Get.to(() => RegisterScreen());
                    },

                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.green,
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
}

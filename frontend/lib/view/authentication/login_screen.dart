import 'package:final_project/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FC),
      resizeToAvoidBottomInset: false,

      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;

          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: screenHeight * 0.30,

                padding: EdgeInsets.only(
                  top: 70,
                  left: 24,
                  right: 24,
                ),

                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 7, 8, 77),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [
                    SizedBox(height: 15),

                    // Logo
                    Container(
                      width: 64,
                      height: 64,

                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/logo.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      "JoulNow",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 10),

                  ],
                ),
              ),

              // Bottom section
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -32),

                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                    ),

                    child: Container(
                      width: double.infinity,

                      padding: EdgeInsets.fromLTRB(
                        22,
                        22,
                        22,
                        14,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(24),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.06,
                            ),
                            blurRadius: 25,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Welcome
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "Sign in to continue to your account.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),

                          SizedBox(height: 18),

                          // Email
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),

                          SizedBox(height: 6),

                          SizedBox(
                            height: 50,

                            child: TextField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,

                              decoration: InputDecoration(
                                hintText: "Enter your email",

                                hintStyle: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),

                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF6B7280),
                                  size: 20,
                                ),

                                filled: true,
                                fillColor: Color(0xFFF7F8FC),

                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),

                                  borderSide: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),

                                  borderSide: BorderSide(
                                    color: Color(0xFF03045E),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 14),

                          // Password
                          Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),

                          SizedBox(height: 6),

                          Obx(
                            () => SizedBox(
                              height: 50,

                              child: TextField(
                                controller:
                                    controller.passwordController,

                                obscureText:
                                    controller.hidePassword.value,

                                decoration: InputDecoration(
                                  hintText: "Enter your password",

                                  hintStyle: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 13,
                                  ),

                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: Color(0xFF6B7280),
                                    size: 20,
                                  ),

                                  suffixIcon: IconButton(
                                    onPressed:
                                        controller.togglePassword,

                                    icon: Icon(
                                      controller.hidePassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Color(0xFF6B7280),
                                      size: 20,
                                    ),
                                  ),

                                  filled: true,
                                  fillColor: Color(0xFFF7F8FC),

                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),

                                    borderSide: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),

                                    borderSide: BorderSide(
                                      color: Color(0xFF03045E),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 1),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,

                            child: TextButton(
                              onPressed:
                                  controller.forgotPassword,

                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 4,
                                ),
                              ),

                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Color(0xFF03045E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 3),

                          // Login
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 50,

                              child: ElevatedButton(
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.login,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color(0xFF03045E),

                                  foregroundColor: Colors.white,

                                  disabledBackgroundColor:
                                      Color(0xFF03045E)
                                          .withValues(
                                    alpha: 0.55,
                                  ),

                                  elevation: 0,

                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),

                                child:
                                    controller.isLoading.value
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,

                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2.3,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            "Sign In",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                              ),
                            ),
                          ),

                          SizedBox(height: 14),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),

                              Padding(
                                padding:
                                    EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),

                                child: Text(
                                  "or continue with",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Divider(
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 14),

                          // Google
                          SizedBox(
                            width: double.infinity,
                            height: 50,

                            child: OutlinedButton(
                              onPressed:
                                  controller.loginWithGoogle,

                              style:
                                  OutlinedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 250, 248, 248),

                                side: BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,

                                children: [
                                  Image.network(
                                    "https://developers.google.com/identity/images/g-logo.png",
                                    width: 22,
                                    height: 22,

                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Icon(
                                        Icons
                                            .g_mobiledata_rounded,
                                        size: 28,
                                        color:
                                            Color(0xFF4285F4),
                                      );
                                    },
                                  ),

                                  SizedBox(width: 11),

                                  Text(
                                    "Continue with Google",
                                    style: TextStyle(
                                      color:
                                          Color(0xFF374151),
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Spacer(),

                          // Register
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 12,
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Get.to(
                                    () => RegisterScreen(),
                                  );
                                },

                                child: Text(
                                  "Create account",
                                  style: TextStyle(
                                    color:
                                        Color(0xFF03045E),
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
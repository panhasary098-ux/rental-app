import 'package:final_project/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller =
      Get.put(RegisterController());

  static const Color primaryColor =
      Color.fromARGB(255, 7, 8, 77);

  static const Color fieldColor =
      Color(0xFFF7F8FC);

  static const Color borderColor =
      Color(0xFFE5E7EB);

  static const Color textColor =
      Color(0xFF111827);

  static const Color secondaryTextColor =
      Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FC),

      // Keep page fixed when keyboard opens
      resizeToAvoidBottomInset: false,

      body: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          double screenHeight =
              constraints.maxHeight;

          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,

                height:
                    screenHeight * 0.24,

                padding: EdgeInsets.only(
                  top:
                      MediaQuery.of(context)
                              .padding
                              .top +
                          10,
                  left: 22,
                  right: 22,
                ),

                decoration: BoxDecoration(
                  color: primaryColor,

                  borderRadius:
                      BorderRadius.only(
                    bottomLeft:
                        Radius.circular(
                      35,
                    ),

                    bottomRight:
                        Radius.circular(
                      35,
                    ),
                  ),
                ),

                child: Column(
                  children: [
                    // Back
                    Align(
                      alignment:
                          Alignment.centerLeft,

                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },

                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),

                        child: Container(
                          width: 38,
                          height: 38,

                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.12,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),

                          child: Icon(
                            Icons
                                .arrow_back_ios_new_rounded,

                            color:
                                Colors.white,

                            size: 17,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 3),

                    // Logo
                    Container(
                      width: 52,
                      height: 52,

                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withValues(
                          alpha: 0.15,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          17,
                        ),
                      ),

                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                          17,
                        ),

                        child: Image.asset(
                          "assets/logo.png",

                          fit:
                              BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 7),

                    Text(
                      "JoulNow",

                      style: TextStyle(
                        fontSize: 21,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child:
                    Transform.translate(
                  offset:
                      Offset(0, -24),

                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 20,
                    ),

                    child: Container(
                      width:
                          double.infinity,

                      padding:
                          EdgeInsets.fromLTRB(
                        20,
                        16,
                        20,
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(
                              alpha: 0.06,
                            ),

                            blurRadius: 24,

                            offset:
                                Offset(
                              0,
                              8,
                            ),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          // Title
                          Text(
                            "Create Account",

                            style:
                                TextStyle(
                              fontSize: 22,

                              fontWeight:
                                  FontWeight
                                      .bold,

                              color:
                                  textColor,
                            ),
                          ),

                          SizedBox(
                            height: 2,
                          ),

                          Text(
                            "Join JoulNow and find your next place.",

                            style:
                                TextStyle(
                              fontSize: 11.5,

                              color:
                                  secondaryTextColor,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          // Role
                          buildLabel(
                            "Register as",
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child:
                                      buildRoleCard(
                                    title:
                                        "Renter",

                                    icon: Icons
                                        .person_outline_rounded,

                                    selected: controller
                                            .selectedRole
                                            .value ==
                                        "Renter",

                                    onTap:
                                        () {
                                      controller
                                          .selectRole(
                                        "Renter",
                                      );
                                    },
                                  ),
                                ),

                                SizedBox(
                                  width: 8,
                                ),

                                Expanded(
                                  child:
                                      buildRoleCard(
                                    title:
                                        "House Owner",

                                    icon: Icons
                                        .home_work_outlined,

                                    selected: controller
                                            .selectedRole
                                            .value ==
                                        "House Owner",

                                    onTap:
                                        () {
                                      controller
                                          .selectRole(
                                        "House Owner",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 9,
                          ),

                          // Name
                          buildLabel(
                            "Full Name",
                          ),

                          SizedBox(
                            height: 4,
                          ),

                          buildField(
                            controller:
                                controller
                                    .nameController,

                            hint:
                                "Enter your full name",

                            icon: Icons
                                .person_outline_rounded,
                          ),

                          SizedBox(
                            height: 7,
                          ),

                          // Email
                          buildLabel(
                            "Email",
                          ),

                          SizedBox(
                            height: 4,
                          ),

                          buildField(
                            controller:
                                controller
                                    .emailController,

                            hint:
                                "Enter your email",

                            icon: Icons
                                .email_outlined,

                            keyboardType:
                                TextInputType
                                    .emailAddress,
                          ),

                          SizedBox(
                            height: 7,
                          ),

                          // Phone
                          buildLabel(
                            "Phone Number",
                          ),

                          SizedBox(
                            height: 4,
                          ),

                          buildField(
                            controller:
                                controller
                                    .phoneController,

                            hint:
                                "Enter your phone number",

                            icon: Icons
                                .phone_outlined,

                            keyboardType:
                                TextInputType
                                    .phone,
                          ),

                          SizedBox(
                            height: 7,
                          ),

                          // Password
                          buildLabel(
                            "Password",
                          ),

                          SizedBox(
                            height: 4,
                          ),

                          Obx(
                            () => SizedBox(
                              height: 43,

                              child:
                                  TextField(
                                controller:
                                    controller
                                        .passwordController,

                                obscureText:
                                    controller
                                        .hidePassword
                                        .value,

                                decoration:
                                    inputDecoration(
                                  hint:
                                      "Create your password",

                                  icon: Icons
                                      .lock_outline_rounded,

                                  suffix:
                                      IconButton(
                                    onPressed:
                                        () {
                                      controller
                                          .togglePassword();
                                    },

                                    icon:
                                        Icon(
                                      controller
                                              .hidePassword
                                              .value
                                          ? Icons
                                              .visibility_off_outlined
                                          : Icons
                                              .visibility_outlined,

                                      size:
                                          19,

                                      color:
                                          secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 7,
                          ),

                          // Confirm Password
                          buildLabel(
                            "Confirm Password",
                          ),

                          SizedBox(
                            height: 4,
                          ),

                          Obx(
                            () => SizedBox(
                              height: 43,

                              child:
                                  TextField(
                                controller:
                                    controller
                                        .confirmPasswordController,

                                obscureText:
                                    controller
                                        .hideConfirmPassword
                                        .value,

                                decoration:
                                    inputDecoration(
                                  hint:
                                      "Confirm your password",

                                  icon: Icons
                                      .lock_outline_rounded,

                                  suffix:
                                      IconButton(
                                    onPressed:
                                        () {
                                      controller
                                          .toggleConfirmPassword();
                                    },

                                    icon:
                                        Icon(
                                      controller
                                              .hideConfirmPassword
                                              .value
                                          ? Icons
                                              .visibility_off_outlined
                                          : Icons
                                              .visibility_outlined,

                                      size:
                                          19,

                                      color:
                                          secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Spacer(),

                          // Register Button
                          Obx(
                            () => SizedBox(
                              width:
                                  double.infinity,

                              height: 46,

                              child:
                                  ElevatedButton(
                                onPressed: controller
                                        .isLoading
                                        .value
                                    ? null
                                    : () {
                                        controller
                                            .register();
                                      },

                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      Color(
                                    0xFF03045E,
                                  ),

                                  foregroundColor:
                                      Colors
                                          .white,

                                  disabledBackgroundColor:
                                      Color(
                                    0xFF03045E,
                                  ).withValues(
                                    alpha:
                                        0.55,
                                  ),

                                  elevation:
                                      0,

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      13,
                                    ),
                                  ),
                                ),

                                child: controller
                                        .isLoading
                                        .value
                                    ? SizedBox(
                                        width:
                                            19,
                                        height:
                                            19,

                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2,

                                          color:
                                              Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Create Account",

                                        style:
                                            TextStyle(
                                          fontSize:
                                              14,

                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 1,
                          ),

                          // Login
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              Text(
                                "Already have an account?",

                                style:
                                    TextStyle(
                                  fontSize:
                                      11.5,

                                  color:
                                      secondaryTextColor,
                                ),
                              ),

                              TextButton(
                                onPressed:
                                    () {
                                  Get.back();
                                },

                                style:
                                    TextButton
                                        .styleFrom(
                                  padding:
                                      EdgeInsets
                                          .symmetric(
                                    horizontal:
                                        5,
                                  ),
                                ),

                                child:
                                    Text(
                                  "Sign in",

                                  style:
                                      TextStyle(
                                    fontSize:
                                        11.5,

                                    color:
                                        Color(
                                      0xFF03045E,
                                    ),

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

  // Role
  Widget buildRoleCard({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration:
            Duration(
          milliseconds: 180,
        ),

        height: 48,

        decoration:
            BoxDecoration(
          color: selected
              ? Color(
                  0xFF03045E,
                )
              : fieldColor,

          borderRadius:
              BorderRadius.circular(
            12,
          ),

          border: Border.all(
            color: selected
                ? Color(
                    0xFF03045E,
                  )
                : borderColor,

            width: 1.2,
          ),
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icon,

              size: 18,

              color: selected
                  ? Colors.white
                  : secondaryTextColor,
            ),

            SizedBox(width: 6),

            Flexible(
              child: Text(
                title,

                maxLines: 1,

                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 11.5,

                  fontWeight:
                      FontWeight.w700,

                  color: selected
                      ? Colors.white
                      : Color(
                          0xFF374151,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Label
  Widget buildLabel(
    String text,
  ) {
    return Text(
      text,

      style: TextStyle(
        fontSize: 11.5,

        fontWeight:
            FontWeight.w600,

        color:
            Color(0xFF374151),
      ),
    );
  }

  // Field
  Widget buildField({
    required TextEditingController
        controller,

    required String hint,

    required IconData icon,

    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 43,

      child: TextField(
        controller:
            controller,

        keyboardType:
            keyboardType,

        decoration:
            inputDecoration(
          hint: hint,
          icon: icon,
        ),
      ),
    );
  }

  // Decoration
  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle:
          TextStyle(
        color:
            Color(0xFF9CA3AF),

        fontSize: 12,
      ),

      prefixIcon:
          Icon(
        icon,

        color:
            secondaryTextColor,

        size: 18,
      ),

      suffixIcon:
          suffix,

      filled: true,

      fillColor:
          fieldColor,

      isDense: true,

      contentPadding:
          EdgeInsets.symmetric(
        vertical: 11,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),

        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),

        borderSide:
            BorderSide(
          color:
              borderColor,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),

        borderSide:
            BorderSide(
          color:
              Color(0xFF03045E),

          width: 1.4,
        ),
      ),
    );
  }
}
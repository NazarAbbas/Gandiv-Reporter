import 'package:flutter/material.dart';
import 'package:gandiv/constants/values/app_colors.dart';
import 'package:gandiv/ui/controllers/dashboard_page_cotroller.dart';
import 'package:gandiv/ui/controllers/forgot_password_page_controller.dart';
import 'package:get/get.dart';

import '../../../constants/values/app_images.dart';

// ignore: must_be_immutable
class ForgotPasswordPage extends GetView<ForgotPasswordPageController> {
  ForgotPasswordPage({super.key});

  DashboardPageController dashboardPageController =
      Get.find<DashboardPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: dashboardPageController.isDarkTheme.value == true
            ? AppColors.dartTheme
            : AppColors.colorPrimary,
        title: Text('forgot_password'.tr),
      ),
      body: Form(
        key: controller.formGlobalKey,
        child: Obx(
          () => Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.loginLackground),
                  fit: BoxFit.cover,
                ),
              ),
              // color: dashboardPageController.isDarkTheme.value == true
              //     ? AppColors.dartTheme
              //     : AppColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 350,
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    semanticContainer: true,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(width: 1, color: Colors.blue)),
                    shadowColor: Colors.grey,
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: <Widget>[
                          topImageWidget(),
                          emailWidget(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: SizedBox(
                              height: 60, //height of button
                              width: double.infinity, //width of button
                              child: ElevatedButton(
                                onPressed: () {
                                  sendButtonClick(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: dashboardPageController
                                                .isDarkTheme.value ==
                                            true
                                        ? AppColors.white
                                        : AppColors.colorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(1))),
                                child: Text(
                                  style: TextStyle(
                                      color: dashboardPageController
                                                  .isDarkTheme.value ==
                                              true
                                          ? AppColors.black
                                          : AppColors.white),
                                  'submit'.tr,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendButtonClick(BuildContext context) async {
    await controller.onForgotPassword();
  }

  Image topImageWidget() {
    return Image.asset(
      AppImages.appLogo,
      fit: BoxFit.contain,
      color: dashboardPageController.isDarkTheme.value == true
          ? AppColors.white
          : AppColors.black,
    );
  }

  Padding emailWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: TextFormField(
        onChanged: (text) {
          // controller.isValidEmail();
        },
        controller: controller.emailController,
        validator: (emailOrMobileNumer) {
          return controller.isValidEmail();
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: dashboardPageController.isDarkTheme.value == true
                      ? Colors.white
                      : AppColors.colorPrimary)),
          isDense: true,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: dashboardPageController.isDarkTheme.value == true
                      ? Colors.white
                      : AppColors.colorPrimary)),
          labelText: 'email'.tr,
          hintText: 'email'.tr,
          hintStyle: TextStyle(
              color: dashboardPageController.isDarkTheme.value == true
                  ? Colors.white
                  : AppColors.colorPrimary),
          labelStyle: TextStyle(
              color: dashboardPageController.isDarkTheme.value == true
                  ? Colors.white
                  : AppColors.colorPrimary),
          prefixIcon: Icon(Icons.email,
              color: dashboardPageController.isDarkTheme.value == true
                  ? Colors.white
                  : AppColors.colorPrimary),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: dashboardPageController.isDarkTheme.value == true
                      ? Colors.white
                      : AppColors.colorPrimary)),
        ),
      ),
    );
  }
}

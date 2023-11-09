import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gandiv/models/login_request.dart';
import 'package:gandiv/models/login_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/constant.dart';
import '../../constants/dialog_utils.dart';
import '../../constants/utils.dart';
import '../../database/app_database.dart';
import '../../models/profile_db_model.dart';
import '../../network/rest_api.dart';
import '../../route_management/routes.dart';
import 'comman_controller.dart';

class LoginPageController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;
  final AppDatabase appDatabase = Get.find<AppDatabase>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  CommanController commanController = Get.find<CommanController>();

  final formGlobalKey = GlobalKey<FormState>();

  void setPasswordVisible(bool isTrue) {
    isPasswordVisible.value = isTrue;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
  }

  String? isPasswordValid() {
    if (passwordController.text.trim().isEmpty) {
      return 'enter_password'.tr;
    }
    return null;
  }

  String? isValidEmail() {
    if (emailController.text.trim().isEmpty ||
        !emailController.text.trim().isEmail) {
      return 'please_enter_valid_email'.tr;
    }
    return null;
    // final bool emailValid = RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(emailController.text);
  }

  // String? isEmailValid() {
  //   if (emailOrPhoneController.text.trim().isEmpty) {
  //     return "Please enter valid email OR phone number";
  //   }
  //   if (!emailOrPhoneController.text.trim().isEmail &&
  //       !RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
  //           .hasMatch(emailOrPhoneController.text.trim())) {
  //     return "Please enter valid email OR phone number";
  //   }
  //   return null;
  // }

  Future<void> onLogin() async {
    await validateFields();
  }

  Future<void> validateFields() async {
    if (formGlobalKey.currentState!.validate()) {
      formGlobalKey.currentState?.save();
      await executeLoginApi();
    }
  }

  Future<void> executeLoginApi() async {
    Utils(Get.context!).startLoading();
    LoginResponse? loginResponse = LoginResponse();
    try {
      LoginRequest loginRequest = LoginRequest(
          username: emailController.text, password: passwordController.text);
      if (await Utils.checkUserConnection()) {
        loginResponse = await restAPI.calllLoginApi(loginRequest);
        if (loginResponse.status == 200 || loginResponse.status == 201) {
          var profileData = ProfileData(
              id: loginResponse.loginData?.id,
              title: loginResponse.loginData?.title,
              firstName: loginResponse.loginData?.firstName,
              lastName: loginResponse.loginData?.lastName,
              mobileNo: loginResponse.loginData?.mobileNo,
              email: loginResponse.loginData?.email,
              gender: loginResponse.loginData?.gender,
              profileImage: loginResponse.loginData?.profileImage,
              role: loginResponse.loginData?.role,
              token: loginResponse.loginData?.token);
          commanController.isNotLogedIn.value = false;
          commanController.userRole.value = loginResponse.loginData!.role;
          await appDatabase.profileDao.deleteProfile();
          await appDatabase.profileDao.insertProfile(profileData);
          await GetStorage()
              .write(Constant.token, loginResponse.loginData?.token);

          Utils(Get.context!).stopLoading();
          GetStorage().write(Constant.displayStartDate, "");
          GetStorage().write(Constant.apiStartDate, "");
          GetStorage().write(Constant.displayEndDate, "");
          GetStorage().write(Constant.apiEndDate, "");

          //Get.back();
          if (loginResponse.loginData!.isChangePassword) {
            Get.toNamed(Routes.changePasswordPage, arguments: true);
          } else {
            Fluttertoast.showToast(
                msg: "Login successfully!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            await GetStorage().write(Constant.isLogin, true);
            Get.offNamed(Routes.dashboardScreen);
          }
          // Navigator.of(Get.context!).pushNamedAndRemoveUntil(
          //     Routes.dashboardScreen, (Route<dynamic> route) => false);
        } else {
          Utils(Get.context!).stopLoading();
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            message: 'login_failed_message'
                .tr, // loginResponse.message ?? 'something_went_wrong'.tr,
            btnText: 'ok'.tr,
            callBackFunction: () {
              // Navigator.of(Get.context!).pop();
            },
          );
        }
      } else {
        Utils(Get.context!).stopLoading();
        DialogUtils.noInternetConnection(
          context: Get.context!,
          callBackFunction: () {},
        );
      }
    } on DioException catch (obj) {
      Utils(Get.context!).stopLoading();
      final res = (obj).response;
      if (res?.statusCode == 401) {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'unauthorized_title'.tr,
          message: 'unauthorized_message'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            //Navigator.of(Get.context!).pop();
          },
        );
      }
      if (res?.statusCode == 400) {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'error'.tr,
          message: 'login_failed_message'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            // Navigator.of(Get.context!).pop();
          },
        );
      } else {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'error'.tr,
          message:
              res != null ? res.data['message'] : 'something_went_wrong'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            // Navigator.of(Get.context!).pop();
          },
        );
      }
      //return updateProfilleResponse;
    } on Exception catch (exception) {
      Utils(Get.context!).stopLoading();
      if (kDebugMode) {
        print("Got error : $exception");
      }
      try {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'error'.tr,
          message: 'something_went_wrong'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            // Navigator.of(Get.context!).pop();
          },
        );
      } on Exception catch (exception) {
        final message = exception.toString();
      }
    } finally {}
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gandiv/models/change_password_request.dart';
import 'package:gandiv/models/change_password_response.dart';
import 'package:gandiv/models/login_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/constant.dart';
import '../../constants/dialog_utils.dart';
import '../../constants/utils.dart';
import '../../database/app_database.dart';
import '../../network/rest_api.dart';
import '../../route_management/routes.dart';
import 'comman_controller.dart';

class ChangePasswordPageController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();
  final isPasswordVisible = true.obs;
  final isNewPasswordVisible = true.obs;
  final isConfirmPasswordVisible = true.obs;
  final isLoading = false.obs;
  final AppDatabase appDatabase = Get.find<AppDatabase>();

  final newPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  CommanController commanController = Get.find<CommanController>();
  final isFirstTimeChangePassword = false.obs;

  final formGlobalKey = GlobalKey<FormState>();

  void setPasswordVisible(bool isTrue) {
    isPasswordVisible.value = isTrue;
  }

  void setNewPasswordVisible(bool isTrue) {
    isNewPasswordVisible.value = isTrue;
  }

  void setConfirmPasswordVisible(bool isTrue) {
    isConfirmPasswordVisible.value = isTrue;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isFirstTimeChangePassword.value = Get.arguments;
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  String? isPasswordValid() {
    if (passwordController.text.trim().isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  String? isNewPasswordValid() {
    if (newPasswordController.text.trim().isEmpty) {
      return "Please enter new password";
    }
    return null;
  }

  String? isConfirmPasswordValid() {
    if (confirmPasswordController.text.trim().isEmpty) {
      return "Please enter confirm password";
    } else if (confirmPasswordController.text.trim() !=
        newPasswordController.text.trim()) {
      return "New and confirm password is no matched";
    }
    return null;
  }

  Future<void> onChangePassword() async {
    await validateFields();
  }

  Future<void> validateFields() async {
    if (formGlobalKey.currentState!.validate()) {
      formGlobalKey.currentState?.save();
      await executeChangePasswordApi();
    }
  }

  Future<void> executeChangePasswordApi() async {
    Utils(Get.context!).startLoading();
    ChangePasswordRequest? changePasswordRequest = ChangePasswordRequest(
        oldPassword: passwordController.text.trim(),
        newPassword: confirmPasswordController.text.trim());
    try {
      // LoginRequest loginRequest = LoginRequest(
      //     username: emailController.text, password: passwordController.text);
      if (await Utils.checkUserConnection()) {
        final changePasswordResponse =
            await restAPI.calllChangePasswordApi(changePasswordRequest);
        if (changePasswordResponse.status == 200 ||
            changePasswordResponse.status == 201) {
          Utils(Get.context!).stopLoading();
          Fluttertoast.showToast(
              msg: 'password_change_success_message'.tr,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          if (isFirstTimeChangePassword.value) {
            await GetStorage().write(Constant.isLogin, true);
            //Get.toNamed(Routes.dashboardScreen);
            Get.offAllNamed(Routes.dashboardScreen);
          } else {
            Get.back();
          }
        } else {
          Utils(Get.context!).stopLoading();
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            message: changePasswordResponse.message,
            btnText: 'ok'.tr,
            callBackFunction: () {
              //Navigator.of(Get.context!).pop();
            },
          );
        }
      } else {
        Utils(Get.context!).stopLoading();
        DialogUtils.noInternetConnection(
          context: Get.context!,
          callBackFunction: () {
            Utils(Get.context!).stopLoading();
            //Get.back();
          },
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
      } else {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'error'.tr,
          message:
              res != null ? res.data['message'] : 'something_went_wrong'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            //Navigator.of(Get.context!).pop();
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
            //Navigator.of(Get.context!).pop();
          },
        );
      } on Exception catch (exception) {
        final message = exception.toString();
      }
    } finally {}
  }
}

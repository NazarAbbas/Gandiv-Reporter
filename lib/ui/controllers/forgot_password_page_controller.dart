import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gandiv/constants/dialog_utils.dart';
import 'package:get/get.dart';
import '../../constants/utils.dart';
import '../../network/rest_api.dart';

class ForgotPasswordPageController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;
  final emailController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  void setPasswordVisible(bool isTrue) {
    isPasswordVisible.value = isTrue;
  }

  @override
  void onClose() {
    emailController.dispose();
  }

  String? isValidEmail() {
    if (emailController.text.trim().isEmpty ||
        !emailController.text.trim().isEmail) {
      return 'please_enter_valid_email'.tr;
    }
    return null;
  }

  Future<void> onForgotPassword() async {
    return await validateFields();
  }

  Future<void> validateFields() async {
    if (formGlobalKey.currentState!.validate()) {
      formGlobalKey.currentState?.save();
      await executeForgotPasswordApi();
    }
  }

  Future<void> executeForgotPasswordApi() async {
    // ForgotPasswordResponse? loginResponse = ForgotPasswordResponse();
    Utils(Get.context!).startLoading();
    try {
      if (await Utils.checkUserConnection()) {
        final forgotPasswordResponse = await restAPI.callForgotPassswordApi(
            userName: emailController.text);

        Utils(Get.context!).stopLoading();
        if (forgotPasswordResponse.status == 200 ||
            forgotPasswordResponse.status == 201) {
          DialogUtils.successAlert(
            context: Get.context!,
            title: 'success'.tr,
            message: forgotPasswordResponse.message,
            btnText: 'ok'.tr,
            callBackFunction: () {
              //  Navigator.of(Get.context!).pop();
            },
          );
        } else {
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            message: forgotPasswordResponse.message,
            btnText: 'ok'.tr,
            callBackFunction: () {
              //  Navigator.of(Get.context!).pop();
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
            //  Navigator.of(Get.context!).pop();
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
        if (kDebugMode) {
          print("Got error : $exception");
        }
      }
    } finally {}
  }
}

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gandiv/constants/utils.dart';
import 'package:gandiv/ui/controllers/comman_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/constant.dart';
import '../../constants/dialog_utils.dart';
import '../../database/app_database.dart';
import '../../network/rest_api.dart';
import '../../route_management/routes.dart';

class SplashPageController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();
  final AppDatabase appDatabase = Get.find<AppDatabase>();
  CommanController commanController = Get.find<CommanController>();

  @override
  void onInit() async {
    super.onInit();
    final selectedLanguage = GetStorage();
    //selectedLanguage.write(Constant.selectedLanguage, 1);
    final profileData = await appDatabase.profileDao.findProfile();
    if (profileData.isNotEmpty) {
      commanController.isNotLogedIn.value = false;
      commanController.userRole.value = profileData[0].role!;
    } else {
      commanController.isNotLogedIn.value = true;
    }
    // await Get.offNamed(Routes.dashboardScreen);
    //await getLocationsApis();
    await getCategoriesApis();
  }

  Future<void> getLocationsApis() async {
    try {
      if (await Utils.checkUserConnection()) {
        final response = await restAPI.calllNewsLocations();
        if (response.status == 200 || response.status == 201) {
          await appDatabase.locationsDao.deleteLocations();
          // ignore: avoid_function_literals_in_foreach_calls
          response.data.forEach((element) async {
            await appDatabase.locationsDao.insertLocations(element);
          });
          getCategoriesApis();
        } else {
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            message: response.message,
            btnText: 'ok'.tr,
            callBackFunction: () {
              Navigator.of(Get.context!).pop();
            },
          );
        }
      } else {
        DialogUtils.noInternetConnection(
          context: Get.context!,
          callBackFunction: () {
            exit(0);
          },
        );
      }
    } on DioException catch (obj) {
      final res = (obj).response;
      if (res?.statusCode == 401) {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'unauthorized_title'.tr,
          message: 'unauthorized_message'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            Navigator.of(Get.context!).pop();
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
            Navigator.of(Get.context!).pop();
          },
        );
      }
      //return updateProfilleResponse;
    } on SocketException catch (e) {
      if (kDebugMode) {
        print("Got error ");
      }
    } on Exception catch (exception) {
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
            Navigator.of(Get.context!).pop();
          },
        );
      } on Exception catch (exception) {
        if (kDebugMode) {
          print(exception.toString());
        }
      }
    } finally {}
  }

  Future<void> getCategoriesApis() async {
    try {
      if (await Utils.checkUserConnection()) {
        final response = await restAPI.calllNewsCategories();
        if (response.status == 200 || response.status == 201) {
          await appDatabase.categoriesDao.deleteCategories();
          response.data.sort((a, b) => a.catOrder.compareTo(b.catOrder));
          response.data.removeWhere((category) => category.isActive == false);
          response.data.forEach((element) async {
            await appDatabase.categoriesDao.insertCategories(element);
          });
        } else {
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            message: response.message,
            btnText: 'ok'.tr,
            callBackFunction: () {
              //Navigator.of(Get.context!).pop();
            },
          );
        }
      } else {
        DialogUtils.noInternetConnection(
          context: Get.context!,
          callBackFunction: () {
            //Navigator.of(Get.context!).pop();
          },
        );
      }
    } on DioException catch (obj) {
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
            Navigator.of(Get.context!).pop();
          },
        );
      } on Exception catch (exception) {
        if (kDebugMode) {
          print("Got error : $exception");
        }
      }
    } finally {
      GetStorage().write(Constant.displayStartDate, "");
      GetStorage().write(Constant.displayEndDate, "");
      GetStorage().write(Constant.selectedCategoryName, "");
      GetStorage().write(Constant.selectedCategoryId, "");
      GetStorage().write(Constant.apiStartDate, "");
      GetStorage().write(Constant.apiEndDate, "");
      final isLogin = await GetStorage().read(Constant.isLogin);
      if (isLogin == true) {
        Timer(const Duration(seconds: 1),
            () => Get.offNamed(Routes.dashboardScreen));
      } else {
        Timer(
            const Duration(seconds: 1), () => Get.offNamed(Routes.loginScreen));
      }
      // Get.toNamed(Routes.dashboardScreen);
    }
  }
}

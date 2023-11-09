import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gandiv/constants/emuns.dart';
import 'package:gandiv/models/status_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../constants/constant.dart';
import '../../constants/dialog_utils.dart';
import '../../constants/utils.dart';
import '../../database/app_database.dart';
import '../../network/rest_api.dart';

class DashboardStatusPageController extends GetxController
    with GetTickerProviderStateMixin {
  final AppDatabase appDatabase = Get.find<AppDatabase>();
  var isDataLoading = false.obs;
  final statusData = StatusData().obs;
  final RestAPI restAPI = Get.find<RestAPI>();
  //final fromDate = "".obs;
  //final toDate = "".obs;
  // List<MultiSelectItem<String>> multiSelectCategoriesList =
  //     <MultiSelectItem<String>>[].obs;
  // List<String> categoriesList = <String>[];

  var categoryDropdownValue = 'all'.tr.obs;
  List<String> categroriesList = <String>['all'.tr].obs;
  final categoryDropdownSelectedID = "".obs;

  final displayStartDate = "".obs;
  final displayEndDate = "".obs;

  final apiStartDate = "".obs;
  final apiEndDate = "".obs;

  var today = DateTime.now();
  var displayDateformatter = DateFormat("dd, MMM yyyy");
  var apiDateFormatter = DateFormat("yyyy-MM-dd");
  @override
  void onInit() async {
    super.onInit();
    isDataLoading.value = true;

    if ((GetStorage().read(Constant.displayStartDate)) == null ||
        (GetStorage().read(Constant.displayStartDate).toString() == "")) {
      DateTime prevSixDaysDate = today.subtract(const Duration(days: 6));
      displayStartDate.value = displayDateformatter.format(prevSixDaysDate);
      apiStartDate.value = apiDateFormatter.format(prevSixDaysDate);
      displayEndDate.value = displayDateformatter.format(today);
      apiEndDate.value = apiDateFormatter.format(today);
      GetStorage().write(Constant.displayStartDate, displayStartDate.value);
      GetStorage().write(Constant.apiStartDate, apiStartDate.value);
      GetStorage().write(Constant.displayEndDate, displayEndDate.value);
      GetStorage().write(Constant.apiEndDate, apiEndDate.value);
    } else {
      displayStartDate.value = GetStorage().read(Constant.displayStartDate);
      apiStartDate.value = GetStorage().read(Constant.apiStartDate);
      displayEndDate.value = GetStorage().read(Constant.displayEndDate);
      apiEndDate.value = GetStorage().read(Constant.apiEndDate);
    }
    categroriesList.clear();
    categroriesList.add('all'.tr);
    categoryDropdownValue.value = 'all'.tr;
    final categories = await appDatabase.categoriesDao.findCategories();
    for (var categorie in categories) {
      if (GetStorage().read(Constant.selectedLanguage) == Language.english) {
        categroriesList.add(categorie.name);
      } else {
        categroriesList.add(categorie.hindiName!);
      }
    }

    if (GetStorage().read(Constant.selectedCategoryId).toString().isNotEmpty) {
      if (GetStorage().read(Constant.selectedLanguage) == Language.english) {
        final selectedCategory = await appDatabase.categoriesDao
            .findCategoriessNameById(
                GetStorage().read(Constant.selectedCategoryId));
        categoryDropdownValue.value = selectedCategory!.name;
      } else {
        final selectedCategory = await appDatabase.categoriesDao
            .findCategoriessNameById(
                GetStorage().read(Constant.selectedCategoryId));
        // categroriesList.add(selectedCategory!.hindiName!);
        categoryDropdownValue.value = selectedCategory!.hindiName!;
      }
    }
    await executeStatusApi(apiStartDate.value, apiEndDate.value);
    isDataLoading.value = false;
  }

  Future<void> executeStatusApi(String fromDate, String toDate) async {
    try {
      // Utils(Get.context!).startLoading();
      if (await Utils.checkUserConnection()) {
        final response = await restAPI.callStatusApi(
            fromDate: fromDate,
            toDate: toDate,
            categoryId: categoryDropdownSelectedID.value);
        if (response.status == 200 || response.status == 201) {
          response.statusData.allStatusCount =
              response.statusData.approvedStatusCount! +
                  response.statusData.publishedStatusCount! +
                  response.statusData.draftedStatusCount! +
                  response.statusData.submittedStatusCount!;
          response.statusData.allStatusName = "All";
          response.statusData.allStatusHindiName = 'all'.tr;

          statusData.value = response.statusData;
        } else {
          Utils(Get.context!).stopLoading();
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
        // statusData.value = StatusData(
        //     allStatusName: "All",
        //     allStatusHindiName: 'all'.tr,
        //     allStatusCount: 5,
        //     approvedStatusName: "Approved",
        //     approvedStatusHindiName: 'approved'.tr,
        //     approvedStatusCount: 5,
        //     publishedStatusName: "Published",
        //     publishedStatusHindiName: 'published'.tr,
        //     publishedStatusCount: 3,
        //     submittedStatusName: "Submitted",
        //     submittedStatusHindiName: 'submitted'.tr,
        //     submittedStatusCount: 4,
        //     draftedStatusName: "Drafted",
        //     draftedStatusHindiName: 'drafted'.tr,
        //     draftedStatusCount: 7);
      } else {
        DialogUtils.noInternetConnection(
          context: Get.context!,
          callBackFunction: () {},
        );
      }
    } on DioException catch (obj) {
      // Utils(Get.context!).stopLoading();
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
          message: res != null
              ? res.statusMessage ?? 'something_went_wrong'.tr
              : 'something_went_wrong'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            //Navigator.of(Get.context!).pop();
          },
        );
      }
      //return updateProfilleResponse;
    } on Exception catch (exception) {
      //Utils(Get.context!).stopLoading();
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
        final message = exception.toString();
      }
    } finally {}
  }
}

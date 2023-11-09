import 'package:flutter/material.dart';
import 'package:gandiv/constants/constant.dart';
import 'package:gandiv/constants/values/size_config.dart';
import 'package:gandiv/models/categories_response.dart';
import 'package:gandiv/models/filter_model.dart';
import 'package:gandiv/route_management/routes.dart';
import 'package:gandiv/ui/controllers/dashboard_page_cotroller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../constants/emuns.dart';
import '../../../constants/utils.dart';
import '../../../constants/values/app_colors.dart';
import '../../controllers/dashboard_status_page_controller.dart';

class DashboardStatusPage extends StatefulWidget {
  const DashboardStatusPage({super.key});
  @override
  DashboardStatusStatePage createState() => DashboardStatusStatePage();
}

class DashboardStatusStatePage extends State<DashboardStatusPage> {
  DashboardPageController dashboardPageController =
      Get.find<DashboardPageController>();

  DashboardStatusPageController controller =
      Get.find<DashboardStatusPageController>();
  double width = 0.0;
  double height = 0.0;
  @override
  void initState() {
    super.initState();
  }

  void refreshPage() async {
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.lightGrayColor,
          body: RefreshIndicator(
            color: AppColors.colorPrimary,
            onRefresh: () async {
              // Utils(Get.context!).startLoading();
              await controller.executeStatusApi(
                  controller.apiStartDate.value, controller.apiEndDate.value);
              //  Utils(Get.context!).stopLoading();
            },
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: controller.isDataLoading.value
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColors.transparent,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          children: [
                            categoriesDropDownWidget(),
                            calenderWidget(),
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    allStatusWidget(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 1,
                                          bottom: 1),
                                      child: Row(
                                        children: [
                                          publishedStatusWidget(),
                                          approvedStatusWidget(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 1,
                                          bottom: 1),
                                      child: Row(
                                        children: [
                                          submittedStatusWidget(),
                                          draftedStatusWidget(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding categoriesDropDownWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: GFDropdown(
            padding: const EdgeInsets.all(0),
            borderRadius: BorderRadius.circular(40),
            border: BorderSide(
                color: dashboardPageController.isDarkTheme.value == true
                    ? AppColors.white
                    : AppColors.colorPrimary,
                width: 1),
            dropdownButtonColor:
                dashboardPageController.isDarkTheme.value == true
                    ? AppColors.dartTheme
                    : AppColors.white,
            value: controller.categoryDropdownValue.value,
            onChanged: (newValue) async {
              Categories? selectedCategory;
              if (GetStorage().read(Constant.selectedLanguage) ==
                  Language.english) {
                selectedCategory = await controller.appDatabase.categoriesDao
                    .findCategoriesIdByName(newValue.toString());
              } else {
                selectedCategory = await controller.appDatabase.categoriesDao
                    .findCategoriesIdByhindiName(newValue.toString());
              }
              GetStorage()
                  .write(Constant.selectedCategoryName, newValue.toString());
              controller.categoryDropdownValue.value = newValue.toString();
              controller.categoryDropdownSelectedID.value =
                  selectedCategory == null ? "" : selectedCategory.id;
              GetStorage().write(Constant.selectedCategoryId,
                  selectedCategory == null ? "" : selectedCategory.id);

              Utils(Get.context!).startLoading();
              await controller.executeStatusApi(
                  controller.apiStartDate.value, controller.apiEndDate.value);
              Utils(Get.context!).stopLoading();
            },
            items: controller.categroriesList
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  // Padding categoriesDropDownWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
  //     child: Center(
  //       child: MultiSelectDialogField(
  //         items: controller.multiSelectCategoriesList,
  //         listType: MultiSelectListType.LIST,
  //         title: Text('category'.tr),
  //         itemsTextStyle: TextStyle(
  //             color: dashboardPageController.isDarkTheme.value == true
  //                 ? Colors.white
  //                 : AppColors.black),
  //         selectedItemsTextStyle: TextStyle(
  //             color: dashboardPageController.isDarkTheme.value == true
  //                 ? Colors.white
  //                 : AppColors.black),
  //         checkColor: dashboardPageController.isDarkTheme.value == true
  //             ? AppColors.dartTheme
  //             : AppColors.white,
  //         backgroundColor: dashboardPageController.isDarkTheme.value == true
  //             ? AppColors.dartTheme
  //             : AppColors.white,
  //         selectedColor: dashboardPageController.isDarkTheme.value == true
  //             ? AppColors.white.withOpacity(1)
  //             : AppColors.colorPrimary.withOpacity(1),
  //         decoration: BoxDecoration(
  //           color: dashboardPageController.isDarkTheme.value == true
  //               ? AppColors.dartTheme
  //               : AppColors.white,
  //           borderRadius: const BorderRadius.all(Radius.circular(40)),
  //           border: Border.all(
  //             color: dashboardPageController.isDarkTheme.value == true
  //                 ? AppColors.white
  //                 : AppColors.colorPrimary,
  //             width: 1,
  //           ),
  //         ),
  //         buttonIcon: Icon(
  //           Icons.arrow_drop_down,
  //           color: dashboardPageController.isDarkTheme.value == true
  //               ? AppColors.white
  //               : AppColors.black,
  //         ),
  //         buttonText: Text(
  //           'please_select_category'.tr,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             color: dashboardPageController.isDarkTheme.value == true
  //                 ? AppColors.white
  //                 : AppColors.black,
  //             fontSize: 16,
  //           ),
  //         ),
  //         onConfirm: (results) async {
  //           // for (int i = 0; i < results.length; i++) {
  //           //   final selectedId = await controller.appDatabase.categoriesDao
  //           //       .findCategoriesIdByName(results[i]);
  //           //   controller.categoriesDropdownSelectedID
  //           //       .add(selectedId!.id.toString());
  //           // }
  //         },
  //       ),
  //     ),
  //   );
  // }

  Expanded draftedStatusWidget() {
    return Expanded(
      child: Card(
        elevation: 20,
        child: GestureDetector(
          onTap: () {
            moveToNextScreen(
                GetStorage().read(Constant.selectedLanguage) == Language.english
                    ? controller.statusData.value.draftedStatusName.toString()
                    : controller.statusData.value.draftedStatusHindiName
                        .toString(),
                controller.statusData.value.draftedStatusId ?? 0);
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1.0,
                // assign the color to the border color
                color: AppColors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'drafted'.tr,
                  GetStorage().read(Constant.selectedLanguage) ==
                          Language.english
                      ? controller.statusData.value.draftedStatusName.toString()
                      : controller.statusData.value.draftedStatusHindiName
                          .toString(),
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
                Text(
                  // '(2)',
                  "(${controller.statusData.value.draftedStatusCount})",
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded submittedStatusWidget() {
    return Expanded(
      child: Card(
        elevation: 20,
        child: GestureDetector(
          onTap: () {
            moveToNextScreen(
                GetStorage().read(Constant.selectedLanguage) == Language.english
                    ? controller.statusData.value.submittedStatusName.toString()
                    : controller.statusData.value.submittedStatusHindiName
                        .toString(),
                controller.statusData.value.submittedStatusId ?? 0);
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1.0,
                // assign the color to the border color
                color: AppColors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'submitted'.tr,
                  GetStorage().read(Constant.selectedLanguage) ==
                          Language.english
                      ? controller.statusData.value.submittedStatusName
                          .toString()
                      : controller.statusData.value.submittedStatusHindiName
                          .toString(),
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
                Text(
                  // '(5)',
                  "(${controller.statusData.value.submittedStatusCount})",
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded approvedStatusWidget() {
    return Expanded(
      child: Card(
        elevation: 20,
        child: GestureDetector(
          onTap: () {
            moveToNextScreen(
                GetStorage().read(Constant.selectedLanguage) == Language.english
                    ? controller.statusData.value.approvedStatusName.toString()
                    : controller.statusData.value.approvedStatusHindiName
                        .toString(),
                controller.statusData.value.approvedStatusId ?? 0);
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1.0,
                // assign the color to the border color
                color: AppColors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'approved'.tr,
                  GetStorage().read(Constant.selectedLanguage) ==
                          Language.english
                      ? controller.statusData.value.approvedStatusName
                          .toString()
                      : controller.statusData.value.approvedStatusHindiName
                          .toString(),
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
                Text(
                  // '(8)',
                  "(${controller.statusData.value.approvedStatusCount})",
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded publishedStatusWidget() {
    return Expanded(
      child: Card(
        elevation: 20,
        child: GestureDetector(
          onTap: () {
            moveToNextScreen(
                GetStorage().read(Constant.selectedLanguage) == Language.english
                    ? controller.statusData.value.publishedStatusName.toString()
                    : controller.statusData.value.publishedStatusHindiName
                        .toString(),
                controller.statusData.value.publishedStatusId ?? 0);
          },
          child: Container(
            height: 100,
            // color: dashboardPageController
            //             .isDarkTheme.value ==
            //         true
            //     ? AppColors.white
            //     : AppColors.colorPrimary,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1.0,
                // assign the color to the border color
                color: AppColors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'published'.tr,
                  GetStorage().read(Constant.selectedLanguage) ==
                          Language.english
                      ? controller.statusData.value.publishedStatusName
                          .toString()
                      : controller.statusData.value.publishedStatusHindiName
                          .toString(),
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
                Text(
                  // '(7)',
                  "(${controller.statusData.value.publishedStatusCount})",
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding allStatusWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 1),
      child: Card(
        elevation: 20,
        child: GestureDetector(
          onTap: () {
            moveToNextScreen(
                GetStorage().read(Constant.selectedLanguage) == Language.english
                    ? "All"
                    : "all".tr,
                controller.statusData.value.allStatusId ?? 0);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1.0,
                color: AppColors.white,
              ),
            ),
            width: double.infinity,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'all'.tr,
                  GetStorage().read(Constant.selectedLanguage) ==
                          Language.english
                      ? controller.statusData.value.allStatusName.toString()
                      : controller.statusData.value.allStatusHindiName
                          .toString(),
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
                Text(
                  // '(22)',
                  "(${controller.statusData.value.allStatusCount})",
                  style: TextStyle(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.black
                          : AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.dashboardStatusFontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding calenderWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Card(
        elevation: 20,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              width: 1.0,
              // assign the color to the border color
              color: AppColors.white,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Card(
                          elevation: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                // assign the color to the border color
                                color: AppColors.white,
                              ),
                            ),
                            height: 100,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Image.asset(
                                    'assets/images/calender_icon.png',
                                    height: 35,
                                    width: 35,
                                    color: dashboardPageController
                                                .isDarkTheme.value ==
                                            true
                                        ? AppColors.black
                                        : AppColors.calenderColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'from_date'.tr,
                                        style: TextStyle(
                                            color: dashboardPageController
                                                        .isDarkTheme.value ==
                                                    true
                                                ? AppColors.black
                                                : AppColors.colorPrimary,
                                            fontSize: SizeConfig
                                                .dashboardDateFontSize),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          controller.displayStartDate.value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: dashboardPageController
                                                          .isDarkTheme.value ==
                                                      true
                                                  ? AppColors.black
                                                  : AppColors.black,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Card(
                          elevation: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                // assign the color to the border color
                                color: AppColors.white,
                              ),
                            ),
                            height: 100,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Image.asset(
                                    'assets/images/calender_icon.png',
                                    height: 35,
                                    width: 35,
                                    color: dashboardPageController
                                                .isDarkTheme.value ==
                                            true
                                        ? AppColors.black
                                        : AppColors.calenderColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'to_date'.tr,
                                        style: TextStyle(
                                            color: dashboardPageController
                                                        .isDarkTheme.value ==
                                                    true
                                                ? AppColors.black
                                                : AppColors.colorPrimary,
                                            fontSize: SizeConfig
                                                .dashboardDateFontSize),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          controller.displayEndDate.value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: dashboardPageController
                                                          .isDarkTheme.value ==
                                                      true
                                                  ? AppColors.black
                                                  : AppColors.black,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: GestureDetector(
                        onTap: () {
                          _showMyDialog();
                        },
                        child: Image.asset(
                          'assets/images/filter_icon.png',
                          height: 30,
                          width: 30,
                          color:
                              dashboardPageController.isDarkTheme.value == true
                                  ? AppColors.black
                                  : AppColors.greenColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            DateTime prevSixDaysDate = controller.today
                                .subtract(const Duration(days: 6));
                            controller.displayStartDate.value = controller
                                .displayDateformatter
                                .format(prevSixDaysDate);
                            controller.apiStartDate.value = controller
                                .apiDateFormatter
                                .format(prevSixDaysDate);
                            controller.displayEndDate.value = controller
                                .displayDateformatter
                                .format(controller.today);
                            controller.apiEndDate.value = controller
                                .apiDateFormatter
                                .format(controller.today);
                          });
                          GetStorage().write(Constant.displayStartDate,
                              controller.displayStartDate.value);
                          GetStorage().write(Constant.apiStartDate,
                              controller.apiStartDate.value);
                          GetStorage().write(Constant.displayEndDate,
                              controller.displayEndDate.value);
                          GetStorage().write(
                              Constant.apiEndDate, controller.apiEndDate.value);

                          Utils(Get.context!).startLoading();
                          await controller.executeStatusApi(
                              controller.apiStartDate.value,
                              controller.apiEndDate.value);
                          Utils(Get.context!).stopLoading();
                        },
                        child: Text(
                          'clear_filter'.tr,
                          style: TextStyle(
                              color:
                                  dashboardPageController.isDarkTheme.value ==
                                          true
                                      ? AppColors.black
                                      : AppColors.colorPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDateRangePicker() {
    return Card(
      child: SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.range,
        //onSelectionChanged: selectionChanged,
        startRangeSelectionColor: AppColors.colorPrimary,
        endRangeSelectionColor: AppColors.colorPrimary,
        todayHighlightColor: AppColors.colorPrimary,
        cancelText: 'cancel'.tr,
        confirmText: 'ok'.tr,
        showActionButtons: true,
        // maxDate: DateTime.now(),
        //minDate: DateTime.now().subtract(const Duration(days: 6)),
        rangeSelectionColor: AppColors.colorPrimary.withOpacity(.2),
        onSubmit: (pickerDateRange) async {
          Navigator.of(context).pop();
          if (pickerDateRange is PickerDateRange) {
            final DateTime? startDate = pickerDateRange.startDate;
            final DateTime? endDate = pickerDateRange.endDate;
            if (startDate != null) {
              controller.apiStartDate.value =
                  controller.apiDateFormatter.format(startDate);
              controller.displayStartDate.value =
                  controller.displayDateformatter.format(startDate).toString();
            }
            if (endDate != null) {
              controller.apiEndDate.value =
                  controller.apiDateFormatter.format(endDate);
              controller.displayEndDate.value =
                  controller.displayDateformatter.format(endDate).toString();
            } else if (startDate != null) {
              controller.apiEndDate.value =
                  controller.apiDateFormatter.format(startDate);
              controller.displayEndDate.value =
                  controller.displayDateformatter.format(startDate).toString();
            }
          }

          GetStorage().write(
              Constant.displayStartDate, controller.displayStartDate.value);
          GetStorage()
              .write(Constant.apiStartDate, controller.apiStartDate.value);
          GetStorage()
              .write(Constant.displayEndDate, controller.displayEndDate.value);
          GetStorage().write(Constant.apiEndDate, controller.apiEndDate.value);

          Utils(Get.context!).startLoading();
          await controller.executeStatusApi(
              controller.apiStartDate.value, controller.apiEndDate.value);
          Utils(Get.context!).stopLoading();
          // Future.delayed(const Duration(milliseconds: 3000), () async {
          //   await controller.executeStatusApi(apiStartDate, apiEndDate);
          //   Utils(Get.context!).stopLoading();
          // });

          // SchedulerBinding.instance.addPostFrameCallback((duration) async {
          // setState(() {});
          //Utils(Get.context!).startLoading();
          // controller.onInit();
          //Utils(Get.context!).stopLoading();
          //  });

          // else if (pickerDateRange is DateTime) {
          //   final DateTime selectedDate = pickerDateRange;
          // } else if (pickerDateRange is List<DateTime>) {
          //   final List<DateTime> selectedDates = pickerDateRange;
          // } else if (pickerDateRange is List<PickerDateRange>) {
          //   final List<PickerDateRange> selectedRanges = pickerDateRange;
          // }
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _showMyDialog() async {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Date',
            style: TextStyle(
                color: dashboardPageController.isDarkTheme.value == true
                    ? AppColors.white
                    : AppColors.colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          content: SingleChildScrollView(
              child: SizedBox(
            height: 350,
            width: width,
            child: getDateRangePicker(),
          ) //SfCalendar()
              ),
          // actions: <Widget>[
          //   TextButton(
          //     child: const Text('Ok'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  void moveToNextScreen(String? status, int statusId) {
    Get.toNamed(Routes.locationPage,
            arguments: FilterModel(
                displayStartDate: controller.displayStartDate.value,
                displayEndDate: controller.displayEndDate.value,
                apiStartDate: controller.apiStartDate.value,
                apiEndDate: controller.apiEndDate.value,
                status: status,
                statusId: statusId,
                categoryId: controller.categoryDropdownSelectedID.value))
        ?.then(
      (value) => {controller.onInit()},
    );
  }

  // void selectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   if (args.value.startDate != null) {
  //     displayStartDate =
  //         displayDateformatter.format(args.value.startDate).toString();
  //   }
  //   if (args.value.endDate != null) {
  //     displayEndDate = displayDateformatter
  //         .format(args.value.endDate ?? args.value.endDate)
  //         .toString();
  //   } else {
  //     displayEndDate = displayDateformatter
  //         .format(args.value.startDate ?? args.value.startDate)
  //         .toString();
  //   }

  //   SchedulerBinding.instance.addPostFrameCallback((duration) {
  //     setState(() {});
  //     controller.onInit();
  //   });
  // }
}

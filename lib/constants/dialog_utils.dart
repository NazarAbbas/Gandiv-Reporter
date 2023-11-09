import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gandiv/constants/values/app_colors.dart';
import 'package:get/get.dart';

import '../ui/controllers/dashboard_page_cotroller.dart';

class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();
  static DashboardPageController dashboardPageController =
      Get.find<DashboardPageController>();
  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showThreeButtonCustomDialog(
      {required BuildContext context,
      required String title,
      required String message,
      required String firstButtonText,
      required String secondButtonText,
      required String thirdButtonText,
      required Function firstBtnFunction,
      required Function secondBtnFunction,
      required Function thirdBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            //title: Text(title),
            content: Container(
              color: dashboardPageController.isDarkTheme.value == true
                  ? AppColors.dartTheme
                  : AppColors.white,
              height: 250,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              dashboardPageController.isDarkTheme.value == true
                                  ? AppColors.white
                                  : AppColors.colorPrimary,
                          foregroundColor:
                              dashboardPageController.isDarkTheme.value == true
                                  ? AppColors.black
                                  : AppColors.white,
                        ),
                        onPressed: () {
                          firstBtnFunction.call();
                        },
                        child: Text(firstButtonText),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            dashboardPageController.isDarkTheme.value == true
                                ? AppColors.white
                                : AppColors.colorPrimary,
                        foregroundColor:
                            dashboardPageController.isDarkTheme.value == true
                                ? AppColors.black
                                : AppColors.white,
                      ),
                      onPressed: () {
                        secondBtnFunction.call();
                      },
                      child: Text(secondButtonText),
                    ),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              dashboardPageController.isDarkTheme.value == true
                                  ? AppColors.white
                                  : AppColors.colorPrimary,
                          foregroundColor:
                              dashboardPageController.isDarkTheme.value == true
                                  ? AppColors.black
                                  : AppColors.white,
                        ),
                        onPressed: () {
                          thirdBtnFunction.call();
                        },
                        child: Text(thirdButtonText),
                      )),
                ],
              ),
            ),

            // actions: <Widget>[
            //   ElevatedButton(
            //     child: Text(okBtnText),
            //     onPressed: () {
            //       okBtnFunction.call();
            //     },
            //   ),
            //   ElevatedButton(
            //       child: Text(cancelBtnText),
            //       onPressed: () => Navigator.pop(context)),
            //   ElevatedButton(
            //       child: Text(cancelBtnText),
            //       onPressed: () => Navigator.pop(context))
            // ],
          );
        });
  }

  static void showTwoButtonCustomDialog(
      {required BuildContext context,
      required String title,
      required String message,
      required String firstButtonText,
      required String secondButtonText,
      required Function firstBtnFunction,
      required Function secondBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              color: dashboardPageController.isDarkTheme.value == true
                  ? AppColors.dartTheme
                  : AppColors.white,
              height: 200,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            dashboardPageController.isDarkTheme.value == true
                                ? AppColors.white
                                : AppColors.colorPrimary,
                        foregroundColor:
                            dashboardPageController.isDarkTheme.value == true
                                ? AppColors.black
                                : AppColors.white,
                      ),
                      onPressed: () {
                        firstBtnFunction.call();
                      },
                      child: Text(firstButtonText),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            dashboardPageController.isDarkTheme.value == true
                                ? AppColors.white
                                : AppColors.colorPrimary,
                        foregroundColor:
                            dashboardPageController.isDarkTheme.value == true
                                ? AppColors.black
                                : AppColors.white,
                      ),
                      onPressed: () {
                        secondBtnFunction.call();
                      },
                      child: Text(secondButtonText),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // static void showSingleButtonCustomDialog(
  //     {required BuildContext context,
  //     required String? title,
  //     required String? message,
  //     required String firstButtonText,
  //     required Function firstBtnFunction}) {
  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return AlertDialog(
  //           title: Text(
  //             title ?? "",
  //             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           content: Container(
  //             color: dashboardPageController.isDarkTheme.value == true
  //                 ? AppColors.dartTheme
  //                 : AppColors.white,
  //             height: 150,
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: 100,
  //                   child: Text(
  //                     message ?? "",
  //                     style: const TextStyle(fontSize: 16),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: double.infinity,
  //                   child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor:
  //                           dashboardPageController.isDarkTheme.value == true
  //                               ? AppColors.white
  //                               : AppColors.colorPrimary,
  //                       foregroundColor:
  //                           dashboardPageController.isDarkTheme.value == true
  //                               ? AppColors.black
  //                               : AppColors.white,
  //                     ),
  //                     onPressed: () {
  //                       firstBtnFunction.call();
  //                     },
  //                     child: Text(firstButtonText),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  static void noInternetConnection(
      {required BuildContext context, required Function callBackFunction}) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'no_internet_title'.tr,
      desc: 'no_internet_message'.tr,
      btnOkText: 'ok'.tr,
      btnOkColor: AppColors.colorPrimary,
      btnOkOnPress: () {
        callBackFunction.call();
      },
    ).show();
  }

  static void successAlert(
      {required BuildContext context,
      required String title,
      required String message,
      required String? btnText,
      required Function callBackFunction}) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      btnOkText: btnText ?? 'ok'.tr,
      btnOkColor: AppColors.colorPrimary,
      btnOkOnPress: () {
        callBackFunction.call();
      },
    ).show();
  }

  static void alertWithoutDialogType(
      {required BuildContext context,
      required String title,
      required String message,
      required String? btnText,
      required Function callBackFunction}) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      desc: message,
      btnOkText: btnText ?? 'ok'.tr,
      btnOkColor: AppColors.colorPrimary,
      btnOkOnPress: () {
        callBackFunction.call();
      },
    ).show();
  }

  static void errorAlert(
      {required BuildContext context,
      required String title,
      required String message,
      required String? btnText,
      required Function callBackFunction}) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title.tr,
      desc: message.tr,
      btnOkText: btnText ?? 'ok'.tr,
      btnOkColor: AppColors.colorPrimary,
      btnOkOnPress: () {
        callBackFunction.call();
      },
    ).show();
  }
}

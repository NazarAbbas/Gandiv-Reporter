import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gandiv/ui/controllers/news_details_page_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../../../constants/constant.dart';
import '../../../constants/dialog_utils.dart';
import '../../../constants/emuns.dart';
import '../../../constants/values/app_colors.dart';
import '../../../constants/values/app_images.dart';
import '../../../route_management/routes.dart';
import '../../controllers/dashboard_page_cotroller.dart';

// ignore: must_be_immutable

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key});

  @override
  NewsDetailPageColumn createState() => NewsDetailPageColumn();
}

class NewsDetailPageColumn extends State<NewsDetailPage> {
  DashboardPageController dashboardPageController =
      Get.find<DashboardPageController>();

  NewsDetailsPageController controller = Get.find<NewsDetailsPageController>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formGlobalKey,
      child: Obx(
        () => WillPopScope(
          onWillPop: () {
            //trigger leaving and use own data
            Navigator.pop(context, false);
            return Future.value(false);
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: buildAppBar(),
            ),
            body: controller.isLoading.value
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.transparent,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [columnWidget(0, context)],
                  ),
            bottomNavigationBar: Visibility(
              visible: controller.isEditable.value == true ? false : true,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 40),
                child: SizedBox(
                  height: 60, //height of button
                  width: double.infinity, //width of button
                  child: Column(
                    children: [
                      Visibility(
                        visible:
                            controller.isEditable.value == true ? false : true,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller.executeDeleteApi();
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
                                    'delete'.tr,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await controller
                                          .onUpload(ButtonAction.update);
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
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: dashboardPageController
                                                      .isDarkTheme.value ==
                                                  true
                                              ? AppColors.black
                                              : AppColors.white),
                                      'update'.tr,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller
                                        .onUpload(ButtonAction.submit);
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
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(5),
                      //     child: Align(
                      //       alignment: Alignment.center,
                      //       child: ElevatedButton(
                      //         onPressed: () async {
                      //           await controller.onUpload(ButtonAction.update);
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //             primary:
                      //                 dashboardPageController.isDarkTheme.value ==
                      //                         true
                      //                     ? AppColors.white
                      //                     : AppColors.colorPrimary,
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(1))),
                      //         child: Text(
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //               color: dashboardPageController
                      //                           .isDarkTheme.value ==
                      //                       true
                      //                   ? AppColors.black
                      //                   : AppColors.white),
                      //           'update'.tr,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Obx buildAppBar() {
    return Obx(
      () => AppBar(
        backgroundColor: dashboardPageController.isDarkTheme.value == true
            ? AppColors.dartTheme
            : AppColors.colorPrimary,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'news_details'.tr,
            style: TextStyle(
              color: dashboardPageController.isDarkTheme.value == true
                  ? AppColors.white
                  : AppColors.white,
            ),
          ),
        ),
        iconTheme: IconThemeData(
            color: dashboardPageController.isDarkTheme.value == true
                ? AppColors.white
                : AppColors.white),
      ),
    );
  }

  Obx columnWidget(int index, BuildContext context) {
    return Obx(
      () => Expanded(
        child: SingleChildScrollView(
          child: Card(
            color: dashboardPageController.isDarkTheme.value == true
                ? AppColors.dartTheme
                : AppColors.white,
            elevation: 8.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                headingWidget(),
                Visibility(
                  visible: controller.isSubHeadingVisible.value,
                  child: subHeadingWidget(),
                ),
                Visibility(
                  visible: controller.isNewsContentVisible.value,
                  child: contentWidget(),
                ),
                categoriesDropDownWidget(),
                Visibility(visible: false, child: locationDropDownWidget()),
                imagesWidget(context),
                // controller.newsList.value.mediaList != null &&
                //         controller.newsList.value.mediaList!.videoList !=
                //             null &&
                //         controller
                //             .newsList.value.mediaList!.videoList!.isNotEmpty
                //     ? videoWidget()
                //     : emptyWidget(),
                // controller.newsList.value.mediaList != null &&
                //         controller.newsList.value.mediaList!.audioList !=
                //             null &&
                //         controller
                //             .newsList.value.mediaList!.videoList!.isNotEmpty
                //     ? audioWidget()
                //     : emptyWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding contentWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        maxLines: null,
        minLines: 6,
        readOnly: controller.isEditable.value,
        controller: controller.newsContentController.value,
        keyboardType: TextInputType.text,
        validator: (password) {
          return controller.isDescriptionValid();
        },
        enableSuggestions: false,
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
          labelText: 'description'.tr,
          hintText: 'description'.tr,
          hintStyle: TextStyle(
              color: dashboardPageController.isDarkTheme.value == true
                  ? Colors.white
                  : AppColors.colorPrimary),
          labelStyle: TextStyle(
              color: dashboardPageController.isDarkTheme.value == true
                  ? Colors.white
                  : AppColors.colorPrimary),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1,
                color: dashboardPageController.isDarkTheme.value == true
                    ? Colors.white
                    : AppColors.colorPrimary),
          ),
        ),
      ),
    );
  }

  Padding imagesWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: dashboardPageController.isDarkTheme.value == true
                    ? AppColors.dartTheme
                    : AppColors.white,
                boxShadow: [
                  BoxShadow(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.white
                          : AppColors.colorPrimary,
                      spreadRadius: 1),
                ],
              ),
              width: double.infinity,
              height: 300,
              child: corauselWidget(context)),
          GestureDetector(
            onTap: () {
              try {
                DialogUtils.showThreeButtonCustomDialog(
                  context: context,
                  title: 'photo'.tr,
                  message: 'message'.tr,
                  firstButtonText: 'camera'.tr,
                  secondButtonText: 'gallery'.tr,
                  thirdButtonText: 'cancel'.tr,
                  firstBtnFunction: () {
                    Navigator.of(context).pop();
                    controller.openImage(ImageSource.camera);
                  },
                  secondBtnFunction: () {
                    Navigator.of(context).pop();
                    controller.openImage(ImageSource.gallery);
                  },
                  thirdBtnFunction: () {
                    Navigator.of(context).pop();
                  },
                );
              } catch (e) {
                if (kDebugMode) {
                  print("error while picking file.");
                }
              }
            },
            child: Visibility(
              visible: controller.isEditable.value == true ? false : true,
              child: Container(
                decoration: BoxDecoration(
                  color: dashboardPageController.isDarkTheme.value == true
                      ? AppColors.dartTheme
                      : AppColors.white,
                  boxShadow: [
                    BoxShadow(
                        color: dashboardPageController.isDarkTheme.value == true
                            ? AppColors.white
                            : AppColors.colorPrimary,
                        spreadRadius: 1),
                  ],
                ),
                width: double.infinity,
                height: 35,
                child: Center(
                  child: Text(
                    'upload_image'.tr,
                    style: TextStyle(
                        color: dashboardPageController.isDarkTheme.value == true
                            ? AppColors.white
                            : AppColors.colorPrimary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Obx corauselWidget(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CarouselSlider(
          options: CarouselOptions(
              initialPage: 0,
              enableInfiniteScroll: false,
              pauseAutoPlayOnTouch: true,
              autoPlay: false,
              height: MediaQuery.of(context).size.width * (3 / 4),
              enlargeCenterPage: true),
          items: controller.newsList.value.mediaList?.imageList?.map(
            (i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * (3 / 4),
                    child: Column(
                      children: [
                        Image.file(
                          height: MediaQuery.of(context).size.width * (3 / 6),
                          File(i.url!),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Visibility(
                          visible: controller.isEditable.value == true
                              ? false
                              : true,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.newsList.value.mediaList?.imageList
                                  ?.remove(i);
                              setState(() {});
                              //final x = _carousalCurrentIndex;
                            },
                            style: ElevatedButton.styleFrom(
                                primary:
                                    dashboardPageController.isDarkTheme.value ==
                                            true
                                        ? AppColors.white
                                        : AppColors.colorPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1))),
                            child: Text(
                              style: TextStyle(
                                  color: dashboardPageController
                                              .isDarkTheme.value ==
                                          true
                                      ? AppColors.black
                                      : AppColors.white),
                              'delete'.tr,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Padding subHeadingWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        maxLines: null,
        minLines: 4,
        maxLength: 400,
        readOnly: controller.isEditable.value,
        controller: controller.subHeadingController.value,
        onChanged: (text) {
          controller.isSubHeadingValid();
        },
        validator: (firstName) {
          return controller.isSubHeadingValid();
        },
        keyboardType: TextInputType.text,
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
          labelText: 'sub_heading'.tr,
          hintText: 'sub_heading'.tr,
          hintStyle: TextStyle(
              color: dashboardPageController.isDarkTheme.value == true
                  ? Colors.white
                  : AppColors.colorPrimary),
          labelStyle: TextStyle(
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

  Padding headingWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        maxLines: null,
        minLines: 2,
        maxLength: 200,
        readOnly: controller.isEditable.value,
        controller: controller.headingController.value,
        onChanged: (text) {
          controller.isHeadingValid();
        },
        validator: (firstName) {
          return controller.isHeadingValid();
        },
        keyboardType: TextInputType.text,
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
          labelText: 'heading'.tr,
          hintText: 'heading'.tr,
          hintStyle: TextStyle(
              color: dashboardPageController.isDarkTheme.value == true
                  ? Colors.white
                  : AppColors.colorPrimary),
          labelStyle: TextStyle(
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

  SizedBox emptyWidget() {
    return const SizedBox(height: 10);
  }

  AbsorbPointer categoriesDropDownWidget() {
    return AbsorbPointer(
      absorbing: controller.isEditable.value,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Center(
          child: MultiSelectDialogField(
            searchable: true,
            initialValue: controller.selectedCategories,
            items: controller.multiSelectCategoriesList,
            listType: MultiSelectListType.LIST,
            cancelText: Text(
              'cancel'.tr,
              style: TextStyle(
                  color: dashboardPageController.isDarkTheme.value == true
                      ? Colors.white
                      : AppColors.black),
            ),
            confirmText: Text(
              'ok'.tr,
              style: TextStyle(
                  color: dashboardPageController.isDarkTheme.value == true
                      ? Colors.white
                      : AppColors.black),
            ),
            title: Text('category'.tr),
            itemsTextStyle: TextStyle(
                color: dashboardPageController.isDarkTheme.value == true
                    ? Colors.white
                    : AppColors.black),
            selectedItemsTextStyle: TextStyle(
                color: dashboardPageController.isDarkTheme.value == true
                    ? Colors.white
                    : AppColors.black),
            checkColor: dashboardPageController.isDarkTheme.value == true
                ? AppColors.dartTheme
                : AppColors.white,
            backgroundColor: dashboardPageController.isDarkTheme.value == true
                ? AppColors.dartTheme
                : AppColors.white,
            selectedColor: dashboardPageController.isDarkTheme.value == true
                ? AppColors.white.withOpacity(1)
                : AppColors.colorPrimary.withOpacity(1),
            decoration: BoxDecoration(
              color: dashboardPageController.isDarkTheme.value == true
                  ? AppColors.dartTheme
                  : AppColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                color: dashboardPageController.isDarkTheme.value == true
                    ? AppColors.white
                    : AppColors.colorPrimary,
                width: 1,
              ),
            ),
            buttonIcon: Icon(
              Icons.arrow_drop_down,
              color: dashboardPageController.isDarkTheme.value == true
                  ? AppColors.white
                  : AppColors.black,
            ),
            buttonText: Text(
              'category'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dashboardPageController.isDarkTheme.value == true
                    ? AppColors.white
                    : AppColors.black,
                fontSize: 16,
              ),
            ),
            // onConfirm: (results) async {
            //   controller.isEditable.value == true
            //       ? null
            //       : controller.categoriesDropdownSelectedID?.clear();
            //   for (int i = 0; i < results.length; i++) {
            //     final selectedId = await controller.appDatabase.categoriesDao
            //         .findCategoriesIdByName(results[i]);
            //     controller.categoriesDropdownSelectedID
            //         ?.add(selectedId!.id.toString());
            //   }
            // },
            onConfirm: (results) async {
              controller.categoriesDropdownSelectedID.clear();
              for (int i = 0; i < results.length; i++) {
                if (GetStorage().read(Constant.selectedLanguage) ==
                    Language.english) {
                  final category = await controller.appDatabase.categoriesDao
                      .findCategoriesIdByName(results[i]);
                  controller.categoriesDropdownSelectedID
                      .add(category!.id.toString());
                } else {
                  final category = await controller.appDatabase.categoriesDao
                      .findCategoriesIdByhindiName(results[i]);
                  controller.categoriesDropdownSelectedID
                      .add(category!.id.toString());
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Padding locationDropDownWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: GFDropdown(
            hint: Text(
              'please_select_location'.tr,
              style: (TextStyle(color: AppColors.colorPrimary)),
            ),
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
            value: controller.locationDropdownValue.value,
            onChanged: controller.isEditable.value == true
                ? null
                : (newValue) async {
                    controller.locationDropdownValue.value =
                        newValue.toString();
                    final selectedId = await controller.appDatabase.locationsDao
                        .findLocationsIdByName(newValue.toString());
                    controller.locationDropdownSelectedID =
                        selectedId == null ? "" : selectedId.id!;
                  },
            items: controller.locationList
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

  Visibility videoWidget() {
    return Visibility(
      visible: (controller.newsList.value.mediaList == null ||
              controller.newsList.value.mediaList?.videoList?.length == 0)
          ? true
          : true,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.videoPlayerPage, arguments: controller.newsList)
              ?.then(
            (value) => {
              controller.onInit(),
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
          child: Stack(
            children: [
              Image.file(
                controller.files[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90, left: 150),
                child: Image.asset(
                  width: 50,
                  height: 50,
                  AppImages.videoPlayIcon,
                  fit: BoxFit.cover,
                  color: AppColors.colorPrimary,
                ),
              ),
            ],
          ),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.only(top: 5),
        //   child: Image.asset(
        //     AppImages.videoPlayerIcon,
        //   ),
        // ),
      ),
    );
  }

  Visibility audioWidget() {
    return Visibility(
      visible: (controller.newsList.value.mediaList == null ||
              controller.newsList.value.mediaList?.audioList?.length == 0)
          ? true
          : true,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.audioPlayerPage, arguments: controller.newsList)
              ?.then(
            (value) => {
              controller.onInit(),
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
          child: Stack(
            children: [
              Image.asset(
                AppImages.audioPlayer,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 90, left: 150),
              //   child: Image.asset(
              //     width: 50,
              //     height: 50,
              //     AppImages.videoPlayIcon,
              //     fit: BoxFit.cover,
              //     color: AppColors.colorPrimary,
              //   ),
              // ),
            ],
          ),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.only(top: 5),
        //   child: Image.asset(
        //     AppImages.videoPlayerIcon,
        //   ),
        // ),
      ),
    );
  }
}

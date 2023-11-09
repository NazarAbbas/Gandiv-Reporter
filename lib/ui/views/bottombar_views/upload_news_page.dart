import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gandiv/constants/values/app_colors.dart';
import 'package:gandiv/ui/controllers/dashboard_page_cotroller.dart';
import 'package:gandiv/ui/controllers/upload_news_page_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../../../constants/constant.dart';
import '../../../constants/dialog_utils.dart';
import '../../../constants/emuns.dart';

// ignore: must_be_immutable

class UploadNewsPage extends StatefulWidget {
  const UploadNewsPage({super.key});

  @override
  UploadNewsPageStats createState() => UploadNewsPageStats();
}

class UploadNewsPageStats extends State<UploadNewsPage> {
  DashboardPageController dashboardPageController =
      Get.find<DashboardPageController>();
  UploadNewsPagePageController controller =
      Get.find<UploadNewsPagePageController>();

  @override
  void initState() {
    super.initState();

    controller.onInit();
    //controller.locationList.clear();
    //controller.categoriesList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.formGlobalKey,
        child: Obx(
          () => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: dashboardPageController.isDarkTheme.value == true
                  ? AppColors.dartTheme
                  : AppColors.colorPrimary,
              title: Text('upload_news'.tr),
            ),
            body: controller.isLoading.value
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.transparent,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Center(
                    child: Container(
                      color: dashboardPageController.isDarkTheme.value == true
                          ? AppColors.dartTheme
                          : AppColors.white,
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //newsTypeWidget(),
                              headingWidget(),
                              Visibility(
                                visible: controller.isSubHeadingVisible.value,
                                child: subHeadingWidget(),
                              ),
                              Visibility(
                                visible: controller.isNewsContentVisible.value,
                                child: descriptionWidget(),
                              ),
                              categoriesDropDownWidget(),
                              imagesWidget(context),
                              Visibility(
                                visible: false,
                                child: locationDropDownWidget(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            bottomNavigationBar: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 5, bottom: 50),
                    child: SizedBox(
                      height: 50, //height of button
                      width: double.infinity, //width of button
                      child: ElevatedButton(
                        onPressed: () {
                          updateButtonClick(context);
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
                              color:
                                  dashboardPageController.isDarkTheme.value ==
                                          true
                                      ? AppColors.black
                                      : AppColors.white),
                          'draft'.tr,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 5, right: 20, bottom: 50),
                    child: SizedBox(
                      height: 50, //height of button
                      width: double.infinity, //width of button
                      child: ElevatedButton(
                        onPressed: () {
                          submitBttonClick(context);
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
                              color:
                                  dashboardPageController.isDarkTheme.value ==
                                          true
                                      ? AppColors.black
                                      : AppColors.white),
                          'submit'.tr,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
                  title: '',
                  message: 'upload_message'.tr,
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
        ],
      ),
    );
  }

  void submitBttonClick(BuildContext context) async {
    await controller.onUpload(ButtonAction.submit);
  }

  void updateButtonClick(BuildContext context) async {
    await controller.onUpload(ButtonAction.update);
  }

  Padding headingWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        maxLines: null,
        minLines: 2,
        maxLength: 200,
        onChanged: (text) {
          controller.isHeadingValid();
        },
        controller: controller.headingController,
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
          // prefixIcon: Icon(Icons.person,
          //     color: dashboardPageController.isDarkTheme.value == true
          //         ? Colors.white
          //         : AppColors.colorPrimary),
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

  Padding subHeadingWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        maxLines: null,
        minLines: 4,
        maxLength: 400,
        onChanged: (text) {
          controller.isSubHeadingValid();
        },
        controller: controller.subHeadingController,
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
          // prefixIcon: Icon(Icons.person,
          //     color: dashboardPageController.isDarkTheme.value == true
          //         ? Colors.white
          //         : AppColors.colorPrimary),
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

  Padding descriptionWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        maxLines: 6,
        keyboardType: TextInputType.text,
        controller: controller.descriptionController,
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

  // Padding corauselWidget(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: CarouselSlider(
  //       options: CarouselOptions(
  //           initialPage: 0,
  //           enableInfiniteScroll: false,
  //           pauseAutoPlayOnTouch: true,
  //           autoPlay: false,
  //           height: MediaQuery.of(context).size.width * (3 / 4),
  //           enlargeCenterPage: true),
  //       items: controller.imageList.map((i) {
  //         return Builder(
  //           builder: (BuildContext context) {
  //             return Image.file(
  //               File(i),
  //               fit: BoxFit.cover,
  //               width: MediaQuery.of(context).size.width,
  //             );
  //           },
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

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
          items: controller.imageList.map(
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
                          File(i),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.removeImage(i);
                            //controller.imageList.remove(i);
                            //setState(() {});
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
                                color:
                                    dashboardPageController.isDarkTheme.value ==
                                            true
                                        ? AppColors.black
                                        : AppColors.white),
                            'delete'.tr,
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

  // Padding newsTypeWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
  //     child: SizedBox(
  //       width: double.infinity,
  //       child: DropdownButtonHideUnderline(
  //         child: GFDropdown(
  //           // hint: Text(
  //           //   'please_select_location'.tr,
  //           //   style: (TextStyle(color: AppColors.colorPrimary)),
  //           // ),
  //           padding: const EdgeInsets.all(0),
  //           borderRadius: BorderRadius.circular(40),
  //           border: BorderSide(
  //               color: dashboardPageController.isDarkTheme.value == true
  //                   ? AppColors.white
  //                   : AppColors.colorPrimary,
  //               width: 1),
  //           dropdownButtonColor:
  //               dashboardPageController.isDarkTheme.value == true
  //                   ? AppColors.dartTheme
  //                   : AppColors.white,
  //           value: controller.newsTypeListDropdownValue.value,
  //           onChanged: (newValue) async {
  //             final xx = newValue;
  //             final xxxx = "";
  //             // controller.locationDropdownValue.value = newValue!;
  //             // final selectedId = await controller.appDatabase.locationsDao
  //             //     .findLocationsIdByName(newValue);
  //             // controller.locationDropdownSelectedID =
  //             //     selectedId == null ? "" : selectedId.id!;
  //           },
  //           items: controller.newsTypeList
  //               .map((value) => DropdownMenuItem(
  //                     value: value.newsType,
  //                     child: Text(value.newsType!),
  //                   ))
  //               .toList(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
            onChanged: (newValue) async {
              controller.locationDropdownValue.value = newValue!;
              final selectedId = await controller.appDatabase.locationsDao
                  .findLocationsIdByName(newValue);
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

  Padding categoriesDropDownWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Center(
        child: MultiSelectDialogField(
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

            // controller.categoriesDropdownSelectedID = results;
            //final xx = results;
            //final xxxxx = "";
          },
        ),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
    //   child: SizedBox(
    //     width: double.infinity,
    //     child: DropdownButtonHideUnderline(
    //       child: GFDropdown(
    //         hint: Text('please_select_category'.tr),
    //         padding: const EdgeInsets.all(0),
    //         borderRadius: BorderRadius.circular(5),
    //         border: const BorderSide(color: Colors.black12, width: 1),
    //         dropdownButtonColor: Colors.white,
    //         value: controller.categoriesDropdownValue.value,
    //         onChanged: (newValue) async {
    //           controller.categoriesDropdownValue.value = newValue!;
    //           final selectedId = await controller.appDatabase.categoriesDao
    //               .findCategoriesIdByName(newValue);

    //           controller.categoriesDropdownSelectedID =
    //               selectedId == null ? "" : selectedId.id;
    //         },
    //         items: controller.categoriesList
    //             .map((value) => DropdownMenuItem(
    //                   value: value,
    //                   child: Text(value),
    //                 ))
    //             .toList(),
    //       ),
    //     ),
    //   ),
    // );
  }
}

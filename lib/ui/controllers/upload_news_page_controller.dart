import 'dart:io';

import 'package:dio/dio.dart' as dioError;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gandiv/constants/dialog_utils.dart';
import 'package:gandiv/constants/utils.dart';
import 'package:gandiv/models/create_news_request.dart';
import 'package:gandiv/models/news_type.dart';
import 'package:gandiv/ui/views/dashboard_view/dashboard_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../constants/constant.dart';
import '../../constants/emuns.dart';
import '../../constants/values/app_colors.dart';
import '../../database/app_database.dart';
import '../../network/rest_api.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import '../views/bottombar_views/dashboard_status_page.dart';
import 'dashboard_page_cotroller.dart';

class UploadNewsPagePageController extends GetxController {
  final RestAPI restAPI = Get.find<RestAPI>();
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;

  final headingController = TextEditingController();
  final subHeadingController = TextEditingController();
  final descriptionController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();
  final singleUserRoleValue = "Reporter".obs;

  ImagePicker imgpicker = ImagePicker();
  final imageList = <String>[].obs;
  List<MultiSelectItem<String>> multiSelectCategoriesList =
      <MultiSelectItem<String>>[].obs;
  final localImagePath = "".obs;
  final networkImagePath = "".obs;
  final headingCroppedImagepath = "".obs;
  final subHeadingCroppedImagepath = "".obs;
  final contentCroppedImagepath = "".obs;
  late File imagefile;
  final AppDatabase appDatabase = Get.find<AppDatabase>();

  List<String> locationList = <String>[].obs;

  //List<NewsType> newsTypeList = <NewsType>[].obs;

  var locationDropdownValue = "".obs;

  //var newsTypeListDropdownValue = "".obs;

  List<String> categoriesList = <String>[];
  String locationDropdownSelectedID = "5dded3bc-654d-464e-3fcf-08db7a5882e0";
  List<String> categoriesDropdownSelectedID = <String>[];
  final newsType = NewsType().obs;

  var isHeadingVisible = true.obs;
  var isSubHeadingVisible = true.obs;
  var isNewsContentVisible = true.obs;

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      newsType.value = Get.arguments;
      if (newsType.value.newsTypeId == NewsTypeEnum.breakingNewsId) {
        isHeadingVisible.value = true;
        isSubHeadingVisible.value = false;
        isNewsContentVisible.value = false;
      } else if (newsType.value.newsTypeId == NewsTypeEnum.editorialId) {
        isHeadingVisible.value = true;
        isSubHeadingVisible.value = false;
        isNewsContentVisible.value = true;
      } else {
        isHeadingVisible.value = true;
        isSubHeadingVisible.value = true;
        isNewsContentVisible.value = true;
      }
    }

    ///newsTypeList.clear();
    // newsTypeList
    //     .add(NewsType(newsType: 'please_select_location'.tr, newsTypeId: 0));
    // newsTypeListDropdownValue.value = 'News'.tr;
    // newsTypeList.add(NewsType(newsType: "News", newsTypeId: 1));
    // newsTypeList.add(NewsType(newsType: "Editorial", newsTypeId: 2));
    // newsTypeList.add(NewsType(newsType: "Breaking News", newsTypeId: 3));

    if (isLoading.value == false) {
      isLoading.value = true;
      headingController.text = "";
      subHeadingController.text = "";
      descriptionController.text = "";
      imageList.clear();
      // locationDropdownSelectedID = "";
      locationDropdownValue.value = "";
      categoriesDropdownSelectedID.clear();
      locationList.clear();
      categoriesList.clear();
      locationList.add('please_select_location'.tr);
      locationDropdownValue.value = 'please_select_location'.tr;

      final locations = await appDatabase.locationsDao.findLocations();
      for (var location in locations) {
        locationList.add(location.name!);
      }
      final categories = await appDatabase.categoriesDao.findCategories();

      for (var categorie in categories) {
        if (GetStorage().read(Constant.selectedLanguage) == Language.english) {
          categoriesList.add(categorie.name);
        } else {
          categoriesList.add(categorie.hindiName!);
        }
      }
      // for (var categorie in categories) {
      //   categoriesList.add(categorie.name);
      // }
      multiSelectCategoriesList = categoriesList
          .map((category) => MultiSelectItem<String>(category, category))
          .toList();
      isLoading.value = false;
    }
  }

  void setPasswordVisible(bool isTrue) {
    isPasswordVisible.value = isTrue;
  }

  void setUserRole(String userRol) {
    singleUserRoleValue.value = userRol;
  }

  @override
  void onClose() {}

  String? isDescriptionValid() {
    if (isNewsContentVisible.value) {
      if (descriptionController.text.trim().isEmpty) {
        return 'please_select_description'.tr;
      }
    }
    return null;
  }

  String? isHeadingValid() {
    if (isHeadingVisible.value) {
      if (headingController.text.trim().isEmpty) {
        return 'please_select_heading'.tr;
      }
    }
    return null;
  }

  String? isSubHeadingValid() {
    // if (isSubHeadingVisible.value) {
    //   if (subHeadingController.text.trim().isEmpty) {
    //     return 'please_select_subheading'.tr;
    //   }
    // }
    return null;
  }

  Future<void> onUpload(ButtonAction buttonAction) async {
    await validateFields(buttonAction);
  }

  Future<void> validateFields(ButtonAction buttonAction) async {
    if (formGlobalKey.currentState!.validate()) {
      formGlobalKey.currentState?.save();
      if (categoriesDropdownSelectedID.isEmpty) {
        Fluttertoast.showToast(
            msg: 'please_select_category'.tr,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else if (locationDropdownSelectedID.isEmpty) {
        Fluttertoast.showToast(
            msg: 'please_select_location'.tr,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else {
        await executeCreateNewsApi(buttonAction);
      }
    }
  }

  Future<void> executeCreateNewsApi(ButtonAction buttonAction) async {
    Utils(Get.context!).startLoading();
    try {
      if (await Utils.checkUserConnection()) {
        final List<File> files = <File>[];

        try {
          for (int i = 0; i < imageList.length; i++) {
            files.add(File(imageList[i]));
          }
        } on Exception catch (exception) {
          final message = exception;
        }

        CreateNewsRequest createNewsRequest = CreateNewsRequest();
        createNewsRequest.newsTypeId = newsType.value.newsTypeId;
        createNewsRequest.heading = headingController.text;
        createNewsRequest.subHeading = subHeadingController.text;
        createNewsRequest.newsContent = descriptionController.text;
        createNewsRequest.durationInMin = 0.toString();
        createNewsRequest.locationId = locationDropdownSelectedID;
        createNewsRequest.categoryIdsList = categoriesDropdownSelectedID;
        createNewsRequest.languageId =
            GetStorage().read(Constant.selectedLanguage).toString();
        if (buttonAction == ButtonAction.submit) {
          createNewsRequest.status = Status.created;
        } else if (buttonAction == ButtonAction.update) {
          createNewsRequest.status = Status.drafted;
        }
        createNewsRequest.files = files;

        final response = await restAPI.callCreateNewsApi(createNewsRequest);
        Utils(Get.context!).stopLoading();
        if (response.status == 200 || response.status == 201) {
          DialogUtils.successAlert(
            context: Get.context!,
            title: 'success'.tr,
            message: 'news_created_successfully'.tr,
            btnText: 'ok'.tr,
            callBackFunction: () {
              Navigator.of(Get.context!).pop();
              DashboardPageController dashboardPageController =
                  Get.find<DashboardPageController>();
              dashboardPageController.setTabbarIndex(0);
              dashboardPageController.pageController.value.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
              DashboardStatusStatePage dashboardStatusPage =
                  DashboardStatusStatePage();
              dashboardStatusPage.refreshPage();
            },
          );
        } else {
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            message: response.message,
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
            Navigator.of(Get.context!).pop();
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
            Navigator.of(Get.context!).pop();
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
            Navigator.of(Get.context!).pop();
          },
        );
      } on Exception catch (exception) {
        if (kDebugMode) {
          exception.toString();
        }
      }
    } finally {}
  }

  void openImage(ImageSource imageSource) async {
    try {
      var pickedFile = await imgpicker.pickImage(source: imageSource);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        localImagePath.value = pickedFile.path;
        imagefile = File(localImagePath.value);
        cropImage();
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  void openCamera() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        localImagePath.value = pickedFile.path;
        imagefile = File(localImagePath.value);
        cropImage();
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  void cropImage() async {
    File? croppedfile = (await ImageCropper().cropImage(
        sourcePath: localImagePath.value,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: AppColors.colorPrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        )));

    if (croppedfile != null) {
      imagefile = croppedfile;
      // headingCroppedImagepath.value = croppedfile.path;
      imageList.add(croppedfile.path);
    } else {
      print("Image is not cropped.");
    }
  }

  void removeImage(String fileName) {
    imageList.remove(fileName);
    imageList.refresh();
  }
}

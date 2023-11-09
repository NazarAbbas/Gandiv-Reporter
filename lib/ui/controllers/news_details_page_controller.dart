import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gandiv/models/update_news_request.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../constants/constant.dart';
import '../../constants/dialog_utils.dart';
import '../../constants/emuns.dart';
import '../../constants/utils.dart';
import '../../constants/values/app_colors.dart';
import '../../database/app_database.dart';
import '../../models/news_gallery_response.dart';
import '../../network/rest_api.dart';

class NewsDetailsPageController extends FullLifeCycleController {
  var newsList = NewsGalleryList().obs;
  final AppDatabase appDatabase = Get.find<AppDatabase>();
  final isLoading = false.obs;
  List<File> files = <File>[].obs;
  var headingController = TextEditingController().obs;
  var subHeadingController = TextEditingController().obs;
  var newsContentController = TextEditingController().obs;
  var isEditable = true.obs;
  var isStatusSubmitted = true.obs;
  var imageFileList = <ImageList>[];
  ImagePicker imgpicker = ImagePicker();
  late File imagefile;
  final localImagePath = "".obs;
  //List<String> imageList = <String>[].obs;
  List<String> locationList = <String>['please_select_location'.tr].obs;
  var locationDropdownValue = 'please_select_location'.tr.obs;
  List<MultiSelectItem<String>> multiSelectCategoriesList =
      <MultiSelectItem<String>>[].obs;
  List<String> categoriesList = <String>[];
  //String locationDropdownSelectedID = "";
  String locationDropdownSelectedID = "5dded3bc-654d-464e-3fcf-08db7a5882e0";
  List<String> categoriesDropdownSelectedID = <String>[];

  List<String> selectedCategories = <String>[];
  final RestAPI restAPI = Get.find<RestAPI>();
  final formGlobalKey = GlobalKey<FormState>();
  List<ImageList> oldImages = <ImageList>[];

  var isHeadingVisible = true.obs;
  var isSubHeadingVisible = true.obs;
  var isNewsContentVisible = true.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    if (Get.arguments != null) {
      categoriesDropdownSelectedID.clear();
      locationList.clear();
      categoriesList.clear();
      newsList.value = Get.arguments; //[...Get.arguments];
      headingController.value.text = newsList.value.heading ?? "";
      subHeadingController.value.text = newsList.value.subHeading ?? "";
      newsContentController.value.text = newsList.value.newsContent ?? "";
      if (newsList.value.status == Status.drafted) {
        isEditable.value = false;
      } else if (newsList.value.status == Status.created) {
        isEditable.value = true;
        isStatusSubmitted.value = true;
      } else if (newsList.value.status == Status.published) {
        isEditable.value = true;
      } else {
        isEditable.value = true;
      }
      if (newsList.value.newsTypeId == NewsTypeEnum.breakingNewsId) {
        isHeadingVisible.value = true;
        isSubHeadingVisible.value = false;
        isNewsContentVisible.value = false;
      } else if (newsList.value.newsTypeId == NewsTypeEnum.editorialId) {
        isHeadingVisible.value = true;
        isSubHeadingVisible.value = false;
        isNewsContentVisible.value = true;
      } else {
        isHeadingVisible.value = true;
        isSubHeadingVisible.value = true;
        isNewsContentVisible.value = true;
      }

      // final locations = await appDatabase.locationsDao.findLocations();
      // for (var location in locations) {
      //   locationList.add(location.name!);
      //   locationDropdownSelectedID = location.id!;
      // }
      final categories = await appDatabase.categoriesDao.findCategories();
      // for (var categorie in categories) {
      //   categoriesList.add(categorie.name);
      // }
      for (var categorie in categories) {
        if (GetStorage().read(Constant.selectedLanguage) == Language.english) {
          categoriesList.add(categorie.name);
        } else {
          categoriesList.add(categorie.hindiName!);
        }
      }
      multiSelectCategoriesList = categoriesList
          .map((category) => MultiSelectItem<String>(category, category))
          .toList();

      for (int i = 0; i < newsList.value.categories!.length; i++) {
        if (GetStorage().read(Constant.selectedLanguage) == Language.english) {
          // categoriesList.add(categorie.name);
          final selectedId = await appDatabase.categoriesDao
              .findCategoriessNameById(newsList.value.categories![i].id!);
          selectedCategories.add(selectedId?.name ?? "");
        } else {
          //categoriesList.add(categorie.hindiName!);
          final selectedId = await appDatabase.categoriesDao
              .findCategoriessNameById(newsList.value.categories![i].id!);
          selectedCategories.add(selectedId?.hindiName ?? "");
        }

        final selectedId = await appDatabase.categoriesDao
            .findCategoriessNameById(newsList.value.categories![i].id!);
        categoriesDropdownSelectedID.add(selectedId!.id.toString());
      }
      locationDropdownValue.value = newsList.value.location!;

      if (newsList.value.mediaList != null &&
          newsList.value.mediaList!.videoList != null &&
          newsList.value.mediaList!.videoList!.isNotEmpty) {
        try {
          for (int i = 0;
              i < newsList.value.mediaList!.videoList!.length;
              i++) {
            File file = await Utils.genThumbnailFile(
                newsList.value.mediaList!.videoList![i].url!);
            files.add(file);
          }
        } on Exception catch (exception) {}
      }

      if (newsList.value.mediaList != null &&
          newsList.value.mediaList!.imageList != null &&
          newsList.value.mediaList!.imageList!.isNotEmpty) {
        for (int i = 0; i < newsList.value.mediaList!.imageList!.length; i++) {
          oldImages.add(newsList.value.mediaList!.imageList![i]);
          await downloadImage(newsList.value.mediaList!.imageList![i].url!);
          // await downloadImage(
          //     "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U");
        }
      }

      newsList.value.mediaList?.imageList?.clear();
      newsList.value.mediaList?.imageList?.addAll(imageFileList);
    } else {
      isEditable.value = false;
    }
    isLoading.value = false;
    //newsList.value.mediaList?.imageList?.addAll(imageFileList);
  }

  String? isDescriptionValid() {
    if (newsContentController.value.text.trim().isEmpty) {
      return 'please_select_description'.tr;
    }
    return null;
  }

  String? isHeadingValid() {
    if (headingController.value.text.trim().isEmpty) {
      return 'please_select_heading'.tr;
    }
    return null;
  }

  String? isSubHeadingValid() {
    if (subHeadingController.value.text.trim().isEmpty) {
      return 'please_select_subheading'.tr;
    }
    return null;
  }

  Future<void> downloadImage(String url) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        return;
      }
      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
      var images = ImageList(url: path);
      imageFileList.add(images);
    } on PlatformException catch (error) {
      print(error);
      isLoading.value = false;
    }
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
      ),
    ));

    if (croppedfile != null) {
      imagefile = croppedfile;
      var images = ImageList(url: croppedfile.path);
      newsList.value.mediaList?.imageList?.add(images);
      newsList.refresh();
    } else {
      print("Image is not cropped.");
    }
  }

  Future<void> executeDeleteApi() async {
    try {
      if (await Utils.checkUserConnection()) {
        Utils(Get.context!).startLoading();
        final deleteResponse = await restAPI.calllDeleteApi(newsList.value.id!);
        if (deleteResponse.status == 200 || deleteResponse.status == 201) {
          Utils(Get.context!).stopLoading();
          DialogUtils.successAlert(
            context: Get.context!,
            title: 'delete_title'.tr,
            message: 'delete_message'.tr,
            btnText: 'ok'.tr,
            callBackFunction: () {
              Navigator.of(Get.context!).pop();
            },
          );
        } else {
          Utils(Get.context!).stopLoading();
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            btnText: 'ok'.tr,
            message: deleteResponse.message,
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
      } else {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'error'.tr,
          btnText: 'ok'.tr,
          message:
              res != null ? res.statusMessage ?? "" : 'something_went_wrong'.tr,
          callBackFunction: () {
            //Navigator.of(Get.context!).pop();
          },
        );
      }
    } on Exception catch (exception) {
      Utils(Get.context!).stopLoading();
      if (kDebugMode) {
        print("Got error : $exception");
      }
      try {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'error'.tr,
          btnText: 'ok'.tr,
          message: 'something_went_wrong'.tr,
          callBackFunction: () {
            // Navigator.of(Get.context!).pop();
          },
        );
      } on Exception catch (exception) {
        final message = exception.toString();
      }
    } finally {}
  }

  // Future<void> onUpdate() async {
  //   await validateUpdateFields();
  // }

  // Future<void> validateUpdateFields() async {
  //   if (formGlobalKey.currentState!.validate()) {
  //     formGlobalKey.currentState?.save();
  //     if (categoriesDropdownSelectedID!.isEmpty) {
  //       Fluttertoast.showToast(
  //           msg: 'please_select_category'.tr,
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       return;
  //     } else if (locationDropdownSelectedID.isEmpty) {
  //       Fluttertoast.showToast(
  //           msg: 'please_select_location'.tr,
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       return;
  //     } else {
  //       await executeNewsUploadApi();
  //     }
  //   }
  // }

  Future<void> executeUpdateApi(String status) async {
    try {
      if (await Utils.checkUserConnection()) {
        Utils(Get.context!).startLoading();
        final List<File> files = <File>[];
        final List<String> deleteFiles = <String>[];
        try {
          if (newsList.value.mediaList != null &&
              newsList.value.mediaList?.imageList != null &&
              newsList.value.mediaList!.imageList!.isNotEmpty) {
            for (int i = 0;
                i < newsList.value.mediaList!.imageList!.length;
                i++) {
              files
                  .add(File(newsList.value.mediaList?.imageList![i].url ?? ""));
            }
          }
        } on Exception catch (exception) {
          final message = exception;
        }

        try {
          if (oldImages.isNotEmpty) {
            for (int i = 0; i < oldImages.length; i++) {
              final splitted = oldImages[i].url!.split("/");
              final imageId = splitted[splitted.length - 1];
              deleteFiles.add(imageId);
            }
          }
        } on Exception catch (exception) {
          if (kDebugMode) {
            print("Got error : $exception");
          }
        }

        UpdateNewsRequest updateNewsRequest = UpdateNewsRequest();
        updateNewsRequest.newsType = newsList.value.newsType;
        updateNewsRequest.newsTypeId = newsList.value.newsTypeId;
        updateNewsRequest.id = newsList.value.id;
        updateNewsRequest.heading = headingController.value.text;
        updateNewsRequest.subHeading = subHeadingController.value.text;
        updateNewsRequest.newsContent = newsContentController.value.text;
        updateNewsRequest.durationInMin = 0.toString();
        updateNewsRequest.locationId = locationDropdownSelectedID;
        updateNewsRequest.categoryIdsList = categoriesDropdownSelectedID;
        updateNewsRequest.languageId =
            GetStorage().read(Constant.selectedLanguage).toString();
        updateNewsRequest.status = status;
        //Status.drafted;
        updateNewsRequest.files = files;
        updateNewsRequest.deleteFiles = deleteFiles;

        final response = await restAPI.callUpdateNewsApi(updateNewsRequest);
        if (response.status == 200 || response.status == 201) {
          Utils(Get.context!).stopLoading();
          DialogUtils.successAlert(
            context: Get.context!,
            title: 'success'.tr,
            message: 'news_created_successfully'.tr,
            btnText: 'ok'.tr,
            callBackFunction: () {
              Navigator.of(Get.context!).pop();
              // DashboardPageController dashboardPageController =
              //     Get.find<DashboardPageController>();
              // dashboardPageController.setTabbarIndex(0);
              // dashboardPageController.pageController.value.animateToPage(0,
              //     duration: const Duration(milliseconds: 300),
              //     curve: Curves.easeOut);
              // DashboardStatusStatePage dashboardStatusPage =
              //     DashboardStatusStatePage();
              // dashboardStatusPage.refreshPage();
            },
          );
        } else {
          Utils(Get.context!).stopLoading();
          DialogUtils.errorAlert(
            context: Get.context!,
            title: 'error'.tr,
            message: response.message,
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
      } else {
        DialogUtils.errorAlert(
          context: Get.context!,
          title: 'error'.tr,
          message:
              res != null ? res.statusMessage ?? "" : 'something_went_wrong'.tr,
          btnText: 'ok'.tr,
          callBackFunction: () {
            //Navigator.of(Get.context!).pop();
          },
        );
      }
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
        if (kDebugMode) {
          print("Got error : $exception");
        }
      }
    } finally {}
  }

  Future<void> onUpload(ButtonAction buttonAction) async {
    await validateFields(buttonAction);
  }

  Future<void> validateFields(ButtonAction buttonAction) async {
    if (formGlobalKey.currentState!.validate()) {
      formGlobalKey.currentState?.save();
      if (categoriesDropdownSelectedID!.isEmpty) {
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
        if (buttonAction == ButtonAction.submit) {
          await executeNewsUploadApi();
        } else if (buttonAction == ButtonAction.update) {
          await executeUpdateApi(Status.drafted);
        }
      }
    }
  }

  Future<void> executeNewsUploadApi() async {
    await executeUpdateApi(Status.submitted);
    //   Utils(Get.context!).startLoading();
    //   try {
    //     if (await Utils.checkUserConnection()) {
    //       final List<File> files = <File>[];

    //       try {
    //         if (newsList.value.mediaList != null &&
    //             newsList.value.mediaList?.imageList != null &&
    //             newsList.value.mediaList!.imageList!.isNotEmpty) {
    //           for (int i = 0;
    //               i < newsList.value.mediaList!.imageList!.length;
    //               i++) {
    //             files
    //                 .add(File(newsList.value.mediaList?.imageList![i].url ?? ""));
    //           }
    //         }
    //       } on Exception catch (exception) {
    //         final message = exception;
    //       }

    //       CreateNewsRequest createNewsRequest = CreateNewsRequest();
    //       createNewsRequest.heading = headingController.value.text;
    //       createNewsRequest.subHeading = subHeadingController.value.text;
    //       createNewsRequest.newsContent = newsContentController.value.text;
    //       createNewsRequest.durationInMin = 0.toString();
    //       createNewsRequest.locationId = locationDropdownSelectedID;
    //       createNewsRequest.categoryIdsList = categoriesDropdownSelectedID;
    //       createNewsRequest.languageId =
    //           GetStorage().read(Constant.selectedLanguage).toString();

    //       createNewsRequest.status = Status.created;
    //       createNewsRequest.files = files;

    //       final response = await restAPI.callCreateNewsApi(createNewsRequest);
    //       Utils(Get.context!).stopLoading();
    //       if (response.status == 200 || response.status == 201) {
    //         DialogUtils.successAlert(
    //           context: Get.context!,
    //           title: 'success'.tr,
    //           message: 'news_created_successfully'.tr,
    //           btnText: 'ok'.tr,
    //           callBackFunction: () {
    //             Navigator.of(Get.context!).pop();
    //           },
    //         );
    //       } else {
    //         Utils(Get.context!).stopLoading();
    //         DialogUtils.errorAlert(
    //           context: Get.context!,
    //           title: 'error'.tr,
    //           message: response.message,
    //           btnText: 'ok'.tr,
    //           callBackFunction: () {
    //             // Navigator.of(Get.context!).pop();
    //           },
    //         );
    //       }
    //     } else {
    //       Utils(Get.context!).stopLoading();
    //       DialogUtils.noInternetConnection(
    //         context: Get.context!,
    //         callBackFunction: () {},
    //       );
    //     }
    //   } on DioException catch (obj) {
    //     Utils(Get.context!).stopLoading();
    //     final res = (obj).response;
    //     if (res?.statusCode == 401) {
    //       DialogUtils.errorAlert(
    //         context: Get.context!,
    //         title: 'unauthorized_title'.tr,
    //         message: 'unauthorized_message'.tr,
    //         btnText: 'ok'.tr,
    //         callBackFunction: () {
    //           Navigator.of(Get.context!).pop();
    //         },
    //       );
    //     } else {
    //       DialogUtils.errorAlert(
    //         context: Get.context!,
    //         title: 'error'.tr,
    //         message: res != null
    //             ? res.statusMessage ?? 'something_went_wrong'.tr
    //             : 'something_went_wrong'.tr,
    //         btnText: 'ok'.tr,
    //         callBackFunction: () {
    //           Navigator.of(Get.context!).pop();
    //         },
    //       );
    //     }
    //     //return updateProfilleResponse;
    //   } on Exception catch (exception) {
    //     Utils(Get.context!).stopLoading();
    //     if (kDebugMode) {
    //       print("Got error : $exception");
    //     }
    //     try {
    //       DialogUtils.errorAlert(
    //         context: Get.context!,
    //         title: 'error'.tr,
    //         message: 'something_went_wrong'.tr,
    //         btnText: 'ok'.tr,
    //         callBackFunction: () {
    //           Navigator.of(Get.context!).pop();
    //         },
    //       );
    //     } on Exception catch (exception) {
    //       final message = exception.toString();
    //     }
    //   } finally {}
  }
}

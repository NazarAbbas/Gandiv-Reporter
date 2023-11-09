import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gandiv/constants/utils.dart';
import 'package:gandiv/models/filter_model.dart';
import 'package:gandiv/models/news_gallery_response.dart';
import 'package:get/get.dart';
import '../../constants/dialog_utils.dart';
import '../../database/app_database.dart';
import '../../network/rest_api.dart';

class NewsListStatusPageController extends FullLifeCycleController {
  final RestAPI restAPI = Get.find<RestAPI>();
  final AppDatabase appDatabase = Get.find<AppDatabase>();
  ScrollController controller = ScrollController();
  int pageNo = 1;
  int pageSize = 10;
  int totalCount = 0;

  //List<NewsGalleryList> newsList = <NewsGalleryList>[].obs;
  List<NewsGalleryList> newsList = <NewsGalleryList>[].obs;
  var isDataLoading = false.obs;
  var isLoadMoreItems = false.obs;
  var locationId = '';
  var categoryId = '';
  int languageId = 0;
  final filterModel = FilterModel().obs;

  @override
  void onInit() async {
    super.onInit();

    if (!isDataLoading.value) {
      if (Get.arguments != null) {
        filterModel.value = Get.arguments;
      }
      isDataLoading.value = true;
      pageNo = 1;
      pageSize = 10;
      newsList.clear();
      await getHomeNews();
    }
  }

  @override
  void onReady() {
    super.onReady();
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.position.pixels &&
          totalCount > newsList.length) {
        isLoadMoreItems.value = true;
        pageNo = pageNo + 1;
        pageSize = pageSize;
        await getHomeNews();
      }
    });
  }

  Future<void> getHomeNews() async {
    try {
      if (await Utils.checkUserConnection()) {
        final response = await restAPI.callNewsGalleyListApi(
            categoryId: filterModel.value.categoryId ?? "",
            locationId: locationId,
            pageNumber: pageNo,
            pageSize: pageSize,
            startDate: filterModel.value.apiStartDate ?? "",
            endDate: filterModel.value.apiEndDate ?? "",
            statusId: filterModel.value.statusId ?? 0,
            searchText: '');
        totalCount = response.newsGalleryListData?.totalCount ?? 0;
        newsList.addAll(response.newsGalleryListData!.newsGalleryList);
      } else {
        DialogUtils.noInternetConnection(
          context: Get.context!,
          callBackFunction: () {},
        );
      }
    } on DioException catch (obj) {
      final res = (obj).response;
      if (kDebugMode) {
        print("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
      }
      // FOR CUSTOM MESSAGE
      // final errorMessage = NetworkExceptions.getDioException(obj);
    } on Exception catch (exception) {
      if (kDebugMode) {
        print("Got error : $exception");
      }
    } finally {
      isDataLoading.value = false;
      isLoadMoreItems.value = false;
    }
  }
}

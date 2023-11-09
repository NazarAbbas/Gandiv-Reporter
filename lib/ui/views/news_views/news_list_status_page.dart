import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gandiv/constants/values/app_colors.dart';
import 'package:gandiv/ui/controllers/news_list_status_page_controller.dart';
import 'package:get/get.dart';
import '../../../constants/values/size_config.dart';
import '../../../database/app_database.dart';
import '../../../route_management/routes.dart';
import '../../controllers/dashboard_page_cotroller.dart';

class NewsListStatusPage extends StatefulWidget {
  const NewsListStatusPage({super.key});
  @override
  NewsListStatusPageListRow createState() => NewsListStatusPageListRow();
}

class NewsListStatusPageListRow extends State<NewsListStatusPage> {
  DashboardPageController dashboardPageController =
      Get.find<DashboardPageController>();
  NewsListStatusPageController controller =
      Get.find<NewsListStatusPageController>();
  final AppDatabase appDatabase = Get.find<AppDatabase>();

  Future<void> _pullRefresh() async {
    controller.pageNo = 1;
    controller.pageSize = 10;
    controller.newsList.clear();
    controller.onInit();
  }

  @override
  void initState() {
    super.initState();
    controller.pageNo = 1;
    controller.pageSize = 10;
    controller.newsList.clear();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          backgroundColor: dashboardPageController.isDarkTheme.value == true
              ? AppColors.dartTheme
              : AppColors.colorPrimary,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: controller.filterModel.value.status,
                style: const TextStyle(fontSize: 22),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        "\n\n${controller.filterModel.value.displayStartDate}  -  ${controller.filterModel.value.displayEndDate}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ]),
          ),
          // title: Text(
          //     "${controller.filterModel.value.status}${"\n"}${controller.filterModel.value.displayStartDate}   -   ${controller.filterModel.value.displayEndDate}"),
        ),
        body: controller.isDataLoading.value
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.transparent,
                child: const Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                  //   child: Text(
                  //     "${controller.filterModel.value.displayStartDate}   -   ${controller.filterModel.value.displayEndDate}",
                  //     style: TextStyle(
                  //         color:
                  //             dashboardPageController.isDarkTheme.value == true
                  //                 ? AppColors.white
                  //                 : AppColors.colorPrimary,
                  //         fontWeight: FontWeight.normal,
                  //         fontSize: 16),
                  //   ),
                  // ),
                  Expanded(
                    child: controller.newsList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color:
                                  dashboardPageController.isDarkTheme.value ==
                                          true
                                      ? AppColors.dartTheme
                                      : AppColors.white,
                              child: Center(
                                child: Text('no_news_available'.tr,
                                    style: TextStyle(
                                        color: dashboardPageController
                                                    .isDarkTheme.value ==
                                                true
                                            ? AppColors.white
                                            : AppColors.colorPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            color: dashboardPageController.isDarkTheme.value ==
                                    true
                                ? AppColors.white
                                : AppColors.colorPrimary,
                            onRefresh: _pullRefresh,
                            child: ListView.builder(
                              //key: const PageStorageKey(0),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.newsList.length,
                              controller: controller.controller,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => {
                                    Get.toNamed(Routes.newsDetailPage,
                                            arguments:
                                                controller.newsList[index])
                                        ?.then(
                                      (value) => {controller.onInit()},
                                    )
                                  },
                                  child: rowWidget(index, context),
                                );
                              },
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // ignore: unrelated_type_equality_checks
                  if (controller.isLoadMoreItems.value == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Text('loading'.tr,
                                style: TextStyle(
                                    color: dashboardPageController
                                                .isDarkTheme.value ==
                                            true
                                        ? AppColors.white
                                        : AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.loadMoreSize)),
                            CircularProgressIndicator(
                              color:
                                  dashboardPageController.isDarkTheme.value ==
                                          true
                                      ? AppColors.white
                                      : AppColors.black,
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }

  int selectedPosition = 0;
  Obx rowWidget(int index, BuildContext context) {
    return Obx(
      () => Container(
        color: dashboardPageController.isDarkTheme.value == true
            ? AppColors.white
            : AppColors.dartTheme,
        child: Card(
          margin: const EdgeInsets.only(top: .5),
          color: dashboardPageController.isDarkTheme.value == true
              ? AppColors.dartTheme
              : AppColors.white,
          elevation: 20.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Visibility(
                  visible: controller.newsList[index].newsType == null
                      ? false
                      : true,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.newsList[index].newsType == null
                          ? ""
                          : "(${controller.newsList[index].newsType!})",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: dashboardPageController.isDarkTheme.value == true
                            ? AppColors.white
                            : AppColors.black,
                        fontSize: SizeConfig.newsTypeSize,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Visibility(
                  visible:
                      controller.newsList[index].heading == null ? false : true,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.newsList[index].heading == null
                          ? ""
                          : controller.newsList[index].heading!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: dashboardPageController.isDarkTheme.value == true
                            ? controller.newsList[index].newsType ==
                                    "Breaking News"
                                ? Colors.red
                                : AppColors.white
                            : controller.newsList[index].newsType ==
                                    "Breaking News"
                                ? Colors.red
                                : AppColors.black,
                        fontSize: SizeConfig.newsHeadingTitleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.newsList[index].subHeading == null ||
                        controller.newsList[index].subHeading == ""
                    ? false
                    : false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, bottom: 0),
                  child: Visibility(
                    visible: controller.newsList[index].heading == null
                        ? false
                        : true,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        controller.newsList[index].subHeading == null
                            ? ""
                            : controller.newsList[index].subHeading!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              dashboardPageController.isDarkTheme.value == true
                                  ? AppColors.greenColor
                                  : AppColors.greenColor,
                          fontSize: SizeConfig.newsHeadingSubTitleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: Row(
                  children: [
                    Visibility(
                      visible:
                          controller.newsList[index].mediaList?.imageList ==
                                  null
                              ? false
                              : true,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 5, bottom: 5),
                        // child: Expanded(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: controller.newsList[index].newsContent == null
                              ? MediaQuery.of(context).size.width - 40
                              : 50,
                          height: controller.newsList[index].newsContent == null
                              ? MediaQuery.of(context).size.width * (3 / 6)
                              : 65,
                          imageUrl: controller.newsList[index].mediaList
                                  ?.imageList![0].url ??
                              "",
                          //imageUrl: AppImages.tempURL,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        //  ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            controller.newsList[index].mediaList?.imageList ==
                                    null
                                ? const EdgeInsets.only(left: 10, right: 5)
                                : const EdgeInsets.only(left: 0, right: 5),
                        child: Visibility(
                          visible:
                              controller.newsList[index].newsContent == null
                                  ? false
                                  : true,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.newsList[index].newsContent == null
                                  ? ""
                                  : controller.newsList[index].newsContent!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    dashboardPageController.isDarkTheme.value ==
                                            true
                                        ? AppColors.white
                                        : AppColors.black,
                                fontSize: SizeConfig.newsContentSize,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Visibility(
              //     visible: controller.newsList[index].newsContent == null
              //         ? false
              //         : true,
              //     child: Align(
              //       alignment: Alignment.centerLeft,
              //       child: Text(
              //         controller.newsList[index].newsContent == null
              //             ? ""
              //             : controller.newsList[index].newsContent!,
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //         style: TextStyle(
              //           color: dashboardPageController.isDarkTheme.value == true
              //               ? AppColors.white
              //               : AppColors.black,
              //           fontSize: SizeConfig.newsContentSize,
              //           fontWeight: FontWeight.normal,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Visibility(
              //   visible: controller.newsList[index].mediaList?.imageList == null
              //       ? false
              //       : true,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: CarouselSlider(
              //       options: CarouselOptions(
              //           initialPage: 0,
              //           enableInfiniteScroll: false,
              //           pauseAutoPlayOnTouch: false,
              //           autoPlay: false,
              //           height: MediaQuery.of(context).size.width * (3 / 4),
              //           enlargeCenterPage: true),
              //       items:
              //           controller.newsList[index].mediaList?.imageList?.map((i) {
              //         return Builder(
              //           builder: (BuildContext context) {
              //             return CachedNetworkImage(
              //               fit: BoxFit.cover,
              //               width: MediaQuery.of(context).size.width,
              //               imageUrl: i.url!,
              //               //imageUrl: AppImages.tempURL,
              //               placeholder: (context, url) => const Center(
              //                 child: SizedBox(
              //                   width: 40.0,
              //                   height: 40.0,
              //                   child: CircularProgressIndicator(),
              //                 ),
              //               ),
              //               errorWidget: (context, url, error) =>
              //                   const Icon(Icons.error),
              //             );
              //           },
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Row(
              //     children: [
              //       Center(
              //         child: Image.asset(
              //           color: dashboardPageController.isDarkTheme.value == true
              //               ? AppColors.white
              //               : AppColors.black,
              //           AppImages.clock,
              //           height: 20,
              //           width: 20,
              //         ),
              //       ),
              //       Center(
              //         child: Text(
              //           '5 mins read',
              //           maxLines: 2,
              //           overflow: TextOverflow.ellipsis,
              //           style: TextStyle(
              //             color: dashboardPageController.isDarkTheme.value == true
              //                 ? AppColors.white
              //                 : AppColors.black,
              //             fontSize: 10.0,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //       const Spacer(),
              //       GestureDetector(
              //         onTap: () {
              //           final newsContent =
              //               controller.newsList[index].newsContent == null
              //                   ? ""
              //                   : controller.newsList[index].newsContent!;
              //           if (newsContent.isEmpty) {
              //             return;
              //           }
              //           if (controller.newsList[index].isAudioPlaying == true) {
              //             Utils(context).stopAudio(newsContent);
              //             controller.setAudioPlaying(false, index);
              //           } else {
              //             Utils(context).stopAudio(newsContent);
              //             controller.setAudioPlaying(false, selectedPosition);
              //             selectedPosition = index;
              //             Utils(context).startAudio(newsContent);
              //             controller.setAudioPlaying(true, index);
              //           }
              //         },
              //         child: Image.asset(
              //           color: dashboardPageController.isDarkTheme.value == true
              //               ? controller.newsList[index].isAudioPlaying == true
              //                   ? AppColors.colorPrimary
              //                   : AppColors.white
              //               : controller.newsList[index].isAudioPlaying == true
              //                   ? AppColors.colorPrimary
              //                   : AppColors.black,
              //           AppImages.audio,
              //           width: 30,
              //           height: 30,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 10),
              //         child: GestureDetector(
              //           onTap: () async {
              //             if (controller.newsList[index].isBookmark == true) {
              //               controller.removeBookmark(index);
              //             } else {
              //               controller.setBookmark(index);
              //             }
              //           },
              //           child: Image.asset(
              //             color: dashboardPageController.isDarkTheme.value == true
              //                 ? AppColors.white
              //                 : AppColors.colorPrimary,
              //             controller.newsList[index].isBookmark == true
              //                 ? AppImages.highLightBookmark
              //                 : AppImages.bookmark,
              //             width: 25,
              //             height: 25,
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 10),
              //         child: GestureDetector(
              //           onTap: () {
              //             Share.share('check out my website https://example.com');
              //           },
              //           child: Image.asset(
              //             color: dashboardPageController.isDarkTheme.value == true
              //                 ? AppColors.white
              //                 : AppColors.black,
              //             AppImages.share,
              //             width: 25,
              //             height: 25,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

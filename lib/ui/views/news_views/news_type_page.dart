import 'package:flutter/material.dart';
import 'package:gandiv/constants/emuns.dart';
import 'package:gandiv/constants/values/app_colors.dart';
import 'package:gandiv/constants/values/size_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constants/constant.dart';
import '../../../route_management/routes.dart';
import '../../controllers/dashboard_page_cotroller.dart';
import '../../controllers/news_type_page_controller.dart';

class NewsTypePage extends StatefulWidget {
  const NewsTypePage({super.key});
  @override
  NewsTypePageListRow createState() => NewsTypePageListRow();
}

class NewsTypePageListRow extends State<NewsTypePage> {
  DashboardPageController dashboardPageController =
      Get.find<DashboardPageController>();
  NewsTypePageController controller = Get.find<NewsTypePageController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.lightGrayColor,
        body: controller.isDataLoading.value
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.transparent,
                child: const Center(child: CircularProgressIndicator()),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.newsTypeList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () => {
                                      Get.toNamed(Routes.uploadNewsPage,
                                              arguments: controller
                                                  .newsTypeList[index])
                                          ?.then(
                                        (value) => {
                                          //controller.onInit()
                                        },
                                      )
                                    },
                                child: Card(
                                  elevation: 2,
                                  child: ListTile(
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                    title: Text(
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.newsTypeListSize),
                                        (GetStorage().read(Constant
                                                    .selectedLanguage)) ==
                                                Language.english
                                            ? controller
                                                .newsTypeList[index].newsType!
                                            : controller.newsTypeList[index]
                                                .newsTypeHindi!),
                                  ),
                                ));
                          }),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

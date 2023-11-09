import 'package:gandiv/constants/emuns.dart';
import 'package:get/get.dart';
import '../../models/news_type.dart';

class NewsTypePageController extends FullLifeCycleController {
  var isDataLoading = false.obs;

  List<NewsType> newsTypeList = <NewsType>[].obs;
  @override
  void onInit() async {
    super.onInit();
    newsTypeList.clear();
    newsTypeList.add(NewsType(
        newsType: NewsTypeEnum.news,
        newsTypeHindi: NewsTypeEnum.newsHindi,
        newsTypeId: NewsTypeEnum.newsId));
    newsTypeList.add(NewsType(
        newsType: NewsTypeEnum.editorial,
        newsTypeHindi: NewsTypeEnum.editorialHindi,
        newsTypeId: NewsTypeEnum.editorialId));
    newsTypeList.add(NewsType(
        newsType: NewsTypeEnum.breakingNews,
        newsTypeHindi: NewsTypeEnum.breakingNewsHindi,
        newsTypeId: NewsTypeEnum.breakingNewsId));
  }
}

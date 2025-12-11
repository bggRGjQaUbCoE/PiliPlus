import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/article/article_list/article.dart';
import 'package:PiliPlus/models_new/article/article_list/data.dart';
import 'package:PiliPlus/models_new/article/article_list/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';

class ArticleListController
    extends CommonListController<ArticleListData, ArticleListItemModel> {
  final id = Get.parameters['id']!;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  Rx<ArticleListInfo?> list = Rx<ArticleListInfo?>(null);
  Owner? author;

  @override
  List<ArticleListItemModel>? getDataList(ArticleListData response) {
    list.value = response.list;
    author = response.author;
    return response.articles;
  }

  @override
  Future<LoadingState<ArticleListData>> customGetData() =>
      DynamicsHttp.articleList(id: id);
}

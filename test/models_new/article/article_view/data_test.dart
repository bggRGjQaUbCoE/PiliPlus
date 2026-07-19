import 'package:PiliPlus/models_new/article/article_view/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the article title used by the reader summary', () {
    final article = ArticleViewData.fromJson({
      'id': 42904859,
      'title': 'Expected article title',
    });

    expect(article.title, 'Expected article title');
  });
}

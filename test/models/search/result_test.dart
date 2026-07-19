import 'package:PiliPlus/models/search/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all-search keeps bangumi and film result groups renderable', () {
    final result = SearchAllData.fromJson({
      'page': 1,
      'numResults': 2,
      'result': [
        {
          'result_type': 'media_bangumi',
          'data': [
            {'title': 'Bangumi', 'season_id': 1},
          ],
        },
        {
          'result_type': 'media_ft',
          'data': [
            {'title': 'Film', 'season_id': 2},
          ],
        },
      ],
    });

    expect(result.list, hasLength(2));
    expect(result.list![0], isA<List<SearchPgcItemModel>>());
    expect(result.list![1], isA<List<SearchPgcItemModel>>());

    final bangumi = result.list![0] as List<SearchPgcItemModel>;
    final film = result.list![1] as List<SearchPgcItemModel>;
    expect(bangumi.single.seasonId, 1);
    expect(film.single.seasonId, 2);
  });
}

import 'package:PiliPlus/models_new/pgc/pgc_timeline/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_timeline/result.dart';
import 'package:flutter_test/flutter_test.dart';

TimelineResult day(int dateTs, String title) => TimelineResult(
  dateTs: dateTs,
  episodes: [Episode(title: title)],
);

void main() {
  test('timeline days merge by date when the lists have different lengths', () {
    final bangumi = [day(1, 'bangumi-1'), day(2, 'bangumi-2')];
    final guochuang = [day(2, 'guochuang-2')];

    mergeTimelineResults(bangumi, guochuang);

    expect(bangumi, hasLength(2));
    expect(
      bangumi[1].episodes!.map((episode) => episode.title),
      ['bangumi-2', 'guochuang-2'],
    );
  });
}

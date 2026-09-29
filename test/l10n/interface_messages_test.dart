import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/l10n/app_language.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/search/user_search_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/horizontal_video_model.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:flutter_test/flutter_test.dart';

class _Video extends HorizontalVideoModel {}

void main() {
  setUp(() => L10n.initialise(AppLanguage.traditionalChinese, const []));
  tearDown(() => L10n.initialise(AppLanguage.simplifiedChinese, const []));

  for (final locale in ['zh_Hant', 'en']) {
    test('$locale covers the source catalogue and placeholders', () {
      Map<String, dynamic> catalogue(String locale) =>
          jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
              as Map<String, dynamic>;
      final source = catalogue('zh');
      final translated = catalogue(locale);
      final keys = source.keys.where((key) => !key.startsWith('@')).toSet();
      expect(
        translated.keys.where((key) => !key.startsWith('@')).toSet(),
        keys,
      );
      for (final key in keys) {
        final message = translated[key] as String;
        if ((source[key] as String).isNotEmpty) {
          expect(message, isNotEmpty, reason: key);
        }
        final metadata = source['@$key'] as Map<String, dynamic>?;
        final placeholders = metadata?['placeholders'] as Map<String, dynamic>?;
        for (final placeholder in placeholders?.keys ?? <String>[]) {
          expect(
            RegExp('\\{${RegExp.escape(placeholder)}(?:\\}|,)')
                .hasMatch(message),
            isTrue,
            reason: '$key: $placeholder',
          );
        }
      }
    });
  }

  test(
    'English uses the agreed terminology and keeps native language names',
    () {
      L10n.initialise(AppLanguage.english, const []);
      final messages = L10n.current;
      expect(messages.danmaku, 'Danmu');
      expect(messages.userTypeUpLabel, 'Creator');
      expect(messages.dynamics, 'Posts');
      expect(messages.bangumi, 'Animation');
      expect(messages.videoZoneTypeGuochuangLabel, 'Donghua');
      expect(messages.videoZoneTypeKichikuLabel, 'Kichuku');
      expect(messages.premiumMember, 'Premium');
      expect(messages.chargeCreator, 'Power Up');
      expect(messages.badgeChargingExclusive, 'Power-Up');
      expect(messages.favourite, 'Favorite');
      expect(messages.favouriteFolder, 'Collection');
      expect(messages.collection, 'Series');
      expect(messages.followAnime, 'Follow anime');
      expect(messages.followDrama, 'Follow drama');
      expect(messages.languageSimplifiedChinese, '简体中文');
      expect(messages.languageTraditionalChinese, '繁體中文');
      final catalogue = jsonDecode(
        File('lib/l10n/app_en.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      for (final entry in catalogue.entries) {
        if (entry.key.startsWith('@') ||
            entry.key == 'languageSimplifiedChinese' ||
            entry.key == 'languageTraditionalChinese') {
          continue;
        }
        expect(
          RegExp(r'[\u3400-\u9fff]').hasMatch(entry.value as String),
          isFalse,
          reason: entry.key,
        );
      }
    },
  );

  test(
    'English handles plurals, duration spacing and state-dependent labels',
    () {
      L10n.initialise(AppLanguage.english, const []);
      final messages = L10n.current;
      expect(messages.minutesAgo(1), '1 minute ago');
      expect(messages.minutesAgo(2), '2 minutes ago');
      expect(messages.pagesPanelChild(1), '1 episode');
      expect(messages.pagesPanelChild(3), '3 episodes');
      expect(
        DurationUtils.formatTimeDuration(const Duration(hours: 1, minutes: 2)),
        '1 hour 2 minutes',
      );
      expect(
        DurationUtils.formatTimeDuration(const Duration(minutes: 1)),
        '1 minute',
      );
      expect(DurationUtils.formatTimeDuration(Duration.zero), isEmpty);
      expect(messages.followItemChild2('false'), 'Follow');
      expect(messages.followItemChild2('true'), 'Following');
      expect(messages.dynTopicPageBuildAppBarChild('false'), 'Favorite');
      expect(
        messages.dynTopicPageBuildAppBarChild('true'),
        'Remove from favorites',
      );
      expect(
        messages.articleControllerOnFavText('true'),
        'Removed from favorites',
      );
      expect(
        messages.headerControlLikeDanmakuText('true'),
        'Like removed',
      );
      expect(
        messages.commonWhisperControllerOnSetTopText('true'),
        'Unpinned',
      );
      expect(messages.playerFocusHandleKeyText4('true'), 'Unmuted');
      expect(messages.trailingShowReserveListChild('false'), 'Set reminder');
      expect(
        messages.trailingShowReserveListChild('true'),
        'Reminder set',
      );
      expect(messages.fansPageAppBarTitle("O'Brien"), "O'Brien's followers");
      expect(
        messages.confirmedBuildDescContent2('', 'true', 'test-id'),
        'This video is already linked to YouTube video (test-id).',
      );
      expect(
        messages.confirmedBuildDescContent2(
          messages.confirmedBuildDescContent,
          'false',
          'test-id',
        ),
        'Would you like to link this video to YouTube video (test-id)?',
      );
    },
  );

  test(
    'Traditional Chinese interpolates names without changing their text',
    () {
      expect(L10n.current.home, '首頁');
      expect(L10n.current.settings, '設定');
      expect(L10n.current.exitApp('PiliPlus'), contains('PiliPlus'));
      expect(L10n.current.logoutConfirmation('123\n456'), contains('123\n456'));
      expect(FullScreenMode.ratio.desc, contains('1.2'));
      expect(FullScreenMode.ratio.desc, contains('直向'));
    },
  );

  test('translated quality labels retain protocol codes and ordering', () {
    expect(VideoQuality.high1080plus.desc, '1080P 高位元速率');
    expect(VideoQuality.values.map((value) => value.code), [
      129,
      127,
      126,
      125,
      120,
      116,
      112,
      80,
      74,
      64,
      32,
      16,
      6,
    ]);
    expect(VideoQuality.fromCode(112), VideoQuality.high1080plus);
    expect(AudioQuality.fromCode(30251), AudioQuality.hiRes);
    expect(UserOrderType.fansAsc.order, 'fans');
    expect(UserOrderType.fansAsc.orderSort, 1);
    expect(CDNService.ali.host, 'upos-sz-mirrorali.bilivideo.com');
    L10n.initialise(AppLanguage.simplifiedChinese, const []);
    expect(VideoQuality.high1080plus.desc, '1080P 高码率');
  });

  test('badges translate app labels while retaining raw upstream data', () {
    final video = _Video()..badge = '充电专属';
    expect(video.badgeLabel, '充電專屬');
    expect(video.badge, '充电专属');
    video.badge = '课堂';
    expect(video.badgeLabel, '課程');
    video.badge = 'upstream custom badge';
    expect(video.badgeLabel, 'upstream custom badge');
    video.badge = null;
    expect(video.badgeLabel, isNull);
  });

  test(
    'English compact counts use K/M/B',
    () {
      final cases = <dynamic, String>{
        null: '0',
        0: '0',
        999: '999',
        1000: '1K',
        1250: '1.3K',
        10000: '10K',
        12000: '12K',
        30300: '30.3K',
        999949: '999.9K',
        999950: '1M',
        1000000: '1M',
        10000000: '10M',
        200000000: '200M',
        999950000: '1B',
        1000000000: '1B',
        '12000': '12K',
        'upstream text': 'upstream text',
      };
      L10n.initialise(AppLanguage.english, const []);
      for (final entry in cases.entries) {
        expect(
          NumUtils.numFormat(entry.key),
          entry.value,
          reason: '${entry.key}',
        );
      }
    },
  );

  test(
    'Chinese compact counts preserve the original thresholds and rounding',
    () {
      final cases = <dynamic, String>{
        null: '0',
        0: '0',
        999: '999',
        1000: '1000',
        9999: '9999',
        10000: '1万',
        12500: '1.3万',
        30300: '3万',
        999950: '100万',
        1000000: '100万',
        10000000: '1000万',
        99999999: '10000万',
        100000000: '1亿',
        125000000: '1.3亿',
        1000000000: '10亿',
        '12000': '1.2万',
        'upstream text': 'upstream text',
      };
      for (final language in [
        AppLanguage.simplifiedChinese,
        AppLanguage.traditionalChinese,
        AppLanguage.system,
      ]) {
        L10n.initialise(language, const []);
        for (final entry in cases.entries) {
          final expected = language == AppLanguage.traditionalChinese
              ? entry.value.replaceAll('万', '萬').replaceAll('亿', '億')
              : entry.value;
          expect(
            NumUtils.numFormat(entry.key),
            expected,
            reason: '${language.name}: ${entry.key}',
          );
        }
      }
    },
  );

  test('compact counts follow the resolved system language', () {
    for (final entry in {
      AppLanguage.english: '12K',
      AppLanguage.traditionalChinese: '1.2萬',
      AppLanguage.simplifiedChinese: '1.2万',
    }.entries) {
      L10n.initialise(AppLanguage.system, [entry.key.locale!]);
      expect(NumUtils.numFormat(12000), entry.value);
    }
  });

  test(
    'upstream number parsing stays stable',
    () {
      expect(NumUtils.parseNum('1.2万'), 12000);
      expect(NumUtils.parseNum('2亿'), 200000000);
    },
  );

  test('relative dates and durations use Traditional Chinese units', () {
    final time = DateTime.now().subtract(const Duration(minutes: 5));
    expect(
      DateFormatUtils.dateFormat(time.millisecondsSinceEpoch ~/ 1000),
      '5分鐘前',
    );
    expect(
      DurationUtils.formatTimeDuration(const Duration(hours: 2, minutes: 3)),
      '2小時3分鐘',
    );
    expect(DurationUtils.parseDuration('1:02:03'), 3723);
    expect(DurationUtils.formatDuration(3723), '01:02:03');
  });
}

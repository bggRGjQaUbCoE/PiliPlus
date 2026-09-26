import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';

/// Collects the visible text of a dynamic card, like the extension reads the
/// rendered card body: text, video/article titles and attached cards.
abstract final class BreezeContent {
  static final _space = RegExp(r'\s+');

  static String _join(Iterable<String?> parts) => parts
      .where((e) => e != null && e.trim().isNotEmpty)
      .join(' ')
      .replaceAll(_space, ' ')
      .trim();

  static String? _link(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('//')) return 'https:$url';
    return url.startsWith(RegExp('https?:')) ? url : null;
  }

  static List<String?> _texts(DynamicItemModel item) {
    final moduleDynamic = item.modules.moduleDynamic;
    final major = moduleDynamic?.major;
    final add = moduleDynamic?.additional;
    final archive = major?.archive ?? major?.ugcSeason ?? major?.pgc;
    return [
      moduleDynamic?.desc?.text,
      major?.opus?.title,
      major?.opus?.summary?.text,
      archive?.title,
      archive?.desc,
      major?.courses?.title,
      major?.common?.title,
      major?.common?.desc,
      major?.liveRcmd?.title,
      major?.music?.title,
      major?.medialist?.title,
      major?.none?.tips,
      add?.ugc?.title,
      add?.reserve?.title,
      add?.reserve?.desc1?.text,
      add?.reserve?.desc2?.text,
      add?.common?.title,
      add?.common?.desc1,
      add?.common?.desc2,
      add?.vote?.title,
      add?.upowerLottery?.title,
      add?.upowerLottery?.desc?.text,
      add?.match?.matchInfo?.title,
      for (final goods in add?.goods?.items ?? const <GoodItem>[]) ...[
        goods.name,
        goods.price,
      ],
    ];
  }

  static Iterable<String?> _links(DynamicItemModel item) sync* {
    final moduleDynamic = item.modules.moduleDynamic;
    final major = moduleDynamic?.major;
    final add = moduleDynamic?.additional;
    for (final node in [
      ...?moduleDynamic?.desc?.richTextNodes,
      ...?major?.opus?.summary?.richTextNodes,
    ]) {
      yield node.jumpUrl;
    }
    yield (major?.archive ?? major?.ugcSeason ?? major?.pgc)?.jumpUrl;
    yield add?.ugc?.jumpUrl;
    yield add?.common?.jumpUrl;
    yield add?.upowerLottery?.jumpUrl;
    for (final goods in add?.goods?.items ?? const <GoodItem>[]) {
      yield goods.jumpUrl;
    }
  }

  static BreezeRaw? fromDynamic(DynamicItemModel item) {
    final own = _join(_texts(item));
    final orig = item.orig;
    final forwarded = orig == null ? null : _join(_texts(orig));
    final text = _join([own, forwarded]);
    if (text.isEmpty) return null;
    final author = item.modules.moduleAuthor;
    final id = item.idStr?.toString() ?? '';
    return BreezeRaw(
      kind: BreezeKind.dynamic,
      text: text,
      originalText: orig == null ? null : own,
      forwardedText: forwarded,
      links: [
        ..._links(item),
        if (orig != null) ..._links(orig),
      ].map(_link).nonNulls.toSet().take(12).toList(),
      author: author?.name ?? '',
      authorId: author?.mid?.toString() ?? '',
      itemId: id,
      url: id.isEmpty ? '' : 'https://t.bilibili.com/$id',
    );
  }

  /// A video's UP-pinned comment. The author is the video's UP, matching the
  /// extension, so the lists apply by uploader.
  static BreezeRaw? fromPinnedReply(
    ReplyInfo reply, {
    required String upName,
    required String upMid,
    required String title,
    required String url,
  }) {
    final text = reply.content.message.replaceAll(_space, ' ').trim();
    if (text.isEmpty) return null;
    return BreezeRaw(
      kind: BreezeKind.pinned,
      text: text,
      title: title,
      links: [
        for (final e in reply.content.urls.entries)
          _link(e.key) ?? _link(e.value.appUrlSchema),
      ].nonNulls.take(12).toList(),
      author: upName,
      authorId: upMid,
      itemId: reply.id.toString(),
      url: url,
    );
  }
}

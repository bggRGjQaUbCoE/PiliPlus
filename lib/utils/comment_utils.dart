import 'package:PiliPlus/models_new/reply/reply.dart';
import 'package:PiliPlus/utils/date_utils.dart';

/// 评论导出格式，name 直接用作文件扩展名
enum CommentExportFormat { txt, csv }

/// 一条待导出的评论
///
/// 与 [ReplyItemModel] 解耦的扁平结构，便于序列化保存抓取断点。
class CommentRecord {
  const CommentRecord({
    required this.message,
    required this.uname,
    required this.like,
    required this.ctime,
    required this.isSub,
  });

  final String message;
  final String uname;
  final int like;
  final int ctime;

  /// true 表示楼中楼回复
  final bool isSub;

  Map<String, dynamic> toJson() => {
    'message': message,
    'uname': uname,
    'like': like,
    'ctime': ctime,
    'isSub': isSub,
  };

  factory CommentRecord.fromJson(Map<String, dynamic> json) => CommentRecord(
    message: json['message'] as String? ?? '',
    uname: json['uname'] as String? ?? '',
    like: json['like'] as int? ?? 0,
    ctime: json['ctime'] as int? ?? 0,
    isSub: json['isSub'] as bool? ?? false,
  );
}

/// 评论主楼接口的翻页方式
enum ReplyFetchMode {
  /// 尚未确认，优先试 wbi 接口，失败则永久回退旧接口
  auto,

  /// wbi/main 游标翻页
  wbi,

  /// 旧版 /main 游标翻页
  legacy,
}

/// 抓取进度，可整体序列化用于断点续爬
class CommentCrawlState {
  CommentCrawlState({
    this.cursor = '',
    this.mode = ReplyFetchMode.auto,
    List<CommentRecord>? comments,
  }) : comments = comments ?? [];

  /// wbi 接口用字符串 offset，旧接口用数字 next，统一按字符串保存
  String cursor;

  ReplyFetchMode mode;

  /// 已抓到的评论，异常/取消时保留部分结果
  final List<CommentRecord> comments;

  Map<String, dynamic> toJson() => {
    'cursor': cursor,
    'mode': mode.name,
    'comments': comments.map((e) => e.toJson()).toList(),
  };

  factory CommentCrawlState.fromJson(Map<String, dynamic> json) =>
      CommentCrawlState(
        cursor: json['cursor'] as String? ?? '',
        mode: ReplyFetchMode.values.firstWhere(
          (e) => e.name == json['mode'],
          orElse: () => ReplyFetchMode.auto,
        ),
        comments: (json['comments'] as List?)
            ?.map((e) => CommentRecord.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// 抓取过程中的错误，[isRiskControl] 为 true 时建议稍后续爬
class CommentCrawlException implements Exception {
  const CommentCrawlException(this.message, {this.isRiskControl = false});

  final String message;
  final bool isRiskControl;

  @override
  String toString() => message;
}

extension ReplyItemModelExt on ReplyItemModel {
  /// 转成导出用的扁平结构，内容为空（已删除/纯表情）时返回 null
  CommentRecord? toCommentRecord({bool isSub = false}) {
    final message = (content?.message ?? '')
        .replaceAll(RegExp(r'[\r\n]+'), ' ')
        .trim();
    if (message.isEmpty) return null;
    return CommentRecord(
      message: message,
      uname: member?.uname ?? '',
      like: like ?? 0,
      ctime: ctime ?? 0,
      isSub: isSub,
    );
  }
}

abstract final class CommentUtils {
  /// 纯文本：一条评论一行
  static String toTxt(List<CommentRecord> list) =>
      list.map((e) => e.message).join('\n');

  static String _csvCell(String? value) =>
      '"${(value ?? '').replaceAll('"', '""')}"';

  /// 结构化 CSV：带 BOM，列顺序 用户名,点赞,时间,类型,内容
  static String toCsv(List<CommentRecord> list) {
    final sb = StringBuffer('\uFEFF用户名,点赞,时间,类型,内容\n');
    for (final e in list) {
      sb.writeln(
        <Object>[
          _csvCell(e.uname),
          e.like,
          _csvCell(
            e.ctime == 0
                ? ''
                : DateFormatUtils.longFormatDs.format(
                    DateTime.fromMillisecondsSinceEpoch(e.ctime * 1000),
                  ),
          ),
          e.isSub ? '楼中楼' : '主评论',
          _csvCell(e.message),
        ].join(','),
      );
    }
    return sb.toString();
  }
}

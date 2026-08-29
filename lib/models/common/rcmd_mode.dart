import 'package:PiliPlus/models/common/enum_with_label.dart';

enum RcmdMode implements EnumWithLabel {
  personalized('个性推荐', '保留账号画像，使用哔哩哔哩原始个性化推荐'),
  pure('纯净初见', '推荐接口使用匿名身份，每次刷新都尽量减少账号画像影响'),
  explore('探索模式', '首屏使用个性推荐，后续分页切换为匿名推荐'),
  mixed('混合模式', '个性推荐与匿名推荐按页交替');

  const RcmdMode(this.label, this.description);

  @override
  final String label;
  final String description;

  bool anonymousForPage(int page) => switch (this) {
    personalized => false,
    pure => true,
    explore => page > 0,
    mixed => page.isOdd,
  };
}

// ignore_for_file: constant_identifier_names

import 'package:PiliPlus/l10n/l10n.dart';

enum LiveContributionRankType {
  online_rank('contribution_rank'),
  daily_rank('today_rank'),
  weekly_rank('current_week_rank'),
  monthly_rank('current_month_rank'),
  ;

  String get title => switch (this) {
    online_rank => L10n.current.liveContributionRankTypeOnlineRankTitle,
    daily_rank => L10n.current.liveContributionRankTypeDailyRankTitle,
    weekly_rank => L10n.current.liveContributionRankTypeWeeklyRankTitle,
    monthly_rank => L10n.current.liveContributionRankTypeMonthlyRankTitle,
  };
  final String sw1tch;
  const LiveContributionRankType(this.sw1tch);
}

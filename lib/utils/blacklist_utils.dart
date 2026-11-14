/// B站在线黑名单达到 5000 人时，允许启用本地弹幕屏蔽兜底。
const int onlineBlacklistMaxCount = 5000;

/// 在线名单数量未知时不启用本地兜底，避免提前把作者加入本地屏蔽。
bool shouldUseLocalBlacklistFallback(int? onlineCount) =>
    onlineCount != null && onlineCount >= onlineBlacklistMaxCount;

enum AudioQuality {
  autoAdvanced(-1, '自动选择最佳音质'),
  u_100010(100010, '100010'),
  u_100009(100009, '100009'),
  u_100008(100008, '100008'),
  hiRes(30251, 'Hi-Res无损'),
  dolby_30250(30250, '杜比全景声'),
  dolby_30255(30255, '杜比全景声'),
  k192(30280, '192K'),
  k132(30232, '132K'),
  k64(30216, '64K'),
  ;

  final int code;
  final String desc;

  const AudioQuality(this.code, this.desc);

  static final _codeMap = {for (final i in values) i.code: i};

  static AudioQuality fromCode(int code) => _codeMap[code]!;

  /// 设置页可选音质列表：新增的“自动选择最佳音质”置于最前，其余保持原顺序不变。
  static const List<AudioQuality> defaultAudioQualityOptions = [
    autoAdvanced,
    u_100010,
    u_100009,
    u_100008,
    hiRes,
    dolby_30250,
    dolby_30255,
    k192,
    k132,
    k64,
  ];

  /// 自动选择时的回退优先级：Hi-Res → 杜比全景声 → 杜比音效 → 192K → 132K → 64K。
  /// 三种高级音效互斥（同一视频最多只有一种），故高级音效之间的先后不影响实际结果。
  static const List<int> _autoFallbackOrder = [
    30251, // Hi-Res
    30250, // 杜比全景声
    30255, // 杜比音效
    30280, // 192K
    30232, // 132K
    30216, // 64K
  ];

  /// 根据目标音质 [target] 从可用音轨 [available] 中选出实际音轨 id。
  /// [target] 为 -1（自动选择最佳音质）时按 [_autoFallbackOrder] 取第一个可用音轨；
  /// 否则保持原有的固定选择逻辑，不改变现有用户行为。
  static int selectAudioQuality(int target, List<int> available) {
    if (target == autoAdvanced.code) {
      for (final id in _autoFallbackOrder) {
        if (available.contains(id)) {
          return id;
        }
      }
      return available.first;
    }
    final candidates = available.where((e) => e <= target).toList();
    int closestNumber = candidates.isNotEmpty
        ? candidates.reduce((a, b) => a > b ? a : b)
        : available.reduce((a, b) => a > b ? a : b);
    if (!available.contains(target) && available.any((e) => e > target)) {
      closestNumber = AudioQuality.k192.code;
    }
    return closestNumber;
  }
}

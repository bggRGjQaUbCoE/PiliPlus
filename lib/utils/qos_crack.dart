import 'package:shared_preferences/shared_preferences.dart';

/// 读取用户开关
Future<bool> isQoSCrackEnabled() async {
  final sp = await SharedPreferences.getInstance();
  return sp.getBool('qos_crack_enable') ?? false;
}

/// 伪造高画质参数
Map<String, String> crackQos(Map<String, String> query) {
  query['qn']     = '127';  // 4K
  query['fnval']  = '976';  // HEVC + Dolby Vision
  query['fourk']  = '1';
  query['fnver']  = '0';
  return query;
}

import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

abstract final class UserWhitelist {
  static bool contains(int? mid) {
    return mid != null && GlobalData().whitelistMids.containsKey(mid);
  }

  static void save(Map<int, String> whitelistMids) {
    Pref.whitelistMids = whitelistMids;
    GlobalData().whitelistMids = whitelistMids;
  }

  static void add({
    required int mid,
    required String name,
  }) {
    final whitelistMids = Map<int, String>.from(Pref.whitelistMids);
    final displayName = name.trim().isEmpty ? 'UID:$mid' : name.trim();
    whitelistMids[mid] = displayName;
    save(whitelistMids);
  }

}

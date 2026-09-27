import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/grpc_headers.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive_ce/hive.dart';

/// 请求层使用的账号能力协议。
///
/// 实现分为持久化的 [LoginAccount]、进程级匿名账号 [AnonymousAccount]，
/// 以及用于显式跳过账号处理的 [NoAccount]。
sealed class Account {
  Map<String, dynamic>? toJson() => null;

  Future<void>? onChange() => null;

  Set<AccountType> get type => const {};

  bool get activated => false;

  set activated(bool value) => throw UnimplementedError();

  String? get accessKey => throw UnimplementedError();

  DefaultCookieJar get cookieJar => throw UnimplementedError();

  String get csrf => throw UnimplementedError();

  Future<void> delete() => throw UnimplementedError();

  Map<String, String> get headers => throw UnimplementedError();

  Map<String, String> get grpcHeaders => throw UnimplementedError();

  bool get isLogin => throw UnimplementedError();

  int get mid => throw UnimplementedError();

  String? get refresh => throw UnimplementedError();

  const Account();
}

/// 已登录账号。CookieJar、access key、refresh token 和角色集合持久化到 Hive。
@HiveType(typeId: 9)
class LoginAccount extends Account {
  @override
  final bool isLogin = true;
  @override
  @HiveField(0)
  final DefaultCookieJar cookieJar;
  @override
  @HiveField(1)
  final String? accessKey;
  @override
  @HiveField(2)
  final String? refresh;
  @override
  @HiveField(3)
  final Set<AccountType> type;

  @override
  bool activated = false;

  @override
  late final int mid = int.parse(_midStr);

  @override
  // Web/App 共用的客户端头；mid 和设备标识由当前登录账号动态生成。
  late final Map<String, String> headers = {
    ...Constants.baseHeaders,
    'x-bili-mid': _midStr,
    'x-bili-aurora-eid': IdUtils.genAuroraEid(mid),
  };

  @override
  late final Map<String, String> grpcHeaders = GrpcHeaders.newHeaders(
    accessKey,
  );

  @override
  late final String csrf =
      cookieJar.domainCookies['bilibili.com']!['/']!['bili_jct']!.cookie.value;

  // 删除墓碑必须先于异步删除落盘：迟到的网络响应可能仍会调用 onChange()，
  // 若不检查该标记，已删除账号会被 Cookie 响应重新写回 Hive。
  bool _hasDelete = false;

  @override
  Future<void> delete() {
    _hasDelete = true;
    return Future.wait([cookieJar.deleteAll(), _box.delete(_midStr)]);
  }

  @override
  Future<void>? onChange() {
    if (_hasDelete) return null;
    return _box.put(_midStr, this);
  }

  @override
  Map<String, dynamic>? toJson() => {
    'cookies': cookieJar.toJson(),
    'accessKey': accessKey,
    'refresh': refresh,
    'type': type.map((i) => i.index).toList(),
  };

  late final String _midStr = cookieJar
      .domainCookies['bilibili.com']!['/']!['DedeUserID']!
      .cookie
      .value;

  late final Box<LoginAccount> _box = Accounts.account;

  LoginAccount(
    this.cookieJar,
    this.accessKey,
    this.refresh, [
    Set<AccountType>? type,
  ]) : type = type ?? {} {
    // 每个登录/匿名身份都需要稳定的 buvid3，供游客态和风控请求使用。
    cookieJar.setBuvid3();
  }

  factory LoginAccount.fromJson(Map json) => LoginAccount(
    BiliCookieJar.fromJson(json['cookies']),
    json['accessKey'],
    json['refresh'],
    (json['type'] as Iterable?)?.map((i) => AccountType.values[i]).toSet(),
  );

  @override
  int get hashCode => mid.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LoginAccount && mid == other.mid);
}

/// 匿名账号单例。角色切换可复用它，但删除时会重置 Cookie/BUVID。
class AnonymousAccount extends Account {
  @override
  final bool isLogin = false;
  @override
  final DefaultCookieJar cookieJar = DefaultCookieJar()..setBuvid3();
  @override
  final String? accessKey = null;
  @override
  final String? refresh = null;
  @override
  final Set<AccountType> type = {};
  @override
  final int mid = 0;
  @override
  final String csrf = '';
  @override
  final Map<String, String> headers = Constants.baseHeaders;

  @override
  final Map<String, String> grpcHeaders = GrpcHeaders.newHeaders();

  @override
  bool activated = false;

  @override
  Future<void> delete() {
    grpcHeaders['x-bili-fawkes-req-bin'] = GrpcHeaders.fawkes;
    return cookieJar.deleteAll().whenComplete(cookieJar.setBuvid3);
  }

  // 匿名账号无需按角色复制；所有匿名槽位共享同一个 CookieJar。
  static final _instance = AnonymousAccount._();

  AnonymousAccount._();

  factory AnonymousAccount() => _instance;

  @override
  int get hashCode => cookieJar.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnonymousAccount && cookieJar == other.cookieJar);
}

extension BiliCookie on Cookie {
  void setBiliDomain([String domain = '.bilibili.com']) {
    this.domain = domain;
    httpOnly = false;
    path = '/';
  }
}

extension BiliCookieJar on DefaultCookieJar {
  Map<String, String> toJson() {
    final cookies = domainCookies['bilibili.com']?['/'] ?? const {};
    return {for (final i in cookies.values) i.cookie.name: i.cookie.value};
  }

  List<Cookie> toList() =>
      domainCookies['bilibili.com']?['/']?.entries
          .map((i) => i.value.cookie)
          .toList() ??
      [];

  void setBuvid3() {
    (domainCookies['bilibili.com'] ??= {
      '/': {},
    })['/']!['buvid3'] ??= SerializableCookie(
      Cookie('buvid3', IdUtils.genBuvid3())..setBiliDomain(),
    );
  }

  static DefaultCookieJar fromJson(Map json) =>
      DefaultCookieJar(ignoreExpires: true)
        ..domainCookies['bilibili.com'] = {
          '/': {
            for (final i in json.entries)
              i.key: SerializableCookie(
                Cookie(i.key, i.value)..setBiliDomain(),
              ),
          },
        };

  static DefaultCookieJar fromList(List cookies) =>
      DefaultCookieJar(ignoreExpires: true)
        ..domainCookies['bilibili.com'] = {
          '/': {
            for (final i in cookies)
              i['name']!: SerializableCookie(
                Cookie(i['name']!, i['value']!)..setBiliDomain(),
              ),
          },
        };
}

/// 标记“此请求不绑定任何账号”。AccountManager 会原样放行且不处理 Cookie。
final class NoAccount extends Account {
  const NoAccount();
}

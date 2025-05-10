import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';

abstract class Account {
  bool get isLogin;
  DefaultCookieJar get cookieJar;
  String? get accessKey;
  String? get refresh;
  Set<AccountType> get type;

  int get mid;
  String get csrf;
  Map<String, String> get headers;

  // bool activited = false;

  Future<void> delete();
  Future<void> onChange();

  Map<String, dynamic>? toJson();
}

@HiveType(typeId: 9)
class LoginAccount implements Account {
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
  late final int mid = int.parse(_midStr);

  @override
  late final Map<String, String> headers = {
    'x-bili-mid': _midStr,
    'x-bili-aurora-eid': Utils.genAuroraEid(mid),
  };
  @override
  late final String csrf =
      cookieJar.domainCookies['bilibili.com']!['/']!['bili_jct']!.cookie.value;

  @override
  Future<void> delete() => _box.delete(_midStr);

  @override
  Future<void> onChange() => _box.put(_midStr, this);

  @override
  Map<String, dynamic>? toJson() => {
        'cookies': cookieJar.toJson(),
        'accessKey': accessKey,
        'refresh': refresh,
        'type': type.map((i) => i.index).toList()
      };

  late final String _midStr = cookieJar
      .domainCookies['bilibili.com']!['/']!['DedeUserID']!.cookie.value;

  late final Box<LoginAccount> _box = Accounts.account;

  LoginAccount(
    this.cookieJar,
    this.accessKey,
    this.refresh, [
    Set<AccountType>? type,
  ]) : type = type ?? {};

  factory LoginAccount.fromJson(Map<String, dynamic> json) => LoginAccount(
        BiliCookieJar.fromJson(json['cookies'])..setBuvid3(),
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

class AnonymousAccount implements Account {
  @override
  final bool isLogin = false;
  @override
  final DefaultCookieJar cookieJar = DefaultCookieJar(ignoreExpires: true)
    ..setBuvid3();
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
  final Map<String, String> headers = const {};

  @override
  Future<void> delete() async {
    await cookieJar.deleteAll();
    cookieJar.setBuvid3();
  }

  @override
  Future<void> onChange() async {}

  @override
  Map<String, dynamic>? toJson() => null;

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
    this
      ..domain = domain
      ..httpOnly = false
      ..path = '/';
  }
}

extension BiliCookieJar on DefaultCookieJar {
  Map<String, String> toJson() {
    final cookies = domainCookies['bilibili.com']?['/'] ?? {};
    return {for (var i in cookies.values) i.cookie.name: i.cookie.value};
  }

  List<Cookie> toList() =>
      domainCookies['bilibili.com']?['/']
          ?.entries
          .map((i) => i.value.cookie)
          .toList() ??
      [];

  void setBuvid3() {
    domainCookies['bilibili.com'] ??= {'/': {}};
    domainCookies['bilibili.com']!['/']!['buvid3'] ??= SerializableCookie(
        Cookie('buvid3', Utils.genBuvid3())..setBiliDomain());
  }

  static DefaultCookieJar fromJson(Map json) =>
      DefaultCookieJar(ignoreExpires: true)
        ..domainCookies['bilibili.com'] = {
          '/': {
            for (var i in json.entries)
              i.key: SerializableCookie(Cookie(i.key, i.value)..setBiliDomain())
          },
        };

  static DefaultCookieJar fromList(List cookies) =>
      DefaultCookieJar(ignoreExpires: true)
        ..domainCookies['bilibili.com'] = {
          '/': {
            for (var i in cookies)
              i['name']!: SerializableCookie(
                  Cookie(i['name']!, i['value']!)..setBiliDomain()),
          },
        };
}

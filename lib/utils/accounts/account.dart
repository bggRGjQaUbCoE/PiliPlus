import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';

abstract class Account {
  final bool isLogin = false;
  late final DefaultCookieJar cookieJar;
  String? accessKey;
  String? refresh;
  late final Set<AccountType> type;

  final int mid = 0;
  late String csrf;
  final Map<String, String> headers = const {};

  bool activited = false;

  Future<AnonymousAccount> logout();
  Future<void> onChange();

  Map<String, dynamic>? toJson();
}

@HiveType(typeId: 9)
class LoginAccount implements Account {
  @override
  final bool isLogin = true;
  @override
  @HiveField(0)
  late final DefaultCookieJar cookieJar;
  @override
  @HiveField(1)
  String? accessKey;
  @override
  @HiveField(2)
  String? refresh;
  @override
  @HiveField(3)
  late final Set<AccountType> type;

  @override
  late final int mid = int.parse(_midStr);

  @override
  late final Map<String, String> headers = {
    'x-bili-mid': _midStr,
    'x-bili-aurora-eid': Utils.genAuroraEid(mid),
  };
  @override
  late String csrf =
      cookieJar.domainCookies['bilibili.com']!['/']!['bili_jct']!.cookie.value;

  @override
  bool activited = false;

  @override
  Future<AnonymousAccount> logout() async {
    await Future.wait([cookieJar.deleteAll(), _box.delete(_midStr)]);
    return AnonymousAccount();
  }

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

  LoginAccount(this.cookieJar, this.accessKey, this.refresh,
      [Set<AccountType>? type]) {
    this.type = type ?? {};
  }

  LoginAccount.fromJson(Map json) {
    cookieJar = BiliCookieJar.fromJson(json['cookies']);
    accessKey = json['accessKey'];
    refresh = json['refresh'];
    type = (json['type'] as Iterable?)
            ?.map((i) => AccountType.values[i])
            .toSet() ??
        {};
  }

  @override
  int get hashCode => mid.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Account && mid == other.mid);
}

class AnonymousAccount implements Account {
  @override
  final bool isLogin = false;
  @override
  late final DefaultCookieJar cookieJar;
  @override
  String? accessKey;
  @override
  String? refresh;
  @override
  Set<AccountType> type = {};
  @override
  final int mid = 0;
  @override
  String csrf = '';
  @override
  final Map<String, String> headers = const {};

  @override
  bool activited = false;

  @override
  Future<AnonymousAccount> logout() async {
    await cookieJar.deleteAll();
    activited = false;
    return this;
  }

  @override
  Future<void> onChange() async {}

  @override
  Map<String, dynamic>? toJson() => null;

  static final _instance = AnonymousAccount._();

  AnonymousAccount._() {
    cookieJar = DefaultCookieJar(ignoreExpires: true);
  }

  factory AnonymousAccount() => _instance;

  @override
  int get hashCode => cookieJar.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account && cookieJar == other.cookieJar);
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

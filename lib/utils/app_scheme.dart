import 'dart:async';

import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../http/search.dart';
import '../pages/video/detail/reply_reply/view.dart';
import 'id_utils.dart';
import 'url_utils.dart';
import 'utils.dart';

class PiliScheme {
  static late AppLinks appLinks;
  static StreamSubscription? listener;
  static final uriDigitRegExp = RegExp(r'/(\d+)');

  static Future<void> init() async {
    // Register our protocol only on Windows platform
    // registerProtocolHandler('bilibili');
    appLinks = AppLinks();

    listener?.cancel();
    listener = appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      routePush(uri);
    });
  }

  static Future<bool> routePushFromUrl(
    String url, {
    bool selfHandle = false,
    bool off = false,
  }) async {
    try {
      if (url.startsWith('//')) {
        url = 'https:$url';
      } else if (RegExp(r'^\S+://').hasMatch(url).not) {
        url = 'https://$url';
      }
      return await routePush(Uri.parse(url), selfHandle: selfHandle, off: off);
    } catch (_) {
      return false;
    }
  }

  /// 路由跳转
  static Future<bool> routePush(
    Uri uri, {
    bool selfHandle = false,
    bool off = false,
  }) async {
    final String scheme = uri.scheme;
    final String host = uri.host.toLowerCase();
    final String path = uri.path;

    switch (scheme) {
      case 'bilibili':
        switch (host) {
          case 'root':
            Navigator.popUntil(
              Get.context!,
              (Route<dynamic> route) => route.isFirst,
            );
            return true;
          case 'pgc':
            // bilibili://pgc/season/ep/123456?h5_awaken_params=random
            String? id = uriDigitRegExp.firstMatch(path)?.group(1);
            if (id != null) {
              bool isEp = path.contains('/ep/');
              Utils.viewBangumi(
                  seasonId: isEp ? null : id,
                  epId: isEp ? id : null,
                  progress: uri.queryParameters['start_progress']);
              return true;
            }
            return false;
          case 'space':
            // bilibili://space/12345678?frommodule=XX&h5awaken=random
            String? mid = uriDigitRegExp.firstMatch(path)?.group(1);
            if (mid != null) {
              Utils.toDupNamed('/member?mid=$mid', off: off);
              return true;
            }
            return false;
          case 'video':
            // bilibili://video/12345678?dm_progress=123000&cid=12345678&dmid=12345678
            // bilibili://video/{aid}/?comment_root_id=***&comment_secondary_id=***
            final queryParameters = uri.queryParameters;
            if (queryParameters['comment_root_id'] != null) {
              // to check
              // to video reply
              String? oid = uriDigitRegExp.firstMatch(path)?.group(1);
              int? rpid = int.tryParse(queryParameters['comment_root_id']!);
              if (oid != null && rpid != null) {
                Get.to(
                  () => Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: const Text('评论详情'),
                      actions: [
                        IconButton(
                          tooltip: '前往原视频',
                          onPressed: () {
                            String? enterUri =
                                uri.toString().split('?').first; // to check
                            routePush(Uri.parse(enterUri));
                          },
                          icon: const Icon(Icons.open_in_new),
                        ),
                      ],
                    ),
                    body: VideoReplyReplyPanel(
                      oid: int.parse(oid),
                      rpid: rpid,
                      source: 'routePush',
                      replyType: ReplyType.video,
                      firstFloor: null,
                      id: queryParameters['comment_secondary_id'] != null
                          ? int.tryParse(
                              queryParameters['comment_secondary_id']!)
                          : null,
                    ),
                  ),
                );
                return true;
              }
              return false;
            }

            // to video
            // bilibili://video/12345678?page=0&h5awaken=random
            String? aid = uriDigitRegExp.firstMatch(path)?.group(1);
            String? bvid = RegExp(r'/(BV[a-z\d]{10})', caseSensitive: false)
                .firstMatch(path)
                ?.group(1);
            if (aid != null || bvid != null) {
              if (queryParameters['cid'] != null) {
                bvid ??= IdUtils.av2bv(int.parse(aid!));
                Utils.toViewPage(
                  'bvid=$bvid&cid=${queryParameters['cid']}',
                  arguments: {
                    'pic': null,
                    'heroTag': Utils.makeHeroTag(aid),
                    if (queryParameters['dm_progress'] != null)
                      'progress': int.tryParse(queryParameters['dm_progress']!),
                  },
                  off: off,
                  preventDuplicates: false,
                );
              } else {
                videoPush(
                  aid != null ? int.parse(aid) : null,
                  bvid,
                  off: off,
                  progress: queryParameters['dm_progress'],
                );
              }
              return true;
            }
            return false;
          case 'live':
            // bilibili://live/12345678?extra_jump_from=1&from=1&is_room_feed=1&h5awaken=random
            String? roomId = uriDigitRegExp.firstMatch(path)?.group(1);
            if (roomId != null) {
              Utils.toDupNamed('/liveRoom?roomid=$roomId', off: off);
              return true;
            }
            return false;
          case 'bangumi':
            // bilibili://bangumi/season/12345678?h5_awaken_params=random
            if (path.startsWith('/season')) {
              String? seasonId = uriDigitRegExp.firstMatch(path)?.group(1);
              if (seasonId != null) {
                Utils.viewBangumi(seasonId: seasonId, epId: null);
                return true;
              }
            }
            return false;
          case 'opus':
            // bilibili://opus/detail/12345678?h5awaken=random
            if (path.startsWith('/detail')) {
              bool hasMatch = await _onPushDynDetail(path, off);
              return hasMatch;
            }
            return false;
          case 'search':
            Utils.toDupNamed(
              '/searchResult',
              parameters: {'keyword': ''},
              off: off,
            );
            return true;
          case 'article':
            // bilibili://article/40679479?jump_opus=1&jump_opus_type=1&opus_type=article&h5awaken=random
            String? id = uriDigitRegExp.firstMatch(path)?.group(1);
            if (id != null) {
              Utils.toDupNamed(
                '/htmlRender',
                parameters: {
                  'url': 'www.bilibili.com/read/cv$id',
                  'title': '',
                  'id': 'cv$id',
                  'dynamicType': 'read'
                },
                off: off,
              );
              return true;
            }
            return false;
          case 'comment':
            if (path.startsWith("/detail/")) {
              // bilibili://comment/detail/17/832703053858603029/238686570016/?subType=0&anchor=238686628816&showEnter=1&extraIntentId=0&scene=1&enterName=%E6%9F%A5%E7%9C%8B%E5%8A%A8%E6%80%81%E8%AF%A6%E6%83%85&enterUri=bilibili://following/detail/832703053858603029
              List<String> pathSegments = uri.pathSegments;
              int type = int.parse(pathSegments[1]);
              int oid = int.parse(pathSegments[2]);
              int rootId = int.parse(pathSegments[3]);
              // int subType = int.parse(value.queryParameters['subType'] ?? '0');
              // int rpID = int.parse(value.queryParameters['anchor'] ?? '0');
              // int extraIntentId =
              // int.parse(value.queryParameters['extraIntentId'] ?? '0');
              Get.to(
                () => Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: const Text('评论详情'),
                    actions: [
                      IconButton(
                        tooltip: '前往',
                        onPressed: () {
                          String? enterUri = uri.queryParameters['enterUri'];
                          if (enterUri != null) {
                            routePush(Uri.parse(enterUri));
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                      ),
                    ],
                  ),
                  body: VideoReplyReplyPanel(
                    oid: oid,
                    rpid: rootId,
                    source: 'routePush',
                    replyType: ReplyType.values[type],
                    firstFloor: null,
                  ),
                ),
              );
              return true;
            }
            return false;
          case 'following':
            if (path.startsWith("/detail/")) {
              final queryParameters = uri.queryParameters;
              final commentRootId = queryParameters['comment_root_id'];
              if (commentRootId != null) {
                String? oid = uriDigitRegExp.firstMatch(path)?.group(1);
                int? rpid = int.tryParse(commentRootId);
                if (oid != null && rpid != null) {
                  Get.to(
                    () => Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: AppBar(
                        title: const Text('评论详情'),
                        actions: [
                          IconButton(
                            tooltip: '前往',
                            onPressed: () {
                              _onPushDynDetail(path, off);
                            },
                            icon: const Icon(Icons.open_in_new),
                          ),
                        ],
                      ),
                      body: VideoReplyReplyPanel(
                        oid: int.parse(oid),
                        rpid: rpid,
                        source: 'routePush',
                        replyType: ReplyType.dynamics,
                        firstFloor: null,
                        id: queryParameters['comment_secondary_id'] != null
                            ? int.tryParse(
                                queryParameters['comment_secondary_id']!)
                            : null,
                      ),
                    ),
                  );
                }
                return true;
              } else {
                bool hasMatch = await _onPushDynDetail(path, off);
                return hasMatch;
              }
            }
            return false;
          case 'album':
            String? rid = uriDigitRegExp.firstMatch(path)?.group(1);
            if (rid != null) {
              SmartDialog.showLoading();
              dynamic res = await DynamicsHttp.dynamicDetail(rid: rid, type: 2);
              SmartDialog.dismiss();
              if (res['status']) {
                Utils.toDupNamed(
                  '/dynamicDetail',
                  arguments: {
                    'item': res['data'],
                    'floor': 1,
                    'action': 'detail'
                  },
                  off: off,
                );
              } else {
                SmartDialog.showToast(res['msg']);
              }
              return true;
            }
            return false;
          default:
            if (selfHandle.not) {
              debugPrint('$uri');
              SmartDialog.showToast('未知路径:$uri，请截图反馈给开发者');
            }
            return false;
        }
      case 'http' || 'https':
        return await _fullPathPush(uri, selfHandle: selfHandle, off: off);
      default:
        String? aid = RegExp(r'^av(\d+)', caseSensitive: false)
            .firstMatch(path)
            ?.group(1);
        String? bvid = RegExp(r'^BV[a-z\d]{10}', caseSensitive: false)
            .firstMatch(path)
            ?.group(0);
        if (aid != null || bvid != null) {
          videoPush(
            aid != null ? int.parse(aid) : null,
            bvid,
            off: off,
          );
          return true;
        }
        if (selfHandle.not) {
          debugPrint('$uri');
          SmartDialog.showToast('未知路径:$uri，请截图反馈给开发者');
        }
        return false;
    }
  }

  static Future<bool> _fullPathPush(
    Uri uri, {
    bool selfHandle = false,
    bool off = false,
  }) async {
    // https://m.bilibili.com/bangumi/play/ss39708
    // https | m.bilibili.com | /bangumi/play/ss39708

    String host = uri.host.toLowerCase();

    if (selfHandle &&
        host.contains('bilibili.com').not &&
        host.contains('b23.tv').not) {
      return false;
    }

    void launchURL() {
      if (selfHandle.not) {
        _toWebview(uri.toString(), off);
      }
    }

    // b23.tv
    // bilibili.com
    // m.bilibili.com
    // www.bilibili.com
    // space.bilibili.com
    // live.bilibili.com

    // redirect
    if (host.contains('b23.tv')) {
      String? redirectUrl = await UrlUtils.parseRedirectUrl(uri.toString());
      if (redirectUrl != null) {
        uri = Uri.parse(redirectUrl);
        host = uri.host.toLowerCase();
      }
      if (host.contains('bilibili.com').not) {
        launchURL();
        return false;
      }
    }

    final String path = uri.path;

    if (host.contains('t.bilibili.com')) {
      bool hasMatch = await _onPushDynDetail(path, off);
      if (hasMatch.not) {
        launchURL();
      }
      return hasMatch;
    }

    if (host.contains('live.bilibili.com')) {
      String? roomId = uriDigitRegExp.firstMatch(path)?.group(1);
      if (roomId != null) {
        Utils.toDupNamed('/liveRoom?roomid=$roomId', off: off);
        return true;
      }
      launchURL();
      return false;
    }

    if (host.contains('space.bilibili.com')) {
      String? mid = uriDigitRegExp.firstMatch(path)?.group(1);
      if (mid != null) {
        Utils.toDupNamed('/member?mid=$mid', off: off);
        return true;
      }
      launchURL();
      return false;
    }

    List<String> pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) {
      launchURL();
      return false;
    }
    final String? area = pathSegments.first == 'mobile'
        ? pathSegments.getOrNull(1)
        : pathSegments.first;
    switch (area) {
      case 'opus' || 'dynamic':
        bool hasMatch = await _onPushDynDetail(path, off);
        if (hasMatch.not) {
          launchURL();
        }
        return hasMatch;
      case 'playlist':
        String? bvid = uri.queryParameters['bvid'] ??
            RegExp(r'/(BV[a-z\d]{10})', caseSensitive: false)
                .firstMatch(path)
                ?.group(1);
        if (bvid != null) {
          videoPush(null, bvid, off: off);
          return true;
        }
        launchURL();
        return false;
      case 'bangumi':
        // www.bilibili.com/bangumi/play/ep{eid}?start_progress={offset}&thumb_up_dm_id={dmid}
        debugPrint('番剧');
        String? id = RegExp(r'(ss|ep)\d+').firstMatch(path)?.group(0);
        if (id != null) {
          bool isSeason = id.startsWith('ss');
          id = id.substring(2);
          Utils.viewBangumi(
              seasonId: isSeason ? id : null,
              epId: isSeason ? null : id,
              progress: uri.queryParameters['start_progress']);
          return true;
        }
        launchURL();
        return false;
      case 'video':
        debugPrint('投稿');
        final Map<String, dynamic> map = IdUtils.matchAvorBv(input: path);
        if (map.isNotEmpty) {
          final queryParameters = uri.queryParameters;
          videoPush(
            map['AV'],
            map['BV'],
            off: off,
            progress: queryParameters['dm_progress'],
            part: queryParameters['p'],
          );
          return true;
        }
        launchURL();
        return false;
      case 'read':
        debugPrint('专栏');
        String? id =
            RegExp(r'cv(\d+)', caseSensitive: false).firstMatch(path)?.group(1);
        if (id != null) {
          Utils.toDupNamed(
            '/htmlRender',
            parameters: {
              'url': 'https://www.bilibili.com/read/cv$id',
              'title': '',
              'id': 'cv$id',
              'dynamicType': 'read'
            },
            off: off,
          );
          return true;
        }
        launchURL();
        return false;
      case 'space':
        debugPrint('个人空间');
        String? mid = uriDigitRegExp.firstMatch(path)?.group(1);
        if (mid != null) {
          Utils.toDupNamed(
            '/member?mid=$mid',
            off: off,
          );
          return true;
        }
        launchURL();
        return false;
      default:
        Map map = IdUtils.matchAvorBv(input: area?.split('?').first);
        if (map.isNotEmpty) {
          videoPush(
            map['AV'],
            map['BV'],
            off: off,
          );
          return true;
        }
        launchURL();
        return false;
    }
  }

  static Future<bool> _onPushDynDetail(path, off) async {
    String? id = uriDigitRegExp.firstMatch(path)?.group(1);
    if (id != null) {
      SmartDialog.showLoading();
      dynamic res = await DynamicsHttp.dynamicDetail(id: id);
      SmartDialog.dismiss();
      if (res['status']) {
        Utils.toDupNamed(
          '/dynamicDetail',
          arguments: {
            'item': res['data'],
            'floor': 1,
            'action': 'detail',
          },
          off: off,
        );
      } else {
        SmartDialog.showToast(res['msg']);
      }
      return true;
    }
    return false;
  }

  static void _toWebview(String url, bool off) {
    Utils.toDupNamed(
      '/webview',
      parameters: {'url': url},
      off: off,
    );
  }

  // 投稿跳转
  static Future<void> videoPush(
    int? aid,
    String? bvid, {
    bool showDialog = true,
    bool off = false,
    String? progress,
    String? part,
  }) async {
    try {
      aid ??= IdUtils.bv2av(bvid!);
      bvid ??= IdUtils.av2bv(aid);
      if (showDialog) {
        SmartDialog.showLoading<dynamic>(msg: '获取中...');
      }
      final int cid = await SearchHttp.ab2c(
        bvid: bvid,
        aid: aid,
        part: part != null ? int.tryParse(part) : null,
      );
      if (showDialog) {
        SmartDialog.dismiss();
      }
      Utils.toViewPage(
        'bvid=$bvid&cid=$cid',
        arguments: {
          'pic': null,
          'heroTag': Utils.makeHeroTag(aid),
          if (progress != null) 'progress': int.tryParse(progress),
        },
        off: off,
        preventDuplicates: false,
      );
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('video获取失败: $e');
    }
  }
}

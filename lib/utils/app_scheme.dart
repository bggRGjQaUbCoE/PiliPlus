import 'dart:async';

import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
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
    Map? parameters,
    int? businessId,
    int? oid,
  }) async {
    try {
      if (url.startsWith('//')) {
        url = 'https:$url';
      } else if (RegExp(r'^\S+://').hasMatch(url).not) {
        url = 'https://$url';
      }
      return await routePush(
        Uri.parse(url),
        selfHandle: selfHandle,
        off: off,
        parameters: parameters,
        businessId: businessId,
        oid: oid,
      );
    } catch (_) {
      return false;
    }
  }

  /// 路由跳转
  static Future<bool> routePush(
    Uri uri, {
    bool selfHandle = false,
    bool off = false,
    Map? parameters,
    int? businessId,
    int? oid,
  }) async {
    final String scheme = uri.scheme;
    final String host = uri.host;
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
              PageUtils.viewBangumi(
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
              PageUtils.toDupNamed('/member?mid=$mid', off: off);
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
                  arguments: {
                    'oid': oid,
                    'rpid': rpid,
                    'type': ReplyType.video.index,
                    'id': queryParameters['comment_secondary_id'],
                  },
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
                    body: SafeArea(
                      top: false,
                      bottom: false,
                      child: VideoReplyReplyPanel(
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
                PageUtils.toVideoPage(
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
              PageUtils.toDupNamed('/liveRoom?roomid=$roomId', off: off);
              return true;
            }
            return false;
          case 'bangumi':
            // bilibili://bangumi/season/12345678?h5_awaken_params=random
            if (path.startsWith('/season')) {
              String? seasonId = uriDigitRegExp.firstMatch(path)?.group(1);
              if (seasonId != null) {
                PageUtils.viewBangumi(seasonId: seasonId, epId: null);
                return true;
              }
            }
            return false;
          case 'opus':
            bool hasMatch = await _onPushDynDetail(path, off);
            return hasMatch;
          case 'search':
            final keyword = uri.queryParameters['keyword'];
            if (keyword != null) {
              PageUtils.toDupNamed(
                '/searchResult',
                parameters: {'keyword': keyword},
                off: off,
              );
              return true;
            }
            return false;
          case 'article':
            // bilibili://article/40679479?jump_opus=1&jump_opus_type=1&opus_type=article&h5awaken=random
            String? id = uriDigitRegExp.firstMatch(path)?.group(1);
            if (id != null) {
              PageUtils.toDupNamed(
                '/articlePage',
                parameters: {
                  'id': id,
                  'type': 'read',
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
              Map<String, String> queryParameters = uri.queryParameters;
              int type = int.parse(pathSegments[1]); // business_id
              int oid = int.parse(pathSegments[2]); // subject_id
              int rootId = int.parse(pathSegments[3]); // root_id // target_id
              int? rpId = queryParameters['anchor'] != null // source_id
                  ? int.tryParse(queryParameters['anchor']!)
                  : null;
              // int subType = int.parse(queryParameters['subType'] ?? '0');
              // int extraIntentId =
              // int.parse(queryParameters['extraIntentId'] ?? '0');
              Get.to(
                arguments: {
                  'oid': oid,
                  'rpid': rootId,
                  'id': rpId,
                  'type': type,
                  'enterUri': queryParameters['enterUri'],
                },
                () => Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: const Text('评论详情'),
                    actions: [
                      IconButton(
                        tooltip: '前往',
                        onPressed: () {
                          String? enterUri = queryParameters['enterUri'];
                          if (enterUri != null) {
                            routePush(Uri.parse(enterUri));
                          } else {
                            routePush(
                                Uri.parse('bilibili://following/detail/$oid'));
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    top: false,
                    bottom: false,
                    child: VideoReplyReplyPanel(
                      oid: oid,
                      rpid: rootId,
                      id: rpId,
                      source: 'routePush',
                      replyType: ReplyType.values[type],
                      firstFloor: null,
                    ),
                  ),
                ),
              );
              return true;
            } else if (path.startsWith("/msg_fold/")) {
              // bilibili://comment/msg_fold/1/22222/33333/11111/?enterUri=bilibili://video/22222 //(aid)
              // bilibili://comment/msg_fold/11/22222/33333/11111/?enterUri=bilibili://following/detail/44444 (dynId)
              List<String> pathSegments = uri.pathSegments;
              int type = int.parse(pathSegments[1]); // business_id
              int oid = int.parse(pathSegments[2]); // subject_id
              int rpId = int.parse(pathSegments[3]); // source_id
              Get.to(
                arguments: {
                  'oid': oid,
                  'rpid': rpId,
                  'type': type,
                },
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
                            routePush(Uri.parse(enterUri), businessId: type);
                          } else {
                            routePush(
                              Uri.parse('bilibili://following/detail/$oid'),
                              businessId: type,
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    top: false,
                    bottom: false,
                    child: VideoReplyReplyPanel(
                      oid: oid,
                      rpid: rpId,
                      source: 'routePush',
                      replyType: ReplyType.values[type],
                      firstFloor: null,
                    ),
                  ),
                ),
              );
              return true;
            }

            return false;
          case 'following':
            // businessId == 17 => dynId == oid
            // bilibili://following/detail/832703053858603029 (dynId)
            // bilibili://following/detail/12345678?comment_root_id=654321\u0026comment_on=1
            String? cvid = RegExp(r'^/detail/cv(\d+)', caseSensitive: false)
                .firstMatch(path)
                ?.group(1);
            if (cvid != null) {
              PageUtils.toDupNamed(
                '/articlePage',
                parameters: {
                  'id': cvid,
                  'type': 'read',
                },
                off: off,
              );
              return true;
            }
            if ((oid != null || businessId == 17) &&
                path.startsWith("/detail/")) {
              final queryParameters = uri.queryParameters;
              final commentRootId = queryParameters['comment_root_id'];
              if (commentRootId != null) {
                String? dynId = uriDigitRegExp.firstMatch(path)?.group(1);
                int? rpid = int.tryParse(commentRootId);
                if (dynId != null && rpid != null) {
                  Get.to(
                    arguments: {
                      'oid': oid ?? dynId,
                      'rpid': rpid,
                      'type': businessId ?? ReplyType.dynamics.index,
                      'id': queryParameters['comment_secondary_id'],
                    },
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
                      body: SafeArea(
                        top: false,
                        bottom: false,
                        child: VideoReplyReplyPanel(
                          oid: oid ?? int.parse(dynId),
                          rpid: rpid,
                          source: 'routePush',
                          replyType: businessId != null
                              ? ReplyType.values[businessId]
                              : ReplyType.dynamics,
                          firstFloor: null,
                          id: queryParameters['comment_secondary_id'] != null
                              ? int.tryParse(
                                  queryParameters['comment_secondary_id']!)
                              : null,
                        ),
                      ),
                    ),
                  );
                }
                return true;
              } else {
                bool hasMatch = await _onPushDynDetail(path, off);
                return hasMatch;
              }
            } else {
              bool hasMatch = await _onPushDynDetail(path, off);
              return hasMatch;
            }
          case 'album':
            String? rid = uriDigitRegExp.firstMatch(path)?.group(1);
            if (rid != null) {
              PageUtils.pushDynFromId(rid: rid, off: off);
              return true;
            }
            return false;
          case 'medialist':
            String? mediaId = uriDigitRegExp.firstMatch(path)?.group(1);
            if (mediaId != null) {
              PageUtils.toDupNamed(
                '/favDetail',
                parameters: {
                  'mediaId': mediaId,
                  'heroTag': Utils.makeHeroTag(mediaId),
                },
                off: off,
              );
              return true;
            }
            return false;
          // bilibili://browser/?url=https%3A%2F%2Fwww.bilibili.com%2F
          case 'browser':
            final url = uri.queryParameters['url'];
            if (url != null) {
              _toWebview(url, off, parameters);
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
        return await _fullPathPush(
          uri,
          selfHandle: selfHandle,
          off: off,
          parameters: parameters,
        );
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
    Map? parameters,
  }) async {
    // https://m.bilibili.com/bangumi/play/ss39708
    // https | m.bilibili.com | /bangumi/play/ss39708

    String host = uri.host;

    if (selfHandle &&
        host.contains('bilibili.com').not &&
        host.contains('b23.tv').not) {
      return false;
    }

    void launchURL() {
      if (selfHandle.not) {
        _toWebview(uri.toString(), off, parameters);
      }
    }

    // b23.tv
    // bilibili.com
    // m.bilibili.com
    // www.bilibili.com
    // space.bilibili.com
    // live.bilibili.com
    // search.bilibili.com

    // redirect
    if (host.contains('b23.tv')) {
      String? redirectUrl = await UrlUtils.parseRedirectUrl(uri.toString());
      if (redirectUrl != null) {
        uri = Uri.parse(redirectUrl);
        host = uri.host;
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
        PageUtils.toDupNamed('/liveRoom?roomid=$roomId', off: off);
        return true;
      }
      launchURL();
      return false;
    }

    if (host.contains('space.bilibili.com')) {
      String? mid = uriDigitRegExp.firstMatch(path)?.group(1);
      if (mid != null) {
        PageUtils.toDupNamed('/member?mid=$mid', off: off);
        return true;
      }
      launchURL();
      return false;
    }

    if (host.contains('search.bilibili.com')) {
      String? keyword = uri.queryParameters['keyword'];
      if (keyword != null) {
        PageUtils.toDupNamed(
          '/searchResult',
          parameters: {'keyword': keyword},
          off: off,
        );
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
    debugPrint('area: $area');
    switch (area) {
      case 'h5':
        if (path.startsWith('/h5/note')) {
          String? id = RegExp(r'cvid=(\d+)', caseSensitive: false)
              .firstMatch(uri.query)
              ?.group(1);
          if (id != null) {
            PageUtils.toDupNamed(
              '/articlePage',
              parameters: {
                'id': id,
                'type': 'read',
              },
              off: off,
            );
            return true;
          }
        }
        launchURL();
        return false;
      case 'dynamic' || 'opus':
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
          PageUtils.viewBangumi(
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
          PageUtils.toDupNamed(
            '/articlePage',
            parameters: {
              'id': id,
              'type': 'read',
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
          PageUtils.toDupNamed(
            '/member?mid=$mid',
            off: off,
          );
          return true;
        }
        launchURL();
        return false;
      case 'medialist':
        String? mediaId = RegExp(r'/ml(\d+)').firstMatch(path)?.group(1);
        if (mediaId != null) {
          PageUtils.toDupNamed(
            '/favDetail',
            parameters: {
              'mediaId': mediaId,
              'heroTag': Utils.makeHeroTag(mediaId),
            },
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
      PageUtils.pushDynFromId(id: id, off: off);
      return true;
    }
    return false;
  }

  static void _toWebview(
    String url,
    bool off,
    Map? parameters,
  ) {
    PageUtils.toDupNamed(
      '/webview',
      parameters: {
        'url': url,
        if (parameters != null) ...parameters,
      },
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
      PageUtils.toVideoPage(
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

import 'dart:async';

import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/fav_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/pages/live/view.dart';
import 'package:PiliPlus/pages/rank/view.dart';
import 'package:PiliPlus/pages/subscription_detail/view.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PiliScheme {
  static late AppLinks appLinks;
  static StreamSubscription? listener;
  static final uriDigitRegExp = RegExp(r'/(\d+)');
  static final _prefixRegex = RegExp(r'^\S+://');

  static void init() {
    // Register our protocol only on Windows platform
    // registerProtocolHandler('bilibili');
    appLinks = AppLinks();

    listener?.cancel();
    listener = appLinks.uriLinkStream.listen(routePush);
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
      } else if (!_prefixRegex.hasMatch(url)) {
        url = 'https://$url';
      }
      return routePush(
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
    // if (kDebugMode) debugPrint('onAppLink: $uri');

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
              PageUtils.viewPgc(
                seasonId: isEp ? null : id,
                epId: isEp ? id : null,
                progress: uri.queryParameters['start_progress'],
              );
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
              String? commentSecondaryId =
                  queryParameters['comment_secondary_id'];
              if (oid != null && rpid != null) {
                Get.to(
                  arguments: {
                    'oid': oid,
                    'rpid': rpid,
                    'type': 1,
                    'id': commentSecondaryId,
                  },
                  () => Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: const Text('评论详情'),
                      actions: [
                        IconButton(
                          tooltip: '前往原视频',
                          onPressed: () {
                            String? enterUri = uri
                                .toString()
                                .split('?')
                                .first; // to check
                            routePush(Uri.parse(enterUri));
                          },
                          icon: const Icon(Icons.open_in_new),
                        ),
                      ],
                    ),
                    body: ViewSafeArea(
                      child: VideoReplyReplyPanel(
                        enableSlide: false,
                        oid: int.parse(oid),
                        rpid: rpid,
                        isVideoDetail: false,
                        replyType: 1,
                        firstFloor: null,
                        id: commentSecondaryId != null
                            ? int.tryParse(commentSecondaryId)
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
            String? bvid = IdUtils.bvRegex.firstMatch(path)?.group(0);
            if (aid != null || bvid != null) {
              final cid = queryParameters['cid'];
              if (cid != null) {
                bvid ??= IdUtils.av2bv(int.parse(aid!));
                final progress = queryParameters['dm_progress'];
                PageUtils.toVideoPage(
                  bvid: bvid,
                  cid: int.parse(cid),
                  progress: progress == null ? null : int.parse(progress),
                  off: off,
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
              PageUtils.toLiveRoom(int.parse(roomId), off: off);
              return true;
            }
            return false;
          case 'bangumi':
            // bilibili://bangumi/season/12345678?h5_awaken_params=random
            if (path.startsWith('/season')) {
              String? seasonId = uriDigitRegExp.firstMatch(path)?.group(1);
              if (seasonId != null) {
                PageUtils.viewPgc(seasonId: seasonId, epId: null);
                return true;
              }
            }
            return false;
          case 'opus':
            bool hasMatch = _onPushDynDetail(uri, off);
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
            Get.toNamed('/search');
            return true;
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
              int? rpId =
                  queryParameters['anchor'] !=
                      null // source_id
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
                              Uri.parse('bilibili://following/detail/$oid'),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                      ),
                    ],
                  ),
                  body: ViewSafeArea(
                    child: VideoReplyReplyPanel(
                      enableSlide: false,
                      oid: oid,
                      rpid: rootId,
                      id: rpId,
                      isVideoDetail: false,
                      replyType: type,
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
                  body: ViewSafeArea(
                    child: VideoReplyReplyPanel(
                      enableSlide: false,
                      oid: oid,
                      rpid: rpId,
                      isVideoDetail: false,
                      replyType: type,
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
            String? cvid = RegExp(
              r'^/detail/cv(\d+)',
              caseSensitive: false,
            ).matchAsPrefix(path)?.group(1);
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
                final commentSecondaryId =
                    queryParameters['comment_secondary_id'];
                if (dynId != null && rpid != null) {
                  Get.to(
                    arguments: {
                      'oid': oid ?? dynId,
                      'rpid': rpid,
                      'type': businessId ?? 17,
                      'id': commentSecondaryId,
                    },
                    () => Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: AppBar(
                        title: const Text('评论详情'),
                        actions: [
                          IconButton(
                            tooltip: '前往',
                            onPressed: () => _onPushDynDetail(uri, off),
                            icon: const Icon(Icons.open_in_new),
                          ),
                        ],
                      ),
                      body: ViewSafeArea(
                        child: VideoReplyReplyPanel(
                          enableSlide: false,
                          oid: oid ?? int.parse(dynId),
                          rpid: rpid,
                          isVideoDetail: false,
                          replyType: businessId ?? 17,
                          firstFloor: null,
                          id: commentSecondaryId != null
                              ? int.tryParse(commentSecondaryId)
                              : null,
                        ),
                      ),
                    ),
                  );
                }
                return true;
              } else {
                bool hasMatch = _onPushDynDetail(uri, off);
                return hasMatch;
              }
            } else {
              bool hasMatch = _onPushDynDetail(uri, off);
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
            if (selfHandle) return false;
            final url = uri.queryParameters['url'];
            if (url != null) {
              _toWebview(url, off, parameters);
              return true;
            }
            return false;
          case 'm.bilibili.com':
            // bilibili://m.bilibili.com/topic-detail?topic_id=1028161&frommodule=H5&h5awaken=xxx
            final id = uri.queryParameters['topic_id'];
            if (id != null) {
              PageUtils.toDupNamed(
                '/dynTopic',
                parameters: {'id': id},
                off: off,
              );
              return true;
            }
            return false;
          case 'cheese':
            // bilibili://cheese/season/123456
            String? seasonId = uriDigitRegExp.firstMatch(path)?.group(1);
            if (seasonId != null) {
              PageUtils.viewPugv(seasonId: seasonId);
              return true;
            }
            return false;
          case 'history':
            Get.toNamed('/history');
            return true;
          case 'main':
            if (path.startsWith('/favorite')) {
              final tab = uri.queryParameters['tab'];
              int index = 0;
              if (tab != null) {
                try {
                  index = FavTabType.values.byName(tab).index;
                } catch (e) {
                  if (kDebugMode) print('favorite jump: $e');
                }
              }
              Get.toNamed('/fav', arguments: index);
              return true;
            }
            return false;
          case 'livearea':
            Get.to(
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(title: const Text('直播')),
                body: const ViewSafeArea(child: LivePage()),
              ),
            );
            return true;
          case 'rank':
            Get.to(
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(title: const Text('排行榜')),
                body: const ViewSafeArea(child: RankPage()),
              ),
            );
            return true;
          case 'login':
            Get.toNamed('/loginPage');
            return true;
          case 'music':
            if (path.startsWith('/playlist/')) {
              final mediaId = uriDigitRegExp.firstMatch(path)?.group(1);
              if (mediaId != null) {
                Get.toNamed(
                  '/favDetail',
                  parameters: {
                    'mediaId': mediaId,
                    'heroTag': Utils.makeHeroTag(mediaId),
                  },
                );
                return true;
              }
            }
            return false;
          default:
            if (!selfHandle) {
              // if (kDebugMode) debugPrint('$uri');
              SmartDialog.showToast('未知路径:$uri，请截图反馈给开发者');
            }
            return false;
        }
      case 'http' || 'https':
        return _fullPathPush(
          uri,
          selfHandle: selfHandle,
          off: off,
          parameters: parameters,
        );
      default:
        String? aid = IdUtils.avRegexExact.matchAsPrefix(path)?.group(1);
        String? bvid = IdUtils.bvRegexExact.matchAsPrefix(path)?.group(0);
        if (aid != null || bvid != null) {
          videoPush(
            aid != null ? int.parse(aid) : null,
            bvid,
            off: off,
          );
          return true;
        }
        if (!selfHandle) {
          // if (kDebugMode) debugPrint('$uri');
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
        !host.contains('bilibili.com') &&
        !host.contains('b23.tv')) {
      return false;
    }

    void launchURL() {
      if (!selfHandle) {
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
      if (!host.contains('bilibili.com')) {
        launchURL();
        return false;
      }
    }

    final String path = uri.path;

    if (host.contains('t.bilibili.com')) {
      bool hasMatch = _onPushDynDetail(uri, off);
      if (!hasMatch) {
        launchURL();
      }
      return hasMatch;
    } else if (host.contains('live.bilibili.com')) {
      String? roomId = uriDigitRegExp.firstMatch(path)?.group(1);
      if (roomId != null) {
        PageUtils.toLiveRoom(int.parse(roomId), off: off);
        return true;
      }
      launchURL();
      return false;
    } else if (host.contains('space.bilibili.com')) {
      String? sid =
          uri.queryParameters['sid'] ??
          RegExp(r'lists/(\d+)').firstMatch(path)?.group(1);
      if (sid != null) {
        SubDetailPage.toSubDetailPage(int.parse(sid));
        return true;
      }
      String? mid = uriDigitRegExp.firstMatch(path)?.group(1);
      if (mid != null) {
        PageUtils.toDupNamed('/member?mid=$mid', off: off);
        return true;
      }
      launchURL();
      return false;
    } else if (host.contains('search.bilibili.com')) {
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
    } else if (host.contains('music.bilibili.com')) {
      // music.bilibili.com/pc/music-detail?music_id=MA***
      // music.bilibili.com/h5-music-detail?music_id=MA***
      if (path.contains('music-detail')) {
        final musicId = uri.queryParameters['music_id'];
        if (musicId != null && musicId.startsWith('MA')) {
          PageUtils.toDupNamed(
            '/musicDetail',
            parameters: {'musicId': musicId},
          );
          return true;
        }
        launchURL();
      }
    }

    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) {
      launchURL();
      return false;
    }
    final first = pathSegments.first;
    final String? area = const ['mobile', 'h5', 'v'].contains(first)
        ? pathSegments.getOrNull(1)
        : first;
    // if (kDebugMode) debugPrint('area: $area');
    switch (area) {
      case 'note' || 'note-app':
        String? id = uri.queryParameters['cvid'];
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
      case 'dynamic' || 'opus':
        bool hasMatch = _onPushDynDetail(uri, off);
        if (!hasMatch) {
          launchURL();
        }
        return hasMatch;
      case 'playlist':
        // http://m.bilibili.com/playlist/pl12345678?bvid=BVxxxxxxxx&page_type=4
        String? mediaId = RegExp(
          r'/pl(\d+)',
          caseSensitive: false,
        ).firstMatch(path)?.group(1);
        String? bvid =
            uri.queryParameters['bvid'] ??
            IdUtils.bvRegex.firstMatch(path)?.group(0);
        if (bvid != null) {
          if (mediaId != null) {
            final int? cid = await SearchHttp.ab2c(bvid: bvid);
            if (cid != null) {
              PageUtils.toVideoPage(
                bvid: bvid,
                cid: cid,
                extraArguments: {
                  'sourceType': SourceType.playlist,
                  'favTitle': '播放列表',
                  'mediaId': mediaId,
                  'desc': true,
                  'isContinuePlaying': true,
                },
              );
            }
          } else {
            videoPush(null, bvid, off: off);
          }
          return true;
        }
        launchURL();
        return false;
      case 'bangumi':
        // www.bilibili.com/bangumi/play/ep{eid}?start_progress={offset}&thumb_up_dm_id={dmid}
        // if (kDebugMode) debugPrint('番剧');
        bool hasMatch = PageUtils.viewPgcFromUri(
          path,
          progress: uri.queryParameters['start_progress'],
        );
        if (hasMatch) {
          return true;
        }
        launchURL();
        return false;
      case 'video':
        // if (kDebugMode) debugPrint('投稿');
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
        if (path.contains('readlist')) {
          String? id = RegExp(
            r'/rl(\d+)',
            caseSensitive: false,
          ).firstMatch(path)?.group(1);
          if (id != null) {
            PageUtils.toDupNamed(
              '/articleList',
              parameters: {'id': id},
              off: off,
            );
            return true;
          }
          launchURL();
          return false;
        }
        // if (kDebugMode) debugPrint('专栏');
        String? id = RegExp(
          r'cv(\d+)',
          caseSensitive: false,
        ).firstMatch(path)?.group(1);
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
        // if (kDebugMode) debugPrint('个人空间');
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
      case 'topic' || 'topic-detail':
        String? id = uri.queryParameters['topic_id'];
        if (id != null) {
          PageUtils.toDupNamed(
            '/dynTopic',
            parameters: {'id': id},
            off: off,
          );
          return true;
        }
        launchURL();
        return false;
      case 'comment':
        // https://www.bilibili.com/h5/comment/sub?oid=123456&pageType=1&root=87654321
        final queryParameters = uri.queryParameters;
        String? oid = queryParameters['oid'];
        String? root = queryParameters['root'];
        String? pageType = queryParameters['pageType'];
        if (oid != null && root != null && pageType != null) {
          String? commentSecondaryId = queryParameters['comment_secondary_id'];
          Get.to(
            arguments: {
              'oid': oid,
              'rpid': root,
              'type': pageType,
              'id': commentSecondaryId,
            },
            () => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('评论详情'),
                actions: pageType == '1'
                    ? [
                        IconButton(
                          tooltip: '前往',
                          onPressed: () {
                            videoPush(int.parse(oid), null);
                          },
                          icon: const Icon(Icons.open_in_new),
                        ),
                      ]
                    : null,
              ),
              body: ViewSafeArea(
                child: VideoReplyReplyPanel(
                  enableSlide: false,
                  oid: int.parse(oid),
                  rpid: int.parse(root),
                  isVideoDetail: false,
                  replyType: int.parse(pageType),
                  firstFloor: null,
                  id: commentSecondaryId != null
                      ? int.tryParse(commentSecondaryId)
                      : null,
                ),
              ),
            ),
          );
          return true;
        }
        launchURL();
        return false;
      case 'match' || 'game':
        if (path.contains('match/data/detail') ||
            path.contains('match/singledata')) {
          String? cid = uriDigitRegExp.firstMatch(path)?.group(1);
          if (cid != null) {
            PageUtils.toDupNamed(
              '/matchInfo',
              parameters: {'cid': cid},
              off: off,
            );
            return true;
          }
        }
        launchURL();
        return false;
      case 'cheese':
        // https://www.bilibili.com/cheese/play/ss123456
        bool hasMatch = PageUtils.viewPgcFromUri(path, isPgc: false);
        if (hasMatch) {
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

  static bool _onPushDynDetail(Uri uri, bool off) {
    String? id = uriDigitRegExp.firstMatch(uri.path)?.group(1);
    bool isRid = uri.queryParameters['type'] == '2';
    if (id != null) {
      PageUtils.pushDynFromId(
        id: isRid ? null : id,
        rid: isRid ? id : null,
        off: off,
      );
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
        ...?parameters,
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
      final int? cid = await SearchHttp.ab2c(
        bvid: bvid,
        aid: aid,
        part: part != null ? int.tryParse(part) : null,
      );
      if (showDialog) {
        SmartDialog.dismiss();
      }
      if (cid != null) {
        PageUtils.toVideoPage(
          aid: aid,
          bvid: bvid,
          cid: cid,
          progress: progress == null ? null : int.parse(progress),
          off: off,
        );
      }
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('video获取失败: $e');
    }
  }
}

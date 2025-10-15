import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/space/space/card.dart';
import 'package:PiliPlus/models_new/space/space/followings_followed_upper.dart';
import 'package:PiliPlus/models_new/space/space/images.dart';
import 'package:PiliPlus/models_new/space/space/live.dart';
import 'package:PiliPlus/models_new/space/space/pr_info.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.isOwner,
    required this.card,
    required this.images,
    required this.relation,
    required this.onFollow,
    this.live,
    this.silence,
  });

  final bool isOwner;
  final int relation;
  final SpaceCard card;
  final SpaceImages images;
  final VoidCallback onFollow;
  final Live? live;
  final int? silence;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = colorScheme.isLight;
    final isPortrait = context.width < 600;
    return ViewSafeArea(
      top: !isPortrait,
      child: isPortrait
          ? _buildV(context, colorScheme, isLight)
          : _buildH(colorScheme, isLight),
    );
  }

  Widget _countWidget({
    required ColorScheme colorScheme,
    required String title,
    required int? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            NumUtils.numFormat(count),
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            title,
            style: TextStyle(
              height: 1.2,
              fontSize: 12,
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, bool isLight) {
    String imgUrl =
        (isLight
                ? images.imgUrl
                : images.nightImgurl.isNullOrEmpty
                ? images.imgUrl
                : images.nightImgurl)
            .http2https;
    return Hero(
      tag: imgUrl,
      child: GestureDetector(
        onTap: () => PageUtils.imageView(imgList: [SourceModel(url: imgUrl)]),
        child: CachedNetworkImage(
          imageUrl: ImageUtils.thumbnailUrl(imgUrl),
          width: double.infinity,
          height: 135,
          imageBuilder: (context, imageProvider) => DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isLight ? const Color(0x5DFFFFFF) : const Color(0x8D000000),
                  isLight ? BlendMode.lighten : BlendMode.darken,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLeft(ColorScheme colorScheme, bool isLight) => [
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Utils.copyText(card.name!),
            child: Text(
              card.name!,
              strutStyle: const StrutStyle(
                height: 1,
                leading: 0,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              style: TextStyle(
                height: 1,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: (card.vip?.status ?? -1) > 0 && card.vip?.type == 2
                    ? colorScheme.vipColor
                    : null,
              ),
            ),
          ),
          Image.asset(
            'assets/images/lv/lv${card.levelInfo?.identity == 2 ? '6_s' : card.levelInfo?.currentLevel}.png',
            height: 11,
            semanticLabel: '等级${card.levelInfo?.currentLevel}',
          ),
          if (card.vip?.status == 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: StyleString.mdRadius,
                color: colorScheme.vipColor,
              ),
              child: Text(
                card.vip?.label?.text ?? '大会员',
                strutStyle: const StrutStyle(
                  height: 1,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                style: const TextStyle(
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          if (card.nameplate?.imageSmall?.isNotEmpty == true)
            CachedNetworkImage(
              imageUrl: ImageUtils.thumbnailUrl(card.nameplate!.imageSmall!),
              height: 20,
              placeholder: (context, url) {
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    ),
    if (card.officialVerify?.desc?.isNotEmpty == true)
      Container(
        margin: const EdgeInsets.only(left: 20, top: 8, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: colorScheme.onInverseSurface,
        ),
        child: Text.rich(
          TextSpan(
            children: [
              if (card.officialVerify?.icon?.isNotEmpty == true) ...[
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surface,
                    ),
                    child: Icon(
                      Icons.offline_bolt,
                      color: card.officialVerify?.type == 0
                          ? const Color(0xFFFFCC00)
                          : Colors.lightBlueAccent,
                      size: 18,
                    ),
                  ),
                ),
                const TextSpan(
                  text: ' ',
                ),
              ],
              TextSpan(
                text: card.officialVerify!.spliceTitle!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    if (card.sign?.isNotEmpty == true)
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 6, right: 20),
        child: SelectableText(
          card.sign!.trim().replaceAll(RegExp(r'\n{2,}'), '\n'),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    if (card.followingsFollowedUpper?.items?.isNotEmpty == true) ...[
      const SizedBox(height: 6),
      _buildFollowedUp(colorScheme, card.followingsFollowedUpper!),
    ],
    Padding(
      padding: const EdgeInsets.only(left: 20, top: 6, right: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Utils.copyText(card.mid.toString()),
            child: Text(
              'UID: ${card.mid}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.outline,
              ),
            ),
          ),
          ...?card.spaceTag?.map(
            (item) {
              final hasUri = item.uri?.isNotEmpty == true;
              final child = Text(
                item.title ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: hasUri ? colorScheme.secondary : colorScheme.outline,
                ),
              );
              if (hasUri) {
                return GestureDetector(
                  onTap: () => PiliScheme.routePushFromUrl(item.uri!),
                  child: child,
                );
              }
              return child;
            },
          ),
        ],
      ),
    ),
    if (silence == 1)
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: isLight ? colorScheme.errorContainer : colorScheme.error,
        ),
        margin: const EdgeInsets.only(left: 20, top: 8, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.info,
                  size: 17,
                  color: isLight
                      ? colorScheme.onErrorContainer
                      : colorScheme.onError,
                ),
              ),
              TextSpan(
                text: ' 该账号封禁中',
                style: TextStyle(
                  color: isLight
                      ? colorScheme.onErrorContainer
                      : colorScheme.onError,
                ),
              ),
            ],
          ),
        ),
      ),
  ];

  Column _buildRight(ColorScheme colorScheme) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: List.generate(
          5,
          (index) => index.isEven
              ? _countWidget(
                  colorScheme: colorScheme,
                  title: ['粉丝', '关注', '获赞'][index ~/ 2],
                  count: index == 0
                      ? card.fans
                      : index == 2
                      ? card.attention
                      : card.likes?.likeNum,
                  onTap: () {
                    if (index == 0) {
                      Get.toNamed('/fan?mid=${card.mid}&name=${card.name}');
                    } else if (index == 2) {
                      Get.toNamed('/follow?mid=${card.mid}&name=${card.name}');
                    }
                  },
                )
              : const Expanded(
                  child: SizedBox(
                    height: 15,
                    width: 1,
                    child: VerticalDivider(),
                  ),
                ),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isOwner)
            IconButton.outlined(
              onPressed: () {
                if (Accounts.main.isLogin) {
                  int mid = int.parse(card.mid!);
                  Get.toNamed(
                    '/whisperDetail',
                    arguments: {
                      'talkerId': mid,
                      'name': card.name,
                      'face': card.face,
                      'mid': mid,
                      'isLive': live?.liveStatus == 1,
                    },
                  );
                }
              },
              icon: const Icon(Icons.mail_outline, size: 21),
              style: IconButton.styleFrom(
                side: BorderSide(
                  width: 1.0,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          Expanded(
            child: FilledButton.tonal(
              onPressed: onFollow,
              style: FilledButton.styleFrom(
                backgroundColor: relation != 0
                    ? colorScheme.onInverseSurface
                    : null,
                visualDensity: const VisualDensity(vertical: -1.8),
              ),
              child: Text.rich(
                style: TextStyle(
                  color: relation != 0 ? colorScheme.outline : null,
                ),
                TextSpan(
                  children: [
                    if (relation != 0 && relation != 128) ...[
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.sort,
                          size: 16,
                          color: colorScheme.outline,
                        ),
                      ),
                      const TextSpan(text: ' '),
                    ],
                    TextSpan(
                      text: isOwner
                          ? '编辑资料'
                          : switch (relation) {
                              0 => '关注',
                              1 => '悄悄关注',
                              2 => '已关注',
                              // 3 => '回关',
                              4 || 6 => '已互关',
                              128 => '移除黑名单',
                              -10 => '特别关注', // 该状态码并不是官方状态码
                              _ => relation.toString(),
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  Widget get _buildAvatar => Hero(
    tag: card.face ?? '',
    child: PendantAvatar(
      avatar: card.face,
      size: 80,
      badgeSize: 20,
      officialType: card.officialVerify?.type,
      isVip: (card.vip?.status ?? -1) > 0,
      garbPendantImage: card.pendant!.image!,
      roomId: live?.liveStatus == 1 ? live!.roomid : null,
      onTap: () => PageUtils.imageView(
        imgList: [SourceModel(url: card.face.http2https)],
      ),
    ),
  );

  Column _buildV(BuildContext context, ColorScheme colorScheme, bool isLight) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(colorScheme, isLight),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.textScalerOf(context).scale(30) + 60,
                  ),
                ],
              ),
              Positioned(
                top: 110,
                left: 20,
                child: _buildAvatar,
              ),
              Positioned(
                left: 160,
                top: 140,
                right: 15,
                bottom: 0,
                child: _buildRight(colorScheme),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ..._buildLeft(colorScheme, isLight),
          if (card.prInfo?.content?.isNotEmpty == true)
            buildPrInfo(colorScheme, isLight, card.prInfo!),
          const SizedBox(height: 5),
        ],
      );

  Widget buildPrInfo(
    ColorScheme colorScheme,
    bool isLight,
    SpacePrInfo prInfo,
  ) {
    final textColor = Utils.parseColor(
      isLight ? prInfo.textColor : prInfo.textColorNight,
    );
    Widget child = Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Utils.parseColor(isLight ? prInfo.bgColor : prInfo.bgColorNight),
      child: Row(
        children: [
          if (!isLight && prInfo.iconNight?.isNotEmpty == true) ...[
            CachedNetworkImage(
              imageUrl: ImageUtils.thumbnailUrl(card.prInfo!.iconNight!),
              height: 20,
            ),
            const SizedBox(width: 16),
          ] else if (prInfo.icon?.isNotEmpty == true) ...[
            CachedNetworkImage(
              imageUrl: ImageUtils.thumbnailUrl(card.prInfo!.icon!),
              height: 20,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              card.prInfo!.content!,
              style: TextStyle(fontSize: 13, color: textColor),
            ),
          ),
          if (prInfo.url?.isNotEmpty == true) ...[
            const SizedBox(width: 10),
            Icon(
              Icons.keyboard_arrow_right,
              color: textColor,
            ),
          ],
        ],
      ),
    );
    if (prInfo.url?.isNotEmpty == true) {
      return GestureDetector(
        onTap: () => PageUtils.handleWebview(prInfo.url!),
        child: child,
      );
    }
    return child;
  }

  Column _buildH(ColorScheme colorScheme, bool isLight) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // _buildHeader(context),
      const SizedBox(height: 56),
      Row(
        children: [
          const SizedBox(width: 20),
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: card.prInfo?.content?.isNotEmpty == true ? 0 : 10,
            ),
            child: _buildAvatar,
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ..._buildLeft(colorScheme, isLight),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildRight(colorScheme),
          ),
          const SizedBox(width: 20),
        ],
      ),
      if (card.prInfo?.content?.isNotEmpty == true)
        buildPrInfo(colorScheme, isLight, card.prInfo!),
    ],
  );

  Widget _buildFollowedUp(
    ColorScheme colorScheme,
    FollowingsFollowedUpper item,
  ) {
    var list = item.items!;
    final flag = list.length > 3;
    if (flag) list = list.sublist(0, 3);
    final length = list.length;
    const size = 22.0;
    Widget avatar(String url) => NetworkImgLayer(
      src: url,
      width: size,
      height: size,
      type: ImageType.avatar,
    );
    Widget avatars;
    if (length == 1) {
      avatars = avatar(list.first.face!);
    } else {
      const gap = 4.0;
      const offset = size - gap;
      final decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.surface),
      );
      avatars = SizedBox(
        width: length * size - (length - 1) * gap,
        height: size + 1.6,
        child: Stack(
          clipBehavior: Clip.none,
          children: List.generate(
            length,
            (index) => Positioned(
              right: index * offset,
              child: DecoratedBox(
                decoration: decoration,
                child: Padding(
                  padding: const EdgeInsets.all(.8),
                  child: avatar(list[length - 1 - index].face!),
                ),
              ),
            ),
          ),
        ),
      );
    }
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 20),
        avatars,
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            list.map((e) => e.name).join('、'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          '${flag ? '等${item.items!.length}人' : ''}也关注了TA ',
          style: TextStyle(fontSize: 13, color: colorScheme.outline),
        ),
        Icon(
          Icons.keyboard_arrow_right,
          size: 20,
          color: colorScheme.outline,
        ),
        const SizedBox(width: 10),
      ],
    );
    return GestureDetector(
      onTap: () => Get.toNamed('/followed?mid=${card.mid}&name=${card.name}'),
      child: child,
    );
  }
}

import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart'
    show SourceModel;
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/space/card.dart' as space;
import 'package:PiliPlus/models/space/images.dart' as space;
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.isV,
    required this.isOwner,
    required this.card,
    required this.images,
    required this.relation,
    required this.onFollow,
    this.live,
    this.silence,
    this.endTime,
  });

  final bool isV;
  final bool isOwner;
  final int relation;
  final space.Card card;
  final space.Images images;
  final VoidCallback onFollow;
  final dynamic live;
  final int? silence;
  final String? endTime;

  @override
  Widget build(BuildContext context) {
    return isV ? _buildV(context) : _buildH(context);
  }

  Widget _countWidget({
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Utils.numFormat(count),
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              height: 1,
              fontSize: 11,
              color: Theme.of(Get.context!).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader(BuildContext context) {
    bool darken = Theme.of(context).brightness == Brightness.dark;
    String? imgUrl = darken
        ? (images.nightImgurl?.isEmpty == true
            ? images.imgUrl?.http2https
            : images.nightImgurl?.http2https)
        : images.imgUrl?.http2https;
    return Hero(
      tag: imgUrl ?? '',
      child: GestureDetector(
        onTap: () {
          context.imageView(
            imgList: [SourceModel(url: imgUrl ?? '')],
          );
        },
        child: CachedNetworkImage(
          imageUrl: imgUrl?.http2https ?? '',
          width: double.infinity,
          height: 135,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  darken ? const Color(0x8D000000) : const Color(0x5DFFFFFF),
                  darken ? BlendMode.darken : BlendMode.lighten,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildLeft(BuildContext context) => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FittedBox(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Utils.copyText(card.name ?? ''),
                  child: Text(
                    card.name ?? '',
                    style: TextStyle(
                      height: 1,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: (card.vip?.vipStatus ?? -1) > 0 &&
                              card.vip?.vipType == 2
                          ? context.vipColor
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/lv/lv${card.levelInfo?.identity == 2 ? '6_s' : card.levelInfo?.currentLevel}.png',
                  height: 11,
                  semanticLabel: '等级${card.levelInfo?.currentLevel}',
                ),
                if (card.vip?.vipStatus == 1) ...[
                  const SizedBox(width: 8),
                  Image.network(
                    card.vip!.label!.image!.http2https,
                    height: 20,
                  ),
                ],
                if (card.nameplate?.image?.isNotEmpty == true) ...[
                  const SizedBox(width: 8),
                  Image.network(
                    card.nameplate!.image!.http2https,
                    height: 20,
                  ),
                ],
                // GestureDetector(
                //   onTap: () {
                //     Utils.copyText(card.mid.toString());
                //   },
                //   child: Container(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).colorScheme.secondaryContainer,
                //       borderRadius: const BorderRadius.all(Radius.circular(12)),
                //     ),
                //     child: Text(
                //       'uid: ${card.mid}',
                //       style: TextStyle(
                //         height: 1,
                //         fontSize: 12,
                //         color: Theme.of(context).colorScheme.onSecondaryContainer,
                //       ),
                //       strutStyle: const StrutStyle(
                //         height: 1,
                //         leading: 0,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        if (card.officialVerify?.desc?.isNotEmpty == true)
          Container(
            margin: const EdgeInsets.only(left: 20, top: 8, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.onInverseSurface,
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
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: CachedNetworkImage(
                          width: 18,
                          height: 18,
                          imageUrl: card.officialVerify!.icon!.http2https,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                    )
                  ],
                  TextSpan(
                    text: card.officialVerify!.spliceTitle!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  )
                ],
              ),
            ),
          ),
        if (card.sign?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 6, right: 20),
            child: SelectableText(
              card.sign!.trim().replaceAll(RegExp(r'\n{2,}'), '\n'),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 6, right: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Utils.copyText(card.mid.toString());
                },
                child: Text(
                  'UID: ${card.mid}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              if (!card.spaceTag.isNullOrEmpty)
                ...card.spaceTag!.map(
                  (item) => Text(
                    item.title ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (silence == 1)
          Builder(builder: (context) {
            bool isLight = Theme.of(context).brightness == Brightness.light;
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isLight
                    ? Theme.of(context).colorScheme.errorContainer
                    : Theme.of(context).colorScheme.error,
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
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    TextSpan(
                      text: ' 该账号封禁中${endTime ?? ''}',
                      style: TextStyle(
                        color: isLight
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ];

  _buildRight(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              5,
              (index) => index % 2 == 0
                  ? _countWidget(
                      title: ['粉丝', '关注', '获赞'][index ~/ 2],
                      count: index == 0
                          ? card.fans
                          : index == 2
                              ? card.attention
                              : card.likes?.likeNum ?? 0,
                      onTap: () {
                        if (index == 0) {
                          Get.toNamed('/fan?mid=${card.mid}&name=${card.name}');
                        } else if (index == 2) {
                          Get.toNamed(
                              '/follow?mid=${card.mid}&name=${card.name}');
                        }
                      },
                    )
                  : SizedBox(
                      height: 15,
                      width: 1,
                      child: VerticalDivider(),
                    ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 20),
              if (!isOwner) ...[
                IconButton.outlined(
                  onPressed: () {
                    if (GStorage.userInfo.get('userInfoCache') != null) {
                      Get.toNamed(
                        '/whisperDetail',
                        parameters: {
                          'talkerId': card.mid ?? '',
                          'name': card.name ?? '',
                          'face': card.face ?? '',
                          'mid': card.mid ?? '',
                        },
                      );
                    }
                  },
                  icon: const Icon(Icons.mail_outline, size: 21),
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      width: 1.0,
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.5),
                    ),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: FilledButton.tonal(
                  onPressed: onFollow,
                  style: FilledButton.styleFrom(
                    backgroundColor: relation != 0
                        ? Theme.of(context).colorScheme.onInverseSurface
                        : null,
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                  ),
                  child: Text.rich(
                    style: TextStyle(
                      color: relation != 0
                          ? Theme.of(context).colorScheme.outline
                          : null,
                    ),
                    TextSpan(
                      children: [
                        if (relation != 0 && relation != 128)
                          WidgetSpan(
                            alignment: PlaceholderAlignment.top,
                            child: Icon(
                              Icons.sort,
                              size: 16,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        TextSpan(
                            text: isOwner
                                ? '编辑资料'
                                : switch (relation) {
                                    0 => '关注',
                                    1 => '悄悄关注',
                                    2 => '已关注',
                                    6 => '已互关',
                                    128 => '移除黑名单',
                                    -10 => '特别关注', // 该状态码并不是官方状态码
                                    _ => relation.toString(),
                                  }),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      );

  _buildBadge(BuildContext context) => IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
          ),
          child: card.officialVerify?.icon?.isNotEmpty == true
              ? CachedNetworkImage(
                  imageUrl: card.officialVerify!.icon!.http2https,
                  width: 22,
                  height: 22,
                )
              : Image.asset(
                  'assets/images/big-vip.png',
                  width: 22,
                  height: 22,
                ),
        ),
      );

  _buildAvatar(BuildContext context) => Hero(
        tag: card.face ?? '',
        child: GestureDetector(
          onTap: () {
            context.imageView(
              imgList: [SourceModel(url: card.face ?? '')],
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.5,
                color: Theme.of(context).colorScheme.surface,
              ),
              shape: BoxShape.circle,
            ),
            child: NetworkImgLayer(
              src: card.face,
              type: 'avatar',
              width: 80,
              height: 80,
            ),
          ),
        ),
      );

  _buildV(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const SizedBox(width: double.infinity, height: 85)
                ],
              ),
              Positioned(
                top: 110,
                left: 20,
                child: _buildAvatar(context),
              ),
              if (ModuleAuthorModel.showDynDecorate &&
                  card.pendant?.image?.isNotEmpty == true)
                Positioned(
                  top: 82.5,
                  left: -7.5,
                  child: IgnorePointer(
                    child: CachedNetworkImage(
                      width: 140,
                      height: 140,
                      imageUrl: card.pendant!.image!,
                    ),
                  ),
                ),
              if (card.officialVerify?.icon?.isNotEmpty == true ||
                  (card.vip?.vipStatus ?? -1) > 0)
                Positioned(
                  top: 172,
                  left: 82,
                  child: _buildBadge(context),
                ),
              if (live is Map && ((live['liveStatus'] as int?) ?? 0) == 1)
                Positioned(
                  top: 180,
                  left: 20,
                  child: _buildLiveBadge(context),
                ),
              Positioned(
                left: 120,
                top: 140,
                right: 20,
                bottom: 0,
                child: LayoutBuilder(
                  builder: (_, constraints) => FittedBox(
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: _buildRight(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ..._buildLeft(context),
          if (card.prInfo?.content?.isNotEmpty == true) buildPrInfo,
          const SizedBox(height: 5),
        ],
      );

  Widget get buildPrInfo => Builder(builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark
            ? Color(int.parse('FF${card.prInfo?.textColorNight?.substring(1)}',
                radix: 16))
            : Color(int.parse('FF${card.prInfo?.textColor?.substring(1)}',
                radix: 16));
        return GestureDetector(
          onTap: () {
            if (card.prInfo?.url?.isNotEmpty == true) {
              Utils.handleWebview(card.prInfo!.url!);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDark
                ? Color(int.parse(
                    'FF${card.prInfo?.bgColorNight?.substring(1)}',
                    radix: 16))
                : Color(int.parse('FF${card.prInfo?.bgColor?.substring(1)}',
                    radix: 16)),
            child: Row(
              children: [
                if (isDark && card.prInfo?.iconNight?.isNotEmpty == true) ...[
                  CachedNetworkImage(
                    imageUrl: card.prInfo!.iconNight!,
                    height: 20,
                  ),
                  const SizedBox(width: 16),
                ] else if (card.prInfo?.icon?.isNotEmpty == true) ...[
                  CachedNetworkImage(
                    imageUrl: card.prInfo!.icon!,
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
                if (card.prInfo?.url?.isNotEmpty == true) ...[
                  const SizedBox(width: 10),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: textColor,
                  ),
                ],
              ],
            ),
          ),
        );
      });

  _buildLiveBadge(context) => GestureDetector(
        onTap: () {
          Get.toNamed('/liveRoom?roomid=${live['roomid']}');
        },
        child: Container(
          width: 85,
          alignment: Alignment.center,
          child: Badge(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.equalizer_rounded,
                  size: MediaQuery.textScalerOf(context).scale(16),
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                Text(
                  '直播中',
                  style: TextStyle(height: 1),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 1,
            ),
            alignment: Alignment.center,
            textColor: Theme.of(context).colorScheme.onSecondaryContainer,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
      );

  _buildH(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SafeArea(
            top: false,
            bottom: false,
            child: Row(
              children: [
                const SizedBox(width: 20),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: card.prInfo?.content?.isNotEmpty == true ? 0 : 10,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildAvatar(context),
                      if (ModuleAuthorModel.showDynDecorate &&
                          card.pendant?.image?.isNotEmpty == true)
                        Positioned(
                          top: -27.5,
                          left: -27.5,
                          child: IgnorePointer(
                            child: CachedNetworkImage(
                              width: 140,
                              height: 140,
                              imageUrl: card.pendant!.image!,
                            ),
                          ),
                        ),
                      if (card.officialVerify?.icon?.isNotEmpty == true ||
                          (card.vip?.vipStatus ?? -1) > 0)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: _buildBadge(context),
                        ),
                      if (live is Map &&
                          ((live['liveStatus'] as int?) ?? 0) == 1)
                        Positioned(
                          left: 0,
                          bottom: -5,
                          right: 0,
                          child: _buildLiveBadge(context),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ..._buildLeft(context),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                Expanded(child: _buildRight(context)),
              ],
            ),
          ),
          if (card.prInfo?.content?.isNotEmpty == true) buildPrInfo,
        ],
      );
}

import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'network_img_layer.dart';

class Avatar extends StatelessWidget {
  final _BadgeType _badgeType;
  final String avatar;
  final double size;
  final String? garbPendantImage;
  final dynamic roomId;
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    required this.avatar,
    this.size = 80,
    bool? isVip,
    int? officialType,
    this.garbPendantImage,
    this.roomId,
    this.onTap,
  }) : _badgeType = officialType == null || officialType < 0
            ? isVip == true
                ? _BadgeType.vip
                : _BadgeType.none
            : officialType == 0
                ? _BadgeType.person
                : _BadgeType.institution;

  static final showDynDecorate = GStorage.showDynDecorate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        onTap == null
            ? _buildAvatar(colorScheme)
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: _buildAvatar(colorScheme),
              ),
        if (!garbPendantImage.isNullOrEmpty)
          Positioned(
            top: -size * 0.375, // -(size * 1.75 - size) / 2
            child: IgnorePointer(
              child: CachedNetworkImage(
                width: size * 1.75,
                height: size * 1.75,
                imageUrl: Utils.thumbnailImgUrl(garbPendantImage),
              ),
            ),
          ),
        if (roomId != null)
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () {
                Get.toNamed('/liveRoom?roomid=$roomId');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size / 12),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(size / 6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.equalizer_rounded,
                      size: size / 3,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    Text(
                      '直播中',
                      style: TextStyle(
                        height: 0.5,
                        fontSize: size / 6,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (_badgeType != _BadgeType.none)
          _buildBadge(context, colorScheme),
      ],
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) => DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          width: size / 32,
          color: colorScheme.surface,
        ),
        shape: BoxShape.circle,
      ),
      child: NetworkImgLayer(
        src: avatar,
        width: size,
        height: size,
        type: 'avatar',
      ));

  Widget _buildBadge(BuildContext context, ColorScheme colorScheme) {
    final child = switch (_badgeType) {
      _BadgeType.vip => Container(
          padding: EdgeInsets.all(size / 32),
          decoration: BoxDecoration(
            border: Border.all(
              width: size / 32,
              color: colorScheme.surface,
            ),
            shape: BoxShape.circle,
            // color: _badgeType.color,
            color: context.vipColor,
          ),
          child: Text(
            '大',
            style: TextStyle(
              // backgroundColor: Color(0xFFFF6699),
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: colorScheme.surface,
              fontSize: size / 5,
            ),
          ),
        ),
      _ => DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
          ),
          child: Icon(
            Icons.offline_bolt,
            color: _badgeType.color,
            size: size / 3,
            semanticLabel: _badgeType.desc,
          ),
        ),
    };
    return Positioned(
      right: 0,
      bottom: 0,
      child: IgnorePointer(child: child),
    );
  }
}

enum _BadgeType { none, vip, person, institution }

extension _BadgeTypeExt on _BadgeType {
  String get desc => const ['', '大会员', '认证个人', '认证机构'][index];
  Color get color => const [
        Colors.transparent,
        Color(0xFFFF6699),
        Colors.yellow,
        Colors.lightBlueAccent
      ][index];
}

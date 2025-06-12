import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final MineController _mineController = Get.put(MineController())
    ..queryUserInfo();

  Widget _header(ThemeData theme) => Row(
        children: [
          const SizedBox(width: 12),
          Image.asset(
            'assets/images/logo/logo.png',
            width: 35,
          ),
          const SizedBox(width: 5),
          Text(
            'PiliPlus',
            style: theme.textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            iconSize: 40.0,
            padding: const EdgeInsets.all(8),
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            tooltip: "${MineController.anonymity.value ? '退出' : '进入'}无痕模式",
            onPressed: () {
              MineController.onChangeAnonymity(context);
              setState(() {});
            },
            icon: MineController.anonymity.value
                ? const Icon(MdiIcons.incognito, size: 24)
                : const Icon(MdiIcons.incognitoOff, size: 24),
          ),
          Obx(
            () {
              return IconButton(
                iconSize: 40.0,
                padding: const EdgeInsets.all(8),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                tooltip: '切换至${_mineController.nextThemeType.description}主题',
                onPressed: _mineController.onChangeTheme,
                icon: _mineController.themeType.value.icon,
              );
            },
          ),
          IconButton(
            iconSize: 40.0,
            padding: const EdgeInsets.all(8),
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            tooltip: '设置',
            onPressed: () => {
              Get.back(),
              Get.toNamed('/setting', preventDuplicates: false),
            },
            icon: const Icon(MdiIcons.cogs, size: 24),
          ),
          const SizedBox(width: 10),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _header(theme),
          const SizedBox(height: 10),
          Obx(() => userInfoBuild(theme)),
        ],
      ),
    );
  }

  Widget userInfoBuild(ThemeData theme) {
    UserInfoData userInfo = _mineController.userInfo.value;
    LevelInfo? levelInfo = userInfo.levelInfo;
    TextStyle style = TextStyle(
      fontSize: theme.textTheme.titleMedium!.fontSize,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final isVip = userInfo.vipStatus != null && userInfo.vipStatus! > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _mineController.onLogin,
          onLongPress: () => _mineController.onLogin(true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 30),
              userInfo.face != null
                  ? Stack(
                      clipBehavior: Clip.none,
                      children: [
                        NetworkImgLayer(
                          src: userInfo.face,
                          semanticsLabel: '头像',
                          type: ImageType.avatar,
                          width: 55,
                          height: 55,
                        ),
                        if (isVip)
                          Positioned(
                            right: -1,
                            bottom: -2,
                            child: Image.asset(
                              'assets/images/big-vip.png',
                              height: 19,
                              semanticLabel: "大会员",
                            ),
                          ),
                      ],
                    )
                  : ClipOval(
                      child: Image.asset(
                        width: 55,
                        height: 55,
                        'assets/images/noface.jpeg',
                        semanticLabel: "默认头像",
                      ),
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            userInfo.uname ?? '点击头像登录',
                            style: theme.textTheme.titleMedium!.copyWith(
                              height: 1,
                              color: isVip && userInfo.vipType == 2
                                  ? context.vipColor
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          'assets/images/lv/lv${levelInfo == null ? 0 : userInfo.isSeniorMember == 1 ? '6_s' : levelInfo.currentLevel}.png',
                          height: 10,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch, // Make children stretch to the intrinsic width
                        children: [
                          FittedBox(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '硬币 ',
                                    style: TextStyle(
                                      fontSize:
                                          theme.textTheme.labelSmall!.fontSize,
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: userInfo.money?.toString() ?? '-',
                                    style: TextStyle(
                                      fontSize:
                                          theme.textTheme.labelSmall!.fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "    经验 ",
                                    style: TextStyle(
                                      fontSize:
                                          theme.textTheme.labelSmall!.fontSize,
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${levelInfo?.currentExp ?? '-'}",
                                    semanticsLabel:
                                        "当前${levelInfo?.currentExp ?? '-'}",
                                    style: TextStyle(
                                      fontSize:
                                          theme.textTheme.labelSmall!.fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "/${levelInfo?.nextExp ?? '-'}",
                                    semanticsLabel:
                                        "升级需${levelInfo?.nextExp ?? '-'}",
                                    style: TextStyle(
                                      fontSize:
                                          theme.textTheme.labelSmall!.fontSize,
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            minHeight: 2,
                            value: levelInfo != null
                                ? (levelInfo.currentExp! / levelInfo.nextExp!)
                                : 0,
                            backgroundColor: theme.colorScheme.inversePrimary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: SizedBox(
            width: 240,
            child: Row(
              children: [
                _btn(
                  count: _mineController.userStat.value.dynamicCount,
                  countStyle: style,
                  name: '动态',
                  nameStyle: theme.textTheme.labelMedium,
                  onTap: _mineController.pushDynamic,
                ),
                _btn(
                  count: _mineController.userStat.value.following,
                  countStyle: style,
                  name: '关注',
                  nameStyle: theme.textTheme.labelMedium,
                  onTap: _mineController.pushFollow,
                ),
                _btn(
                  count: _mineController.userStat.value.follower,
                  countStyle: style,
                  name: '粉丝',
                  nameStyle: theme.textTheme.labelMedium,
                  onTap: _mineController.pushFans,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _btn({
    required int? count,
    required TextStyle countStyle,
    required String name,
    required TextStyle? nameStyle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: StyleString.mdRadius,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count?.toString() ?? '-',
              style: countStyle,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: nameStyle,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/common/theme_type.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'controller.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final MineController _mineController = Get.put(MineController())
    ..themeType.value = ThemeType.values[GStorage.themeTypeInt]
    ..queryUserInfo();

  Widget get _header => FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 12),
            Image.asset(
              'assets/images/logo/logo.png',
              width: 35,
            ),
            const SizedBox(width: 5),
            Text(
              'PiliPlus',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 30),
            IconButton(
              iconSize: 40.0,
              padding: const EdgeInsets.all(8),
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
              tooltip: "${MineController.anonymity.value ? '退出' : '进入'}无痕模式",
              onPressed: () {
                MineController.onChangeAnonymity(context);
                setState(() {});
              },
              icon: Icon(
                MineController.anonymity.value
                    ? MdiIcons.incognito
                    : MdiIcons.incognitoOff,
                size: 24,
              ),
            ),
            IconButton(
              iconSize: 40.0,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
              tooltip: '切换至${switch (_mineController.nextThemeType) {
                ThemeType.light => '浅色',
                ThemeType.dark => '深色',
                ThemeType.system => '跟随系统',
              }}主题',
              onPressed: _mineController.onChangeTheme,
              icon: Icon(
                switch (_mineController.themeType.value) {
                  ThemeType.light => MdiIcons.weatherSunny,
                  ThemeType.dark => MdiIcons.weatherNight,
                  ThemeType.system => MdiIcons.themeLightDark,
                },
                size: 24,
              ),
            ),
            IconButton(
              iconSize: 40.0,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
              tooltip: '设置',
              onPressed: () => {
                Get.back(),
                Get.toNamed('/setting', preventDuplicates: false),
              },
              icon: Icon(
                MdiIcons.cogs,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _header,
          const SizedBox(height: 10),
          Obx(userInfoBuild),
        ],
      ),
    );
  }

  Widget userInfoBuild() {
    LevelInfo? levelInfo = _mineController.userInfo.value.levelInfo;
    TextStyle style = TextStyle(
      fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
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
              const SizedBox(width: 20),
              ClipOval(
                child: _mineController.userInfo.value.face != null
                    ? NetworkImgLayer(
                        src: _mineController.userInfo.value.face,
                        semanticsLabel: '头像',
                        width: 55,
                        height: 55,
                      )
                    : Container(
                        width: 55,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        child: Image.asset(
                          'assets/images/noface.jpeg',
                          semanticLabel: "默认头像",
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _mineController.userInfo.value.uname ?? '点击头像登录',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(height: 1),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            'assets/images/lv/lv${_mineController.userInfo.value.levelInfo != null ? _mineController.userInfo.value.levelInfo!.currentLevel : '0'}.png',
                            height: 10,
                            semanticLabel:
                                '等级：${_mineController.userInfo.value.levelInfo != null ? _mineController.userInfo.value.levelInfo!.currentLevel : '0'}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '硬币 ',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            TextSpan(
                              text:
                                  (_mineController.userInfo.value.money ?? '-')
                                      .toString(),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            TextSpan(
                              text: "  经验 ",
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            TextSpan(
                              text: "${levelInfo?.currentExp ?? '-'}",
                              semanticsLabel:
                                  "当前${levelInfo?.currentExp ?? '-'}",
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            TextSpan(
                              text: "/${levelInfo?.nextExp ?? '-'}",
                              semanticsLabel: "升级需${levelInfo?.nextExp ?? '-'}",
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 2,
                      child: LinearProgressIndicator(
                        minHeight: 2,
                        value: levelInfo != null
                            ? (levelInfo.currentExp! / levelInfo.nextExp!)
                            : 0,
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 240,
          height: 100,
          child: GridView.count(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: [
              InkWell(
                onTap: _mineController.pushDynamic,
                borderRadius: StyleString.mdRadius,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (_mineController.userStat.value.dynamicCount ?? '-')
                          .toString(),
                      key: ValueKey<String>(_mineController
                          .userStat.value.dynamicCount
                          .toString()),
                      style: style,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '动态',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _mineController.pushFollow,
                borderRadius: StyleString.mdRadius,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (_mineController.userStat.value.following ?? '-')
                          .toString(),
                      key: ValueKey<String>(
                          _mineController.userStat.value.following.toString()),
                      style: style,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '关注',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _mineController.pushFans,
                borderRadius: StyleString.mdRadius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (_mineController.userStat.value.follower ?? '-')
                          .toString(),
                      key: ValueKey<String>(
                          _mineController.userStat.value.follower.toString()),
                      style: style,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '粉丝',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

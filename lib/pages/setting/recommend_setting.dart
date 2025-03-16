import 'package:PiliPlus/pages/setting/widgets/model.dart';
import 'package:flutter/material.dart';

class RecommendSetting extends StatelessWidget {
  const RecommendSetting({super.key, this.showAppBar});

  final bool? showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar == false ? null : AppBar(title: const Text('推荐流设置')),
      body: ListView(
        children: [
          ...recommendSettings.map((item) => item.widget),
          ListTile(
            dense: true,
            subtitle: Text(
              '¹ 由于接口未提供关注信息，无法豁免相关视频中的已关注Up。\n\n'
              '* 其它（如热门视频、手动搜索、链接跳转等）均不受过滤器影响。\n'
              '* 设定较严苛的条件可导致推荐项数锐减或多次请求，请酌情选择。\n'
              '* 后续可能会增加更多过滤条件，敬请期待。',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.outline.withOpacity(0.7)),
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
        ],
      ),
    );
  }
}

import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FontSizeSelectPage extends StatefulWidget {
  const FontSizeSelectPage({super.key});

  @override
  State<FontSizeSelectPage> createState() => _FontSizeSelectPageState();
}

class _FontSizeSelectPageState extends State<FontSizeSelectPage> {
  List<double> list = List.generate(16, (index) => 0.85 + index * 0.05);
  late double minSize = list.first;
  late double maxSize = list.last;
  double currentSize = Pref.defaultTextScale;

  void setFontSize() {
    GStorage.setting.put(SettingBoxKey.defaultTextScale, currentSize);
    Get
      ..back(result: currentSize)
      ..forceAppUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              currentSize = 1.0;
              setFontSize();
            },
            child: const Text('重置'),
          ),
          TextButton(onPressed: setFontSize, child: const Text('确定')),
          const SizedBox(width: 12),
        ],
      ),
      body: ViewSafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '当前字体大小:${currentSize == 1.0 ? '默认' : currentSize}',
                  style: TextStyle(fontSize: 14 * currentSize),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                color: theme.colorScheme.surface,
              ),
              child: Row(
                children: [
                  const Text('小'),
                  Expanded(
                    child: Slider(
                      min: minSize,
                      value: currentSize,
                      max: maxSize,
                      divisions: list.length - 1,
                      secondaryTrackValue: 1,
                      onChanged: (double val) {
                        currentSize = val.toPrecision(2);
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '大',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

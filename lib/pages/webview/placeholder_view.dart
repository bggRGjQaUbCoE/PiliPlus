import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class PlaceholderWebviewPage extends StatelessWidget {
  const PlaceholderWebviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () => PageUtils.launchURL(Get.parameters['url']!),
          child: const Text('unsupported'),
        ),
      ),
    );
  }
}

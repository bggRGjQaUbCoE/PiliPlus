import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart' show tabBarView;
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/fan/view.dart';
import 'package:PiliPlus/pages/follow/child/child_view.dart';
import 'package:PiliPlus/pages/follow_search/view.dart';
import 'package:PiliPlus/pages/share/view.dart' show UserModel;
import 'package:PiliPlus/utils/accounts.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.isFromSelect = true});

  final bool isFromSelect;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  late final mid = Accounts.main.mid;
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSelect(UserModel userModel) {
    Get.back(result: userModel);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        title: Text(L10n.current.contactPageTitle),
        actions: [
          IconButton(
            onPressed: () async {
              final UserModel? userModel = await Navigator.of(context).push(
                GetPageRoute(
                  page: () => FollowSearchPage(
                    mid: mid,
                    isFromSelect: widget.isFromSelect,
                  ),
                ),
              );
              if (userModel != null) {
                Get.back(result: userModel);
              }
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _controller,
            tabs: [
              Tab(text: L10n.current.contactPageText),
              Tab(text: L10n.current.contactPageText2),
            ],
          ),
          Expanded(
            child: tabBarView(
              controller: _controller,
              children: [
                FollowChildPage(
                  mid: mid,
                  onSelect: widget.isFromSelect ? onSelect : null,
                ),
                FansPage(
                  showName: false,
                  onSelect: widget.isFromSelect ? onSelect : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/pages/fan/view.dart';
import 'package:PiliPlus/pages/follow/child/child_view.dart';
import 'package:PiliPlus/pages/follow_search/view.dart';
import 'package:PiliPlus/pages/share/view.dart' show UserModel;
import 'package:PiliPlus/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.isFromSelect = true});

  final bool isFromSelect;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  AccountService accountService = Get.find<AccountService>();
  late final _controller = TabController(length: 2, vsync: this);

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('通讯录'),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: '我的关注'),
            Tab(text: '我的粉丝'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              UserModel? userModel = await Navigator.of(context).push(
                GetPageRoute(
                  page: () => FollowSearchPage(
                    mid: accountService.mid,
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
      body: tabBarView(
        controller: _controller,
        children: [
          FollowChildPage(
            mid: accountService.mid,
            onSelect: widget.isFromSelect ? onSelect : null,
          ),
          FansPage(
            showName: false,
            onSelect: widget.isFromSelect ? onSelect : null,
          ),
        ],
      ),
    );
  }
}

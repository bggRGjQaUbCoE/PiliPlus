import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/grpc/audio.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/audio/view.dart';
import 'package:flutter/material.dart';

class ListenVideoPage extends StatefulWidget {
  const ListenVideoPage({super.key});

  @override
  State<ListenVideoPage> createState() => _ListenVideoPageState();
}

class _ListenVideoPageState extends State<ListenVideoPage> {
  LoadingState<RcmdPlaylistResp> state = LoadingState.loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) setState(() => state = LoadingState.loading());
    final result = await AudioGrpc.audioRcmdPlaylist();
    if (mounted) setState(() => state = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('听视频')),
      body: switch (state) {
        Loading() => m3eLoading,
        Error(:final errMsg) => scrollErrorWidget(
          errMsg: errMsg,
          onReload: _load,
        ),
        Success(:final response) => RefreshIndicator(
          onRefresh: _load,
          child: response.list.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 240),
                    Center(child: Text('暂无可听内容')),
                  ],
                )
              : ListView.separated(
                  itemCount: response.list.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) =>
                      _ListenVideoItem(item: response.list[index]),
                ),
        ),
      },
    );
  }
}

class _ListenVideoItem extends StatelessWidget {
  const _ListenVideoItem({required this.item});

  final DetailItem item;

  @override
  Widget build(BuildContext context) {
    final arc = item.arc;
    final playItem = item.item;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: SizedBox.square(
        dimension: 64,
        child: NetworkImgLayer(
          src: arc.cover,
          width: 64,
          height: 64,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
      ),
      title: Text(arc.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${item.owner.name} · ${_duration(arc.duration.toInt())}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.play_circle_outline),
      onTap: () => AudioPage.toAudioPage(
        oid: playItem.oid.toInt(),
        subId: playItem.subId.map((e) => e.toInt()).toList(),
        itemType: playItem.itemType,
        from: PlaylistSource.DEFAULT,
      ),
    );
  }

  static String _duration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remain = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$remain';
  }
}

import 'package:PiliPlus/pages/setting/models/video_settings.dart';
import 'package:flutter/material.dart';

class VideoSetting extends StatefulWidget {
  const VideoSetting({super.key, this.showAppBar});

  final bool? showAppBar;

  @override
  State<VideoSetting> createState() => _VideoSettingState();
}

class _VideoSettingState extends State<VideoSetting> {
  final settings = videoSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar == false
          ? null
          : AppBar(title: const Text('音视频设置')),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 80,
        ),
        children: settings.map((item) => item.widget).toList(),
      ),
    );
  }
}

import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/video/play/CDN.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class SelectDialog<T> extends StatefulWidget {
  final T value;
  final String title;
  final List<dynamic> values;
  const SelectDialog({
    super.key,
    required this.value,
    required this.values,
    required this.title,
  });

  @override
  State<SelectDialog<T>> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog<T>> {
  late T _tempValue;
  late List _cdnResList;
  late final cdnSpeedTest = GStorage.cdnSpeedTest;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.value;
    if (widget.title == 'CDN 设置' && cdnSpeedTest) {
      _cdnResList = List.generate(widget.values.length, (_) => null);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          dynamic result = await VideoHttp.videoUrl(
            cid: 196018899,
            bvid: 'BV1fK4y1t7hj',
          );
          if (result['status']) {
            VideoItem videoItem = result['data'].dash.video.first;

            for (CDNService item in CDNService.values) {
              if (mounted.not) {
                break;
              }
              String videoUrl = VideoUtils.getCdnUrl(videoItem, item.code);
              Dio dio = Dio()..options.headers['referer'] = HttpString.baseUrl;
              int maxSize = 8 * 1024 * 1024;
              int downloaded = 0;
              int start = DateTime.now().millisecondsSinceEpoch;
              try {
                await dio.get(
                  videoUrl,
                  onReceiveProgress: (int count, int total) {
                    downloaded += count;
                    int now = DateTime.now().millisecondsSinceEpoch;
                    if (now - start > 15 * 1000) {
                      dio.close(force: true);
                    }
                    if (downloaded >= maxSize) {
                      dio.close(force: true);
                      _cdnResList[item.index] =
                          (maxSize / (now - start) / 1000).toPrecision(2);
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                );
              } catch (e) {
                if (_cdnResList[item.index] == null) {
                  _cdnResList[item.index] = '测速失败';
                  debugPrint('$e');
                  if (mounted) {
                    setState(() {});
                  }
                }
              }
            }
          }
        } catch (e) {
          debugPrint('failed to check: $e');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: Text(widget.title),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      content: StatefulBuilder(builder: (context, StateSetter setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.values.length,
              (index) => RadioListTile(
                dense: true,
                value: widget.values[index]['value'],
                title: Text(
                  widget.values[index]['title'],
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                subtitle: widget.title == 'CDN 设置' && cdnSpeedTest
                    ? Text(
                        _cdnResList[index] is double
                            ? '${_cdnResList[index]} MB/s'
                            : _cdnResList[index] is String
                                ? _cdnResList[index]
                                : '---',
                        style: TextStyle(fontSize: 13),
                      )
                    : null,
                groupValue: _tempValue,
                onChanged: (value) {
                  setState(() {
                    _tempValue = value as T;
                  });
                  Navigator.pop(context, _tempValue);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

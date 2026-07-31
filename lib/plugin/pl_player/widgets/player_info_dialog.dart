import 'package:PiliPlus/plugin/pl_player/models/player_media_track.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPlayerInfoDialog(
  BuildContext context,
  List<PlayerInfoEntry> entries,
) {
  showDialog(
    context: context,
    builder: (context) {
      final colorScheme = ColorScheme.of(context);
      return AlertDialog(
        title: const Text('播放信息'),
        contentPadding: const EdgeInsets.only(top: 16),
        content: Material(
          type: MaterialType.transparency,
          child: ListTileTheme(
            contentPadding: const .symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: entries
                    .map(
                      (entry) => ListTile(
                        dense: true,
                        title: Text(entry.label),
                        subtitle: Text(entry.value),
                        onTap: () => Utils.copyText(
                          '${entry.label}\n${entry.value}',
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('确定', style: TextStyle(color: colorScheme.outline)),
          ),
        ],
      );
    },
  );
}

import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/fav_create/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('folder info completion is ignored after page disposal', (
    tester,
  ) async {
    final response = Completer<LoadingState<FavFolderInfo>>();
    Object? requestedMediaId;

    await tester.pumpWidget(
      MaterialApp(
        home: CreateFavPage(
          initialMediaId: 123,
          folderInfoLoader: (mediaId) {
            requestedMediaId = mediaId;
            return response.future;
          },
        ),
      ),
    );
    expect(requestedMediaId, 123);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    response.complete(
      Success(FavFolderInfo(title: 'late folder', intro: 'late intro')),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

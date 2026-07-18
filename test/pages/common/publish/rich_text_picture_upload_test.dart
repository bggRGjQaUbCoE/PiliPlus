import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models_new/upload_bfs/data.dart';
import 'package:PiliPlus/pages/common/publish/rich_text_picture_upload.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'upload failure cancels siblings, closes loading, and shows error',
    () async {
      final pendingUpload = Completer<LoadingState<UploadBfsResData>>();
      final cancelToken = CancelToken();
      final events = <String>[];
      var requestCount = 0;

      final result = await uploadRichTextPictures(
        images: [
          FilePicModel(path: 'pending'),
          FilePicModel(path: 'failed'),
        ],
        cancelToken: cancelToken,
        upload: ({required path, required cancelToken}) {
          requestCount += 1;
          return path == 'failed'
              ? Future.value(const Error('upload failed'))
              : pendingUpload.future;
        },
        onStart: () => events.add('start'),
        onFinish: () => events.add('finish'),
        onError: (message) => events.add('error:$message'),
      );

      expect(requestCount, 2);
      expect(cancelToken.isCancelled, isTrue);
      expect(result, isA<RichTextPictureUploadFailure>());
      expect(events, ['start', 'finish', 'error:upload failed']);
    },
  );

  test(
    'successful uploads preserve local and remote picture metadata',
    () async {
      final result = await uploadRichTextPictures(
        images: [
          FilePicModel(path: 'local'),
          OpusPicModel(
            width: 20,
            height: 10,
            size: 2,
            url: 'remote',
          ),
        ],
        upload: ({required path, required cancelToken}) async => Success(
          UploadBfsResData(
            imageWidth: 40,
            imageHeight: 30,
            imgSize: 3,
            imageUrl: 'uploaded',
          ),
        ),
      );

      expect(result, isA<RichTextPictureUploadSuccess>());
      final pictures = (result as RichTextPictureUploadSuccess).pictures;
      expect(pictures.first, {
        'img_width': 40,
        'img_height': 30,
        'img_size': 3,
        'img_src': 'uploaded',
      });
      expect(pictures.last, {
        'img_width': 20,
        'img_height': 10,
        'img_size': 2,
        'img_src': 'remote',
      });
    },
  );
}

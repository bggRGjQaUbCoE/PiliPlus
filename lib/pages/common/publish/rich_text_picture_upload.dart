import 'dart:async' show FutureOr;

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart'
    show FilePicModel, OpusPicModel, PicModel;
import 'package:PiliPlus/models_new/upload_bfs/data.dart';
import 'package:dio/dio.dart' show CancelToken;

typedef RichTextPictureUploader =
    Future<LoadingState<UploadBfsResData>> Function({
      required String path,
      required CancelToken cancelToken,
    });

sealed class RichTextPictureUploadResult {
  const RichTextPictureUploadResult();
}

final class RichTextPictureUploadSuccess extends RichTextPictureUploadResult {
  const RichTextPictureUploadSuccess(this.pictures);

  final List<Map<String, dynamic>> pictures;
}

final class RichTextPictureUploadFailure extends RichTextPictureUploadResult {
  const RichTextPictureUploadFailure(this.message);

  final String message;
}

final class _PictureUploadFailure implements Exception {
  const _PictureUploadFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Uploads local pictures while preserving existing remote picture metadata.
///
/// Feedback callbacks are injected so failure cleanup can be verified without
/// installing a global dialog navigator in tests.
Future<RichTextPictureUploadResult> uploadRichTextPictures({
  required Iterable<PicModel> images,
  required RichTextPictureUploader upload,
  CancelToken? cancelToken,
  FutureOr<void> Function()? onStart,
  FutureOr<void> Function()? onFinish,
  FutureOr<void> Function(String message)? onError,
}) async {
  final token = cancelToken ?? CancelToken();
  await onStart?.call();

  late final RichTextPictureUploadResult result;
  try {
    final pictures = await Future.wait<Map<String, dynamic>>(
      images.map((image) async {
        switch (image) {
          case FilePicModel(:final path):
            final uploadState = await upload(
              path: path,
              cancelToken: token,
            );
            if (uploadState case Success(:final response)) {
              return {
                'img_width': response.imageWidth,
                'img_height': response.imageHeight,
                'img_size': response.imgSize,
                'img_src': response.imageUrl,
              };
            }
            throw _PictureUploadFailure(uploadState.toString());
          case OpusPicModel e:
            return e.toJson();
        }
      }),
      eagerError: true,
    );
    result = RichTextPictureUploadSuccess(pictures);
  } catch (error) {
    token.cancel(error);
    final message = error.toString();
    result = RichTextPictureUploadFailure(
      message.isEmpty ? '图片上传失败' : message,
    );
  } finally {
    await onFinish?.call();
  }

  if (result case RichTextPictureUploadFailure(:final message)) {
    await onError?.call(message);
  }
  return result;
}

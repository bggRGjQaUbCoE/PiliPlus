import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart'
    show Offset, Session, SessionPageType, SessionSecondaryReply, ThreeDotItem;
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_whisper_controller.dart';
import 'package:get/get.dart';
import 'package:protobuf/protobuf.dart' show PbMap;

class WhisperSecController
    extends CommonWhisperController<SessionSecondaryReply> {
  WhisperSecController({
    required this.sessionPageType,
  });

  PbMap<int, Offset>? offset;
  @override
  final SessionPageType sessionPageType;
  Rx<List<ThreeDotItem>?> threeDotItems = Rx<List<ThreeDotItem>?>(null);

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> onRefresh() {
    offset = null;
    return super.onRefresh();
  }

  @override
  List<Session>? getDataList(SessionSecondaryReply response) {
    if (!response.paginationParams.hasMore) {
      isEnd = true;
    }
    offset = response.paginationParams.offsets;

    return response.sessions;
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<SessionSecondaryReply> response,
  ) {
    if (isRefresh) {
      threeDotItems.value = response.response.threeDotItems;
    }
    return false;
  }

  @override
  Future<LoadingState<SessionSecondaryReply>> customGetData() =>
      ImGrpc.sessionSecondary(
        offset: offset,
        pageType: sessionPageType,
      );
}

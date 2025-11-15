import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/bili_download_media_file_info.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:get/get_utils/get_utils.dart';

abstract final class DownloadHttp {
  static const String referer = "https://www.bilibili.com/";
  static const String userAgent = "Bilibili Freedoooooom/MarkII";

  static Future<BiliDownloadMediaInfo> getVideoUrl({
    required BiliDownloadEntryInfo entry,
    SourceInfo? source,
    PageInfo? pageData,
    EpInfo? ep,
  }) async {
    final isLogin = Accounts.get(AccountType.video).isLogin;
    final res = await VideoHttp.videoUrl(
      avid: entry.avid,
      bvid: entry.bvid,
      cid: entry.cid,
      seasonId: entry.seasonId,
      epid: ep?.episodeId,
      qn: entry.preferedVideoQuality,
      tryLook: !isLogin && Pref.p1080,
      videoType: switch (ep?.from) {
        'pugv' => VideoType.pugv,
        != null when isLogin => VideoType.pgc,
        _ => VideoType.ugc,
      },
    );
    if (res.isSuccess) {
      final PlayUrlModel data = res.data;
      final Dash? dash = data.dash;
      if (dash != null) {
        final List<VideoItem> videoList = dash.video!;
        final curHighestVideoQa = videoList.first.quality.code;
        final preferVideoQa = entry.preferedVideoQuality;
        int targetVideoQa = curHighestVideoQa;
        if (data.acceptQuality?.isNotEmpty == true &&
            preferVideoQa <= curHighestVideoQa) {
          // 如果预设的画质低于当前最高
          targetVideoQa = data.acceptQuality!.findClosestTarget(
            (e) => e <= preferVideoQa,
            (a, b) => a > b ? a : b,
          );
        }

        /// 取出符合当前画质的videoList
        final List<VideoItem> videosList = videoList
            .where((e) => e.quality.code == targetVideoQa)
            .toList();

        /// 优先顺序 设置中指定解码格式 -> 当前可选的首个解码格式
        final List<FormatItem> supportFormats = data.supportFormats!;
        // 根据画质选编码格式
        final FormatItem targetSupportFormats = supportFormats.firstWhere(
          (e) => e.quality == targetVideoQa,
          orElse: () => supportFormats.first,
        );
        final List<String> supportDecodeFormats = targetSupportFormats.codecs!;

        entry
          ..typeTag = targetVideoQa.toString()
          ..videoQuality = targetVideoQa
          ..preferedVideoQuality = targetVideoQa
          ..qualityPithyDescription =
              targetSupportFormats.newDesc ??
              VideoQuality.fromCode(targetVideoQa).desc;

        String preferDecode = Pref.defaultDecode; // def avc
        String preferSecondDecode = Pref.secondDecode; // def av1

        // 默认从设置中取AV1
        VideoDecodeFormatType currentDecodeFormats =
            VideoDecodeFormatType.fromString(preferDecode);
        VideoDecodeFormatType secondDecodeFormats =
            VideoDecodeFormatType.fromString(preferSecondDecode);
        // 当前视频没有对应格式返回第一个
        int flag = 0;
        for (final e in supportDecodeFormats) {
          if (currentDecodeFormats.codes.any(e.startsWith)) {
            flag = 1;
            break;
          } else if (secondDecodeFormats.codes.any(e.startsWith)) {
            flag = 2;
          }
        }
        if (flag == 2) {
          currentDecodeFormats = secondDecodeFormats;
        } else if (flag == 0) {
          currentDecodeFormats = VideoDecodeFormatType.fromString(
            supportDecodeFormats.first,
          );
        }

        /// 取出符合当前解码格式的videoItem
        final videoDash = videosList.firstWhere(
          (e) => currentDecodeFormats.codes.any(e.codecs!.startsWith),
          orElse: () => videosList.first,
        );

        final videoUrl = VideoUtils.getCdnUrl(videoDash.playUrls);

        final Type2File videoFile = Type2File(
          id: videoDash.id!,
          baseUrl: videoUrl,
          bandwidth: videoDash.bandWidth!,
          codecid: videoDash.codecid!,
          size: 0,
          md5: '',
          noRexcode: false,
          frameRate: videoDash.frameRate ?? '',
          width: videoDash.width!,
          height: videoDash.height!,
          dashDrmType: 0,
        );
        List<Type2File>? audioFileList;
        final List<AudioItem>? audioDashList = dash.audio;
        if (audioDashList != null && audioDashList.isNotEmpty) {
          final preferAudioQa = Pref.defaultAudioQa;
          final List<int> audioIds = audioDashList
              .map((map) => map.id!)
              .toList();
          int closestNumber = audioIds.findClosestTarget(
            (e) => e <= preferAudioQa,
            (a, b) => a > b ? a : b,
          );
          if (!audioIds.contains(preferAudioQa) &&
              audioIds.any((e) => e > preferAudioQa)) {
            closestNumber = AudioQuality.k192.code;
          }
          final AudioItem audioDash = audioDashList.firstWhere(
            (e) => e.id == closestNumber,
            orElse: () => audioDashList.first,
          );
          final audioUrl = VideoUtils.getCdnUrl(
            audioDash.playUrls,
            isAudio: true,
          );
          audioFileList = [
            Type2File(
              id: audioDash.id!,
              baseUrl: audioUrl,
              bandwidth: audioDash.bandWidth!,
              codecid: audioDash.codecid!,
              size: 0,
              md5: '',
              noRexcode: false,
              frameRate: audioDash.frameRate!,
              width: audioDash.width!,
              height: audioDash.height!,
              dashDrmType: 0,
            ),
          ];
        }
        return Type2(
          duration: dash.duration!,
          video: [videoFile],
          audio: audioFileList,
          referer: referer,
          userAgent: userAgent,
        );
      } else {
        final first = data.durl!.first;
        final List<Type1Segment> segmentList = [
          Type1Segment(
            backupUrls: [],
            bytes: first.size!,
            duration: first.length!,
            md5: '',
            metaUrl: '',
            order: first.order!,
            url: VideoUtils.getCdnUrl(first.playUrls),
          ),
        ];
        final FormatItem? formatItem = data.supportFormats?.firstWhereOrNull(
          (e) => e.quality == data.quality,
        );
        final String description =
            formatItem?.newDesc ?? VideoQuality.clear480.desc;
        final int targetVideoQa =
            formatItem?.quality ?? VideoQuality.clear480.code;

        entry
          ..mediaType = 1
          ..typeTag = targetVideoQa.toString()
          ..videoQuality = targetVideoQa
          ..preferedVideoQuality = targetVideoQa
          ..qualityPithyDescription = description;

        final List<Type1PlayerCodecConfig> playerCodecConfigList = [
          Type1PlayerCodecConfig(
            player: "IJK_PLAYER",
            useIjkMediaCodec: false,
          ),
          Type1PlayerCodecConfig(
            player: "ANDROID_PLAYER",
            useIjkMediaCodec: false,
          ),
        ];

        return Type1(
          from: pageData?.from ?? ep?.from,
          quality: entry.preferedVideoQuality,
          typeTag: entry.typeTag,
          description: description,
          playerCodecConfigList: playerCodecConfigList,
          segmentList: segmentList,
          parseTimestampMilli: 0,
          availablePeriodMilli: 0,
          isDownloaded: false,
          isResolved: true,
          timeLength: 0,
          marlinToken: '',
          videoCodecId: 0,
          videoProject: true,
          format: data.format!,
          playerError: 0,
          needVip: false,
          needLogin: false,
          intact: false,
          referer: referer,
          userAgent: userAgent,
        );
      }
    } else {
      throw res.toString();
    }
  }
}

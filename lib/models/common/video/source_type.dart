import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pbenum.dart'
    show PlaylistSource;

enum SourceType {
  normal(
    mediaType: -1,
    playlistSource: PlaylistSource.UP_ARCHIVE,
  ),
  archive(
    mediaType: 1,
    extraId: 1,
    playlistSource: PlaylistSource.MEDIA_LIST,
  ),
  watchLater(
    mediaType: 2,
    extraId: 2,
    playlistSource: PlaylistSource.MEDIA_LIST,
  ),
  fav(
    mediaType: 3,
    extraId: 2,
    playlistSource: PlaylistSource.USER_FAVOURITE,
  ),
  playlist(
    mediaType: 3,
    extraId: 4,
    playlistSource: PlaylistSource.MEDIA_LIST,
  );

  final int mediaType;
  final int? extraId;
  final PlaylistSource playlistSource;
  const SourceType({
    required this.mediaType,
    this.extraId,
    required this.playlistSource,
  });
}

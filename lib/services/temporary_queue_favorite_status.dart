import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';

/// The folder lookup returns folders even when this video is not in them.
/// `favState == 1` is the server's membership signal for the requested video.
bool isConfirmedFavoriteInFolder(
  Iterable<FavFolderInfo>? folders,
  int targetFolderId,
) =>
    folders?.any(
      (folder) => folder.id == targetFolderId && folder.favState == 1,
    ) ??
    false;

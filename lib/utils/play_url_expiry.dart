/// Reads the expiry timestamp embedded in playable media URLs.
///
/// Bilibili uses `deadline` and live streams may use `expires` or `wsTime`.
/// Some CDNs also use `hdnts=exp=...` (Akamai) or `~exp=...`. URLs may be
/// embedded in an `edl://` string, so don't assume the entire input is a URI.
abstract final class PlayUrlExpiry {
  // DateTime's inclusive range, in whole seconds. Ignore invalid timestamps
  // rather than letting an untrusted URL make the player fail to initialise.
  static const int _maxEpochSeconds = 8640000000000;

  /// A URL with less lifetime than this is treated as unusable, so playback
  /// never starts with a link that is about to expire.
  static const expiryMargin = Duration(seconds: 60);

  /// Refresh proactively while this much time is left, giving the request time
  /// to finish before the URL dies.
  static const refreshAhead = Duration(seconds: 90);
  static final RegExp _deadlinePattern = RegExp(
    r'(?:(?:^|[?&]|%3f|%26)(?:deadline|expires)|'
    r'(?:^|[?&]|%3f|%26)hdnts(?:=|%3d)exp|'
    r'(?:~|%7e)exp)'
    r'(?:=|%3d)(\d+)(?=$|[&#~;,]|%26|%3b|%7e|%2c)',
    caseSensitive: false,
  );
  static final RegExp _wsTimePattern = RegExp(
    r'(?:^|[?&]|%3f|%26)wstime(?:=|%3d)([0-9a-f]+)'
    r'(?=$|[&#~;,]|%26|%3b|%7e|%2c)',
    caseSensitive: false,
  );

  static Iterable<int> deadlines(String? url) sync* {
    if (url == null || url.isEmpty) return;
    for (final match in _deadlinePattern.allMatches(url)) {
      final value = int.tryParse(match.group(1)!);
      if (value != null && value > 0 && value <= _maxEpochSeconds) {
        yield value;
      }
    }
    for (final match in _wsTimePattern.allMatches(url)) {
      final value = int.tryParse(match.group(1)!, radix: 16);
      if (value != null && value > 0 && value <= _maxEpochSeconds) {
        yield value;
      }
    }
  }

  /// Returns the earliest expiry among all URLs, or `null` when no expiry is
  /// present.
  static int? earliestDeadline(Iterable<String?> urls) {
    int? result;
    for (final url in urls) {
      for (final deadline in deadlines(url)) {
        if (result == null || deadline < result) {
          result = deadline;
        }
      }
    }
    return result;
  }

  static DateTime? earliestExpiry(Iterable<String?> urls) {
    final deadline = earliestDeadline(urls);
    if (deadline == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(deadline * 1000, isUtc: true);
  }

  /// Whether any URL is already expired, or will expire within [margin].
  static bool isExpiredOrNear(
    Iterable<String?> urls, {
    Duration margin = expiryMargin,
    DateTime? now,
  }) {
    final expiry = earliestExpiry(urls);
    if (expiry == null) return false;
    return !(now ?? DateTime.now()).isBefore(expiry.subtract(margin));
  }
}

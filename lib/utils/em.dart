abstract final class Em {
  static final _exp = RegExp('<[^>]*>([^<]*)</[^>]*>');
  static final _htmlRegExp = RegExp(
    r'&(lt|gt|quot|apos|nbsp|amp|#x[a-fA-F\d]{2,4});',
  );

  static String regCate(String origin) {
    final matches = _exp.firstMatch(origin);
    return matches?.group(1) ?? origin;
  }

  static String parseHtml(String str) {
    return str.replaceAllMapped(
      _htmlRegExp,
      (match) => switch (match.group(1)) {
        'lt' => '<',
        'gt' => '>',
        'quot' => '"',
        'apos' => "'",
        'nbsp' => ' ',
        'amp' => '&',
        var i? when (i.startsWith('#x')) => String.fromCharCode(
          int.parse(i.substring(2), radix: 16),
        ),
        _ => match.group(0)!,
      },
    );
  }

  static List<({bool isEm, String text})> regTitle(String origin) {
    List<({bool isEm, String text})> res = [];
    origin.splitMapJoin(
      _exp,
      onMatch: (Match match) {
        res.add((isEm: true, text: parseHtml(match[1] ?? match[0]!)));
        return '';
      },
      onNonMatch: (String str) {
        if (str != '') {
          res.add((isEm: false, text: parseHtml(str)));
        }
        return '';
      },
    );
    return res;
  }
}

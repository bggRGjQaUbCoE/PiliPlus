abstract class Em {
  static final _exp = RegExp('<[^>]*>([^<]*)</[^>]*>');
  static final _htmlRegExp = RegExp(r'&(lt|gt|quot|apos|nbsp|amp);');

  static String regCate(String origin) {
    Iterable<Match> matches = _exp.allMatches(origin);
    return matches.lastOrNull?.group(1) ?? origin;
  }

  static List<({bool isEm, String text})> regTitle(String origin) {
    List<({bool isEm, String text})> res = [];
    origin.splitMapJoin(
      _exp,
      onMatch: (Match match) {
        String matchStr = match[0]!;
        res.add((isEm: true, text: regCate(matchStr)));
        return '';
      },
      onNonMatch: (String str) {
        if (str != '') {
          res.add((
            isEm: false,
            text: str.replaceAllMapped(
              _htmlRegExp,
              (m) => switch (m.group(1)) {
                'lt' => '<',
                'gt' => '>',
                'quot' => '"',
                'apos' => "'",
                'nbsp' => ' ',
                'amp' => '&',
                _ => m.group(0)!,
              },
            ),
          ));
        }
        return '';
      },
    );
    return res;
  }
}

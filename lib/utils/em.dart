import 'package:html/parser.dart' show parse;

abstract class Em {
  static final _exp = RegExp('<[^>]*>([^<]*)</[^>]*>');

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
          str = decodeHtmlEntities(str);
          res.add((isEm: false, text: str));
        }
        return '';
      },
    );
    return res;
  }

  static String decodeHtmlEntities(String title) {
    return parse(title).body?.text ?? title;
  }
}

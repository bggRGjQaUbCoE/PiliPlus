import 'package:html/parser.dart' show parse;

class Em {
  static final _exp = RegExp('<[^>]*>([^<]*)</[^>]*>');

  static String regCate(String origin) {
    Iterable<Match> matches = _exp.allMatches(origin);
    return matches.lastOrNull?.group(1) ?? origin;
  }

  static List<Map<String, String>> regTitle(String origin) {
    List<Map<String, String>> res = [];
    origin.splitMapJoin(
      _exp,
      onMatch: (Match match) {
        String matchStr = match[0]!;
        var map = {'type': 'em', 'text': regCate(matchStr)};
        res.add(map);
        return matchStr;
      },
      onNonMatch: (String str) {
        if (str != '') {
          str = parse(str).body?.text ?? str;
          var map = {'type': 'text', 'text': str};
          res.add(map);
        }
        return str;
      },
    );
    return res;
  }

  static String decodeHtmlEntities(String title) {
    return parse(title).body?.text ?? title;
    // return title
    //     .replaceAll('&lt;', '<')
    //     .replaceAll('&gt;', '>')
    //     .replaceAll('&#34;', '"')
    //     .replaceAll('&#39;', "'")
    //     .replaceAll('&quot;', '"')
    //     .replaceAll('&apos;', "'")
    //     .replaceAll('&nbsp;', " ")
    //     .replaceAll('&amp;', "&")
    //     .replaceAll('&#x27;', "'");
  }
}

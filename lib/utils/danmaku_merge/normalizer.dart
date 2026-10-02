// Inspired by pakku.js (https://github.com/xmcp/pakku.js)
// Reference: pakkujs/core/combine_worker.ts

class DanmakuNormalizer {
  static const Set<String> _endingChars = {
    '.',
    '。',
    ',',
    '，',
    '/',
    '?',
    '？',
    '!',
    '！',
    '…',
    '~',
    '～',
    '@',
    '^',
    '、',
    '+',
    '=',
    '-',
    '_',
    '♂',
    '♀',
    ' ',
  };

  static final RegExp _extraSpaceRe = RegExp(r'[ \u3000]+');
  static final RegExp _cjkSpaceRe = RegExp(
    r'([\u3000-\u9FFF\uFF00-\uFFEF]) (?=[\u3000-\u9FFF\uFF00-\uFFEF])',
  );
  static final RegExp _repeat233Re = RegExp(r'^23{2,}$', caseSensitive: false);
  static final RegExp _repeat666Re = RegExp(r'^6{3,}$', caseSensitive: false);

  static final Map<String, String> _widthTable = <String, String>{
    '　': ' ',
    '１': '1',
    '２': '2',
    '３': '3',
    '４': '4',
    '５': '5',
    '６': '6',
    '７': '7',
    '８': '8',
    '９': '9',
    '０': '0',
    '!': '！',
    '＠': '@',
    '＃': '#',
    '＄': r'$',
    '％': '%',
    '＾': '^',
    '＆': '&',
    '＊': '*',
    '（': '(',
    '）': ')',
    '－': '-',
    '＝': '=',
    '＿': '_',
    '＋': '+',
    '［': '[',
    '］': ']',
    '｛': '{',
    '｝': '}',
    ';': '；',
    '＇': "'",
    ':': '：',
    '＂': '"',
    ',': '，',
    '．': '.',
    '／': '/',
    '＜': '<',
    '＞': '>',
    '?': '？',
    '＼': r'\',
    '｜': '|',
    '｀': '`',
    '～': '~',
    'ｑ': 'q',
    'ｗ': 'w',
    'ｅ': 'e',
    'ｒ': 'r',
    'ｔ': 't',
    'ｙ': 'y',
    'ｕ': 'u',
    'ｉ': 'i',
    'ｏ': 'o',
    'ｐ': 'p',
    'ａ': 'a',
    'ｓ': 's',
    'ｄ': 'd',
    'ｆ': 'f',
    'ｇ': 'g',
    'ｈ': 'h',
    'ｊ': 'j',
    'ｋ': 'k',
    'ｌ': 'l',
    'ｚ': 'z',
    'ｘ': 'x',
    'ｃ': 'c',
    'ｖ': 'v',
    'ｂ': 'b',
    'ｎ': 'n',
    'ｍ': 'm',
    'Ｑ': 'Q',
    'Ｗ': 'W',
    'Ｅ': 'E',
    'Ｒ': 'R',
    'Ｔ': 'T',
    'Ｙ': 'Y',
    'Ｕ': 'U',
    'Ｉ': 'I',
    'Ｏ': 'O',
    'Ｐ': 'P',
    'Ａ': 'A',
    'Ｓ': 'S',
    'Ｄ': 'D',
    'Ｆ': 'F',
    'Ｇ': 'G',
    'Ｈ': 'H',
    'Ｊ': 'J',
    'Ｋ': 'K',
    'Ｌ': 'L',
    'Ｚ': 'Z',
    'Ｘ': 'X',
    'Ｃ': 'C',
    'Ｖ': 'V',
    'Ｂ': 'B',
    'Ｎ': 'N',
    'Ｍ': 'M',
  };

  static String normalize(String input) {
    // Adapted from pakku's text normalization flow: trim, width folding,
    // ending punctuation trimming, whitespace cleanup, and fixed replacements.
    var text = input.replaceAll(RegExp(r'[\r\n\t]'), '').trim();
    if (text.isEmpty) {
      return text;
    }

    var end = text.length;
    while (end > 0 && _endingChars.contains(text[end - 1])) {
      end--;
    }
    if (end == 0) {
      end = text.length;
    }

    final buffer = StringBuffer();
    for (var i = 0; i < end; i++) {
      final char = text[i];
      buffer.write(_widthTable[char] ?? char);
    }

    text = buffer.toString();
    text = text.replaceAll(_extraSpaceRe, ' ');
    text = text.replaceAllMapped(_cjkSpaceRe, (match) => match[1] ?? '');

    if (_repeat233Re.hasMatch(text)) {
      return '23333';
    }
    if (_repeat666Re.hasMatch(text)) {
      return '66666';
    }
    return text;
  }
}

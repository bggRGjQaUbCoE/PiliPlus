/// Converts TeX math source into Unicode text.
///
/// Known boundaries (by design):
/// - Unknown macros render verbatim and are registered in the warnings list;
/// - Malformed input (unclosed `{`) throws [ParseError] and the issue goes to warnings;
/// - Fragments without a Unicode glyph stay in source.
///
/// Reference: pylatexenc (https://github.com/phfaist/pylatexenc, MIT).
library;

enum TokenKind { text, cmd, brace, brack, script, amp }

class Token {
  const Token(this.kind, this.value);

  final TokenKind kind;
  final String value;
}

final class ParseError implements Exception {
  ParseError(this.message);

  final String message;

  @override
  String toString() => 'ParseError: $message';
}

sealed class TexNode {
  const TexNode();
}

final class TextNode extends TexNode {
  const TextNode(this.content);

  final String content;
}

final class GroupNode extends TexNode {
  const GroupNode(this.items);

  final List<TexNode> items;
}

/// Command with an optional `[...]` and required `{...}` arguments.
final class CommandNode extends TexNode {
  const CommandNode(this.name, this.optional, this.args);

  final String name;
  final String? optional;
  final List<List<TexNode>> args;
}

/// Base with scripts; chained scripts wrap (so render order == write order).
final class ScriptNode extends TexNode {
  const ScriptNode(this.base, {this.sup, this.sub});

  final TexNode base;
  final TexNode? sup;
  final TexNode? sub;
}

/// Converts a substring containing TeX math into Unicode text.
abstract final class LatexToUnicode {
  static const Map<String, String> _sym = {
    'alpha': 'α',
    'beta': 'β',
    'gamma': 'γ',
    'delta': 'δ',
    'epsilon': 'ε',
    'theta': 'θ',
    'mu': 'μ',
    'pi': 'π',
    'rho': 'ρ',
    'sigma': 'σ',
    'tau': 'τ',
    'phi': 'ϕ',
    'psi': 'ψ',
    'omega': 'ω',
    'Gamma': 'Γ',
    'Delta': 'Δ',
    'Theta': 'Θ',
    'Lambda': 'Λ',
    'Pi': 'Π',
    'Sigma': 'Σ',
    'Phi': 'Φ',
    'Omega': 'Ω',
    'cdot': '⋅',
    'times': '×',
    'div': '÷',
    'pm': '±',
    'mp': '∓',
    'ast': '∗',
    'star': '⋆',
    'bullet': '•',
    'circ': '∘',
    'prime': '′',
    'sum': '∑',
    'prod': '∏',
    'int': '∫',
    'partial': '∂',
    'nabla': '∇',
    'infty': '∞',
    'approx': '≈',
    'equiv': '≡',
    'neq': '≠',
    'ne': '≠',
    'le': '≤',
    'leq': '≤',
    'ge': '≥',
    'geq': '≥',
    'll': '≪',
    'gg': '≫',
    'rightarrow': '→',
    'leftarrow': '←',
    'to': '→',
  };

  static const Map<String, String> _supMap = {
    '0': '⁰',
    '1': '¹',
    '2': '²',
    '3': '³',
    '4': '⁴',
    '5': '⁵',
    '6': '⁶',
    '7': '⁷',
    '8': '⁸',
    '9': '⁹',
    '+': '⁺',
    '-': '⁻',
    '=': '⁼',
    '(': '⁽',
    ')': '⁾',
    'n': 'ⁿ',
    'i': 'ⁱ',
    'T': 'ᵀ',
    't': 'ᵗ',
    'e': 'ᵉ',
    'f': 'ᶠ',
    'g': 'ᵍ',
    'H': 'ᴴ',
    'L': 'ᴸ',
    'M': 'ᴹ',
    'R': 'ᴿ',
    'p': 'ᵖ',
    'r': 'ʳ',
    's': 'ˢ',
    'u': 'ᵘ',
    'v': 'ᵛ',
    'w': 'ʷ',
    'x': 'ˣ',
    'y': 'ʸ',
    'z': 'ᶻ',
    'a': 'ᵃ',
    'b': 'ᵇ',
    'c': 'ᶜ',
    'd': 'ᵈ',
    'h': 'ʰ',
    'j': 'ʲ',
    'k': 'ᵏ',
    'l': 'ˡ',
    'm': 'ᵐ',
    'o': 'ᵒ',
  };

  static const Map<String, String> _subMap = {
    '0': '₀',
    '1': '₁',
    '2': '₂',
    '3': '₃',
    '4': '₄',
    '5': '₅',
    '6': '₆',
    '7': '₇',
    '8': '₈',
    '9': '₉',
    '+': '₊',
    '-': '₋',
    '=': '₌',
    '(': '₍',
    ')': '₎',
    'a': 'ₐ',
    'e': 'ₑ',
    'i': 'ᵢ',
    'n': 'ₙ',
    'o': 'ₒ',
    'u': 'ᵤ',
  };

  static const Map<String, String> _voidCmds = {
    'quad': ' ',
    'qquad': ' ',
    ',': ' ',
    ';': ' ',
    ':': ' ',
    '!': '',
    'ensuremath': '',
    'space': ' ',
  };

  static const Set<String> _plainCmds = {
    'mathrm',
    'text',
    'operatorname',
    'emph',
    'mathnormal',
  };

  static const Set<String> _optCmds = {'sqrt'};

  static final RegExp _alphaRegex = RegExp(r'^[\p{L}]$', unicode: true);
  static final RegExp _needsParenRegex = RegExp(r'[+\-= /]');

  static String convert(String tex) {
    return _normalizeSpaces(Renderer().render(parse(tex)));
  }

  static (String, List<String>) convertWithWarnings(String tex) {
    final renderer = Renderer();
    final rendered = _normalizeSpaces(renderer.render(parse(tex)));
    return (rendered, renderer.warnings);
  }

  static (String, List<String>) convertEmbedded(String text) {
    final (spans, warnings) = convertSpans(text);
    if (spans.isEmpty) return (text, warnings);
    final buffer = StringBuffer();
    int cursor = 0;
    for (final span in spans) {
      buffer
        ..write(text.substring(cursor, span.start))
        ..write(span.converted);
      cursor = span.end;
    }
    buffer.write(text.substring(cursor));
    return (buffer.toString(), warnings);
  }

  /// Scans [text] for `$...$` / `$$...$$` spans and converts each one.
  /// Malformed spans are left in source form and reported through warnings;
  /// this is the editor-facing entry point and never throws.
  static (List<({int start, int end, String converted})>, List<String>)
  convertSpans(String text) {
    final spans = <({int start, int end, String converted})>[];
    final warnings = <String>[];
    int i = 0;
    while (i < text.length) {
      if (text[i] == r'\' && i + 1 < text.length && text[i + 1] == '\$') {
        i += 2;
        continue;
      }
      if (text[i] != '\$') {
        i++;
        continue;
      }
      final isDisplay = i + 1 < text.length && text[i + 1] == '\$';
      final markerLen = isDisplay ? 2 : 1;
      final close = _findClosingDollar(text, i + markerLen, isDisplay);
      if (close == -1) {
        i += 1;
        continue;
      }
      try {
        final (converted, innerWarnings) = convertWithWarnings(
          text.substring(i + markerLen, close),
        );
        spans.add((start: i, end: close + markerLen, converted: converted));
        warnings.addAll(innerWarnings);
      } on ParseError catch (e) {
        warnings.add(e.message);
      }
      i = close + markerLen;
    }
    return (spans, warnings);
  }

  static int _findClosingDollar(String text, int start, bool isDisplay) {
    for (var j = start; j < text.length; j++) {
      if (text[j] == r'\' && j + 1 < text.length && text[j + 1] == '\$') {
        j++;
        continue;
      }
      if (isDisplay) {
        if (j + 1 < text.length && text[j] == '\$' && text[j + 1] == '\$') {
          return j;
        }
      } else if (text[j] == '\$') {
        return j;
      }
    }
    return -1;
  }

  static List<Token> tokenize(String source) {
    final tokens = <Token>[];
    final buffer = StringBuffer();
    void flushText() {
      if (buffer.isNotEmpty) {
        tokens.add(Token(TokenKind.text, buffer.toString()));
        buffer.clear();
      }
    }

    int i = 0;
    while (i < source.length) {
      final char = source[i];
      if (char == r'\') {
        flushText();
        final (token, next) = _readCommand(source, i);
        tokens.add(token);
        i = next;
        continue;
      }
      switch (char) {
        case '{':
          flushText();
          tokens.add(const Token(TokenKind.brace, '{'));
        case '}':
          flushText();
          tokens.add(const Token(TokenKind.brace, '}'));
        case '[':
          flushText();
          tokens.add(const Token(TokenKind.brack, '['));
        case ']':
          flushText();
          tokens.add(const Token(TokenKind.brack, ']'));
        case '^' || '_':
          flushText();
          tokens.add(Token(TokenKind.script, char));
        case '&':
          flushText();
          tokens.add(const Token(TokenKind.amp, '&'));
        default:
          buffer.write(char);
      }
      i++;
    }
    flushText();
    return tokens;
  }

  static (Token, int) _readCommand(String source, int i) {
    final name = StringBuffer();
    i++;
    while (i < source.length) {
      final c = source[i];
      if (_alphaRegex.hasMatch(c) || c == r'\') {
        name.write(c);
        i++;
      } else {
        break;
      }
    }
    if (name.isNotEmpty) {
      return (Token(TokenKind.cmd, name.toString()), i);
    }
    if (i < source.length) {
      return (Token(TokenKind.cmd, source[i]), i + 1);
    }
    return (const Token(TokenKind.cmd, r'\'), i);
  }

  static List<TexNode> parse(String source) {
    return _Parser(tokenize(source)).parse();
  }

  static String _superscript(String body) {
    for (final rune in body.runes) {
      final char = String.fromCharCode(rune);
      if (!_supMap.containsKey(char)) {
        return '^($body)';
      }
    }
    final buffer = StringBuffer();
    for (final rune in body.runes) {
      buffer.write(_supMap[String.fromCharCode(rune)]);
    }
    return buffer.toString();
  }

  static String _subscript(String body) {
    for (final rune in body.runes) {
      final char = String.fromCharCode(rune);
      if (!_subMap.containsKey(char)) {
        return '_($body)';
      }
    }
    final buffer = StringBuffer();
    for (final rune in body.runes) {
      buffer.write(_subMap[String.fromCharCode(rune)]);
    }
    return buffer.toString();
  }
}

/// Recursive-descent parser for the token stream.
class _Parser {
  _Parser(this.tokens);

  final List<Token> tokens;
  int _pos = 0;

  Token? get _current => _pos < tokens.length ? tokens[_pos] : null;

  List<TexNode> parse() {
    final items = _sequence();
    if (_current != null) {
      throw ParseError('未期望的标记');
    }
    return items;
  }

  /// `^`/`_` bind to the previous atom (TeX semantics), handled here so
  /// every item (text/group/command) gets scripts attached.
  List<TexNode> _sequence({String? end}) {
    final items = <TexNode>[];
    while (_current != null) {
      final token = _current!;
      if (end != null &&
          ((token.kind == TokenKind.brace || token.kind == TokenKind.brack) &&
              token.value == end)) {
        _pos++;
        return items;
      }
      items.add(
        _attachScripts(_parseItem(), items.isEmpty ? null : items.last),
      );
    }
    if (end != null) {
      throw ParseError('缺少结束标记 $end');
    }
    return items;
  }

  TexNode _parseItem() {
    final token = _current;
    if (token == null) throw ParseError('意外的输入结束');
    switch (token.kind) {
      case TokenKind.text:
        _pos++;
        return TextNode(token.value);
      case TokenKind.cmd:
        return _parseCommand();
      case TokenKind.brace:
        _pos++;
        if (token.value == '}') {
          throw ParseError('未期望的 }');
        }
        return GroupNode(_sequence(end: '}'));
      case TokenKind.brack:
        _pos++;
        if (token.value == ']') {
          throw ParseError('未期望的 ]');
        }
        return GroupNode(_sequence(end: ']'));
      case TokenKind.script:
        throw ParseError('未期望的脚本运算符');
      case TokenKind.amp:
        _pos++;
        return const TextNode('&');
    }
  }

  TexNode _parseCommand() {
    final name = _current!.value;
    _pos++;
    String? optional;
    if (LatexToUnicode._optCmds.contains(name) &&
        _current?.kind == TokenKind.brack) {
      _pos++;
      final value = StringBuffer();
      while (_current?.kind == TokenKind.text) {
        value.write(_current!.value);
        _pos++;
      }
      if (_current?.kind != TokenKind.brack) {
        throw ParseError('\\$name 的可选参数未闭合');
      }
      _pos++;
      optional = value.toString();
    }
    final args = <List<TexNode>>[];
    while (_current?.kind == TokenKind.brace) {
      args.add(_parseBraceGroup());
    }
    return CommandNode(name, optional, args);
  }

  List<TexNode> _parseBraceGroup() {
    _pos++;
    return _sequence(end: '}');
  }

  /// Chaining scripts: [prev] is the sequence item before [item].
  TexNode _attachScripts(TexNode item, TexNode? prev) {
    while (true) {
      final token = _current;
      if (token == null || token.kind != TokenKind.script) break;

      if (item is TextNode &&
          item.content.length > 1 &&
          item.content.startsWith(' ') &&
          prev is ScriptNode) {
        // Leading space before a script is meaningless in math semantics
        // (∫₀¹x not ∫₀¹ x); operator leading spaces are kept (x^2 + 2x).
        if (!'+-=<>...,;)'.contains(item.content[1])) {
          item = TextNode(item.content.substring(1));
        }
      }

      _pos++;
      final body = _scriptArg();
      if (token.value == '^') {
        item = ScriptNode(item, sup: body ?? const TextNode('^'));
      } else {
        item = ScriptNode(item, sub: body ?? const TextNode('_'));
      }
    }
    return item;
  }

  TexNode? _scriptArg() {
    final token = _current;
    if (token == null) return null;

    if (token.kind == TokenKind.brace && token.value == '{') {
      _pos++;
      final items = _sequence(end: '}');
      return items.length == 1 ? items.first : GroupNode(items);
    }

    if (token.kind == TokenKind.text ||
        token.kind == TokenKind.cmd ||
        token.kind == TokenKind.amp) {
      final item = _parseItem();
      if (token.kind == TokenKind.text &&
          item is TextNode &&
          item.content.runes.length > 1) {
        // TeX semantics: ^/_ bind one atom only; the remaining characters
        // roll back as a new text token.
        tokens.insert(
          _pos,
          Token(TokenKind.text, item.content.substring(item.content[0].length)),
        );
        return TextNode(item.content[0]);
      }
      return item;
    }
    return null;
  }
}

/// Walks the AST and produces the Unicode output, collecting warnings for
/// unknown macros.
class Renderer {
  final List<String> warnings = [];

  String render(List<TexNode> nodes) {
    final buffer = StringBuffer();
    for (final node in nodes) {
      buffer.write(_emit(node));
    }
    return buffer.toString();
  }

  String _emit(TexNode node) {
    switch (node) {
      case TextNode(:final content):
        return content;
      case GroupNode(:final items):
        return render(items);
      case ScriptNode(:final base, :final sup, :final sub):
        return _emitScript(base, sup, sub);
      case CommandNode(:final name, :final optional, :final args):
        return _emitCommand(name, optional, args);
    }
  }

  /// First-written script renders first (x_i^2 -> xᵢ², x^2_1 -> x²₁).
  String _emitScript(TexNode base, TexNode? sup, TexNode? sub) {
    final parts = <String>[_emit(base)];
    if (sub != null) parts.add(LatexToUnicode._subscript(_flat(sub)));
    if (sup != null) parts.add(LatexToUnicode._superscript(_flat(sup)));
    return parts.join();
  }

  String _emitCommand(String name, String? optional, List<List<TexNode>> args) {
    final symbol = LatexToUnicode._sym[name];
    if (symbol != null) {
      return symbol;
    }
    final voidCmd = LatexToUnicode._voidCmds[name];
    if (voidCmd != null) {
      return voidCmd;
    }
    if (LatexToUnicode._plainCmds.contains(name)) {
      return args.isEmpty ? '' : render(args.first);
    }
    switch (name) {
      case 'sqrt':
        return _sqrt(optional, args.isEmpty ? null : args.first);
      case 'frac':
        return _frac(args);
    }
    return _unknownMacro(name, args);
  }

  /// Root: `\sqrt{x}` -> √x, `\sqrt[3]{x}` -> ³√x.
  String _sqrt(String? degree, List<TexNode>? body) {
    final core = body == null ? '' : render(body);
    if (core.isEmpty) {
      return '√';
    }
    final isDigit = core.codeUnits.every((c) => c >= 0x30 && c <= 0x39);
    final rendered = (core.runes.length == 1 || isDigit) ? core : '($core)';
    return degree == null
        ? '√$rendered'
        : '${LatexToUnicode._superscript(degree)}√$rendered';
  }

  /// Fraction: `\frac{a}{b}` -> a/b (parenthesized when needed).
  String _frac(List<List<TexNode>> args) {
    final numerator = args.isEmpty ? '' : render(args.first);
    final denominator = args.length > 1 ? render(args[1]) : '';
    return '${_wrap(numerator)}/${_wrap(denominator)}';
  }

  String _wrap(String text) {
    return LatexToUnicode._needsParenRegex.hasMatch(text) ? '($text)' : text;
  }

  String _flat(TexNode node) {
    return switch (node) {
      GroupNode(:final items) => render(items),
      TextNode(:final content) => content,
      _ => render([node]),
    };
  }

  String _unknownMacro(String name, List<List<TexNode>> args) {
    warnings.add('未知宏：\\$name（已保留原文）');
    if (args.isEmpty) {
      return name.isEmpty ? '' : '\\$name ';
    }
    final buffer = StringBuffer('\\$name{');
    for (var i = 0; i < args.length; i++) {
      if (i > 0) buffer.write('}{');
      buffer.write(render(args[i]));
    }
    buffer.write('}');
    return buffer.toString();
  }
}

String _normalizeSpaces(String text) {
  return text.replaceAll(RegExp(r' +'), ' ').trim();
}

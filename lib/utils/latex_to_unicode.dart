/// Converts TeX math source into Unicode text.
///
/// Known boundaries (by design):
/// - Unknown macros render verbatim and are registered in the warnings list;
/// - Malformed input (unclosed `{`) throws [ParseError] and the issue goes
///   to warnings;
/// - Fragments without a Unicode glyph stay in source.
///
/// Reference: pylatexenc (https://github.com/phfaist/pylatexenc, MIT).
library;

import 'package:PiliPlus/utils/latex_unicode_data.dart';

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
  final GroupNode? optional;
  final List<GroupNode> args;
}

/// Base with scripts; chained scripts wrap.
final class ScriptNode extends TexNode {
  const ScriptNode(this.base, {this.sup, this.sub});

  final TexNode base;
  final TexNode? sup;
  final TexNode? sub;
}

/// An environment (`\begin{...}...\end{...}`); matrix envs render as rows.
final class EnvironmentNode extends TexNode {
  const EnvironmentNode(this.name, this.items);

  final String name;
  final List<TexNode> items;
}

abstract final class LatexToUnicode {
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
      if (text[j] == '\$') {
        if (isDisplay) {
          if (j + 1 < text.length && text[j + 1] == '\$') return j;
        } else {
          return j;
        }
      }
    }
    return -1;
  }

  /// String to AST; throws [ParseError] on structural errors.
  static List<TexNode> parse(String source) =>
      Parser(Lexer(source).run()).parse();

  static List<Token> tokenize(String source) => Lexer(source).run();

  /// Whole text styled with a math font.
  ///
  /// A style name must exist in [LatexData.styleOffsets].
  static String fmtMathText(String text, String style) {
    return String.fromCharCodes(
      text.runes.map((r) => _styleCharCode(r, style)),
    );
  }

  static String _superscript(String value) {
    if (value.runes.length == 1) {
      // Letters/digits without a glyph degrade visibly `^(q)`; plain symbols
      // (∞, ∑...) stay bare so ∫₀∞ reads naturally.
      final char =
          LatexData.supMap[value] ?? LatexData.supMap[_styleCharToAscii(value)];
      if (char != null) return char;
      return _alphaNumericRegex.hasMatch(value) ? '^($value)' : value;
    }
    final buffer = StringBuffer();
    for (final ch in value.split('')) {
      final glyph = LatexData.supMap[ch];
      if (glyph == null) return '^($value)';
      buffer.write(glyph);
    }
    return buffer.toString();
  }

  static String _subscript(String value) {
    if (value.runes.length == 1) {
      final char = LatexData.subMap[value];
      if (char != null) return char;
      return _alphaNumericRegex.hasMatch(value) ? '_($value)' : value;
    }
    final buffer = StringBuffer();
    for (final ch in value.split('')) {
      final glyph = LatexData.subMap[ch];
      if (glyph == null) return '_($value)';
      buffer.write(glyph);
    }
    return buffer.toString();
  }
}

class Lexer {
  Lexer(this.source);

  final String source;
  int pos = 0;

  List<Token> run() {
    final List<Token> tokens = [];
    while (pos < source.length) {
      final char = source[pos];
      if (char == '\\') {
        tokens.add(_readCommand());
      } else if (char == '&') {
        tokens.add(const Token(TokenKind.amp, '&'));
        pos++;
      } else if ('{}[]^_'.contains(char)) {
        tokens.add(Token(_punctKinds[char] ?? TokenKind.script, char));
        pos++;
      } else {
        tokens.add(_readText());
      }
    }
    return tokens;
  }

  Token _readText() {
    final start = pos;
    while (pos < source.length && !'\\{}[]^_&'.contains(source[pos])) {
      pos++;
    }
    return Token(TokenKind.text, source.substring(start, pos));
  }

  Token _readCommand() {
    pos++;
    if (pos >= source.length) {
      return const Token(TokenKind.cmd, '\\');
    }
    final char = source[pos];
    if (char == '\\') {
      // Line break request: double backslash literal.
      pos++;
      return const Token(TokenKind.text, '\\');
    }
    if (LatexData.literalChars.contains(char)) {
      pos++;
      return Token(TokenKind.text, char);
    }
    if (char == '\n' || char == '\r') {
      // TeX line continuation: backslash + newline concatenates nearby lines.
      pos++;
      return const Token(TokenKind.text, ' ');
    }
    if (_alphaRegex.hasMatch(char)) {
      final start = pos;
      while (pos < source.length && _alphaRegex.hasMatch(source[pos])) {
        pos++;
      }
      final name = source.substring(start, pos);
      // The first space after a command name is a TeX separator, swallowed
      // for alphabetic names; symbol macros keep it for readability (∩ ∈).
      if (pos < source.length &&
          source[pos] == ' ' &&
          !LatexData.sym.containsKey(name)) {
        pos++;
      }
      return Token(TokenKind.cmd, name);
    }
    pos++;
    return Token(TokenKind.cmd, char);
  }
}

final class Parser {
  Parser(this.tokens);

  final List<Token> tokens;
  int pos = 0;

  List<TexNode> parse() => _sequence();

  List<TexNode> _sequence({String? endToken}) {
    final List<TexNode> items = [];
    while (true) {
      final token = _peek();
      if (token == null) {
        if (endToken != null) {
          final expected = _pairs[endToken] ?? endToken;
          throw ParseError('缺少闭合定界符 $expected');
        }
        return items;
      }
      if (endToken != null && token.value == endToken) {
        // Only raw paired braces/brackets count; escaped literals like \{ are
        // text tokens and must not close a group.
        if ((token.kind == TokenKind.brace &&
                (endToken == '{' || endToken == '}')) ||
            (token.kind == TokenKind.brack &&
                (endToken == '[' || endToken == ']'))) {
          pos++;
          return items;
        }
      }
      final item = _parseItem();
      items.add(_attachScripts(item, items.isEmpty ? null : items.last));
    }
  }

  /// Binds trailing `^` / `_` to the previous atom (supports `x_i^2` chain).
  /// [prev] is the previous sequence item; the leading space is stripped only
  /// after a script node (∫₀¹x), operator spaces are kept (x^2 + 2x).
  TexNode _attachScripts(TexNode item, TexNode? prev) {
    while (true) {
      final token = _peek();
      if (token == null || token.kind != TokenKind.script) break;
      if (item is TextNode &&
          item.content.runes.length > 1 &&
          item.content.startsWith(' ') &&
          prev is ScriptNode &&
          !'+-=<>...,;)'.contains(item.content[1])) {
        item = TextNode(item.content.substring(1));
      }
      pos++;
      final body = _scriptArg();
      if (token.value == '^') {
        item = ScriptNode(item, sup: body ?? const TextNode('^'));
      } else {
        item = ScriptNode(item, sub: body ?? const TextNode('_'));
      }
    }
    return item;
  }

  /// `^`/`_` binding: `{group}` or a single atom; null when nothing follows.
  TexNode? _scriptArg() {
    final token = _peek();
    if (token == null) return null;
    if (token.kind == TokenKind.brace && token.value == '{') {
      pos++;
      final items = _sequence(endToken: '}');
      return items.length == 1 ? items.first : GroupNode(items);
    }
    if (token.kind == TokenKind.text ||
        token.kind == TokenKind.cmd ||
        token.kind == TokenKind.brace ||
        token.kind == TokenKind.amp) {
      var item = _parseItem();
      if (token.kind == TokenKind.text &&
          item is TextNode &&
          item.content.runes.length > 1) {
        // TeX semantics: ^/_ bind one atom only; remaining chars roll back.
        final first = item.content.substring(0, item.content[0].length);
        tokens.insert(
          pos,
          Token(TokenKind.text, item.content.substring(first.length)),
        );
        item = TextNode(first);
      }
      return item;
    }
    return null;
  }

  TexNode _parseItem() {
    final token = _peek();
    if (token == null) {
      throw ParseError('意外的输入结束');
    }
    if (token.kind == TokenKind.text) {
      pos++;
      return TextNode(token.value);
    }
    if (token.kind == TokenKind.brace) {
      pos++;
      return GroupNode(_sequence(endToken: _pairs[token.value]));
    }
    if (token.kind == TokenKind.brack) {
      // Bare brackets outside optional-arg context are literals.
      pos++;
      return TextNode(token.value);
    }
    if (token.kind == TokenKind.script) {
      // Scripts are bound at the sequence level; nothing binds here.
      pos++;
      return TextNode(token.value);
    }
    if (token.kind == TokenKind.amp) {
      pos++;
      return const TextNode('&');
    }
    if (token.kind == TokenKind.cmd) {
      pos++;
      return _parseCommand(token);
    }
    throw ParseError('无法识别的 token: ${token.value}');
  }

  TexNode _parseCommand(Token token) {
    final name = token.value;
    if (name == 'begin') {
      return _parseEnvironment();
    }
    final optional = LatexData.optCmds.contains(name) ? _parseOptional() : null;
    final args =
        (LatexData.sym.containsKey(name) ||
            LatexData.voidCmds.containsKey(name))
        ? <GroupNode>[]
        : _parseRequiredArgs();
    if (args.isEmpty && LatexData.optCmds.contains(name)) {
      final bare = _parseBareArg();
      if (bare != null) {
        return CommandNode(name, optional, [
          GroupNode([bare]),
        ]);
      }
    }
    return CommandNode(name, optional, args);
  }

  /// Bracketless argument (`\sqrt 5` -> 5), skipping layout-only spaces.
  TexNode? _parseBareArg() {
    var token = _peek();
    if (token == null) return null;
    if (token.kind == TokenKind.text) {
      final stripped = token.value.replaceFirst(RegExp(r'^ +'), '');
      if (stripped.isEmpty) {
        pos++;
        return null;
      }
      if (stripped != token.value) {
        tokens[pos] = Token(TokenKind.text, stripped);
        token = tokens[pos];
      }
    }
    var item = _parseItem();
    if (item is TextNode && item.content.runes.length > 1) {
      final first = item.content.substring(0, item.content[0].length);
      tokens.insert(
        pos,
        Token(TokenKind.text, item.content.substring(first.length)),
      );
      item = TextNode(first);
    }
    return item;
  }

  GroupNode? _parseOptional() {
    final token = _peek();
    if (token != null && token.value == '[') {
      pos++;
      return GroupNode(_sequence(endToken: ']'));
    }
    return null;
  }

  /// Consecutive `{..}` required args (bare groups of arg-less macros too).
  List<GroupNode> _parseRequiredArgs() {
    final List<GroupNode> args = [];
    while (true) {
      final token = _peek();
      if (token == null ||
          token.kind != TokenKind.brace ||
          token.value != '{') {
        break;
      }
      pos++;
      args.add(GroupNode(_sequence(endToken: '}')));
    }
    return args;
  }

  EnvironmentNode _parseEnvironment() {
    final args = _parseRequiredArgs();
    final envName = args.isNotEmpty ? _groupText(args.first) : '';
    final items = _sequenceUntilEnd(envName);
    return EnvironmentNode(envName, items);
  }

  List<TexNode> _sequenceUntilEnd(String envName) {
    final List<TexNode> items = [];
    while (true) {
      final token = _peek();
      if (token == null) {
        throw ParseError('环境 $envName 缺少 \\end{$envName}');
      }
      if (token.kind == TokenKind.cmd) {
        pos++;
        final maybeEnd = _parseCommand(token);
        if (maybeEnd is CommandNode && maybeEnd.name == 'end') {
          final endName = maybeEnd.args.isNotEmpty
              ? _groupText(maybeEnd.args.first)
              : '';
          if (endName == envName) {
            return items;
          }
          throw ParseError(
            '环境闭合不匹配: \\begin{$envName} 对 \\end{$endName}',
          );
        }
        items.add(
          _attachScripts(maybeEnd, items.isEmpty ? null : items.last),
        );
        continue;
      }
      items.add(
        _attachScripts(_parseItem(), items.isEmpty ? null : items.last),
      );
    }
  }

  static String _groupText(TexNode node) {
    if (node is GroupNode &&
        node.items.length == 1 &&
        node.items.first is TextNode) {
      return (node.items.first as TextNode).content;
    }
    return '';
  }

  Token? _peek() => pos < tokens.length ? tokens[pos] : null;
}

int _styleCharCode(int code, String style) {
  final char = String.fromCharCode(code);
  final exception = LatexData.styleExceptions[style]?[char];
  if (exception != null) return exception.codeUnitAt(0);
  final (offsetUp, offsetLo) = LatexData.styleOffsets[style]!;
  if (code >= 0x41 && code <= 0x5A) return offsetUp + code - 0x41;
  if (code >= 0x61 && code <= 0x7A) return offsetLo + code - 0x61;
  if (code >= 0x30 &&
      code <= 0x39 &&
      LatexData.digitOffsets.containsKey(style)) {
    return LatexData.digitOffsets[style]! + code - 0x30;
  }
  return code;
}

/// Math-font char back to ASCII letter (for script-glyph fallback).
String _styleCharToAscii(String char) {
  final code = char.runes.first;
  for (final (up, lo) in LatexData.styleOffsets.values) {
    if (code >= up && code < up + 26) {
      return String.fromCharCode(0x41 + code - up);
    }
    if (code >= lo && code < lo + 26) {
      return String.fromCharCode(0x61 + code - lo);
    }
  }
  for (final exceptions in LatexData.styleExceptions.values) {
    for (final entry in exceptions.entries) {
      if (entry.value.codeUnitAt(0) == code) return entry.key;
    }
  }
  return char;
}

bool _needsParen(String value) {
  // Top-level un-paired composite like n(n+1) gets one extra paren layer.
  return value.runes.length > 1 &&
      value.contains(RegExp(r'[+\-= /]')) &&
      !_isParenWrapped(value);
}

String _wrap(String value) => _needsParen(value) ? '($value)' : value;

/// Whether parens open at char 0 and close exactly at the end.
bool _isParenWrapped(String value) {
  if (!value.startsWith('(') || !value.endsWith(')')) return false;
  var depth = 0;
  for (var i = 0; i < value.length; i++) {
    final char = value[i];
    if (char == '(') {
      depth++;
    } else if (char == ')') {
      depth--;
      if (depth == 0 && i != value.length - 1) return false;
      if (depth < 0) return false;
    }
  }
  return depth == 0;
}

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
      case EnvironmentNode(:final name, :final items):
        return _emitEnvironment(name, items);
    }
  }

  /// First-written script renders first (x_i^2 -> xᵢ², x^2_1 -> x²₁).
  String _emitScript(TexNode base, TexNode? sup, TexNode? sub) {
    final parts = <String>[_emit(base)];
    if (sub != null) parts.add(LatexToUnicode._subscript(_flat(sub)));
    if (sup != null) parts.add(LatexToUnicode._superscript(_flat(sup)));
    return parts.join();
  }

  String _emitCommand(
    String name,
    GroupNode? optional,
    List<GroupNode> args,
  ) {
    final argText = args.map((g) => render(g.items)).toList();
    final symbol = LatexData.sym[name];
    if (symbol != null) return symbol;
    final voidCmd = LatexData.voidCmds[name];
    if (voidCmd != null) return voidCmd;
    final styleCmd = LatexData.styleCmds[name];
    if (styleCmd != null) {
      return LatexToUnicode.fmtMathText(
        argText.isEmpty ? '' : argText.first,
        styleCmd,
      );
    }
    if (LatexData.plainCmds.contains(name)) {
      return argText.isEmpty ? '' : argText.first;
    }
    final accent = LatexData.accents[name];
    if (accent != null) {
      return (argText.isEmpty ? '' : argText.first) + accent;
    }
    return _emitMathOp(name, optional, argText);
  }

  String _emitMathOp(String name, GroupNode? optional, List<String> argText) {
    final first = argText.isEmpty ? '' : argText.first;
    if (name == 'sqrt') {
      return _sqrt(optional, argText);
    }
    if (name == 'color') {
      return argText.length > 1 ? argText.sublist(1).join() : '';
    }
    if (name == 'frac' || name == 'dfrac') {
      return _frac(argText);
    }
    if (name == 'binom' || name == 'dbinom' || name == 'tbinom') {
      return 'C($first, ${argText.length > 1 ? argText[1] : ''})';
    }
    if (name == 'pmod') {
      return '(mod $first)';
    }
    if (name == 'bmod') {
      return 'mod ';
    }
    if (name == 'det') {
      return 'det${first.isNotEmpty ? '($first)' : ''}';
    }
    if (name == 'overset' || name == 'stackrel' || name == 'underset') {
      return _stack(argText);
    }
    return _unknownMacro(name, argText);
  }

  /// Unknown macro keeps all args verbatim; trailing space prevents gluing.
  String _unknownMacro(String name, List<String> argText) {
    warnings.add('未知宏：\\$name');
    if (argText.isEmpty) {
      return '\\$name ';
    }
    final buffer = StringBuffer('\\$name');
    for (final text in argText) {
      buffer.write('{$text}');
    }
    return buffer.toString();
  }

  /// Root: `\sqrt{x}` -> √x, `\sqrt[3]{x}` -> ³√x.
  String _sqrt(GroupNode? optional, List<String> argText) {
    final body = argText.isEmpty ? '' : argText.first;
    final isDigit =
        body.isNotEmpty && body.codeUnits.every((c) => c >= 0x30 && c <= 0x39);
    final core = (body.runes.length == 1 || isDigit) ? body : '($body)';
    final degree = optional == null
        ? ''
        : LatexToUnicode._superscript(render(optional.items));
    return '$degree√$core';
  }

  /// Fraction: numerator/denominator, parenthesized when needed.
  String _frac(List<String> argText) {
    final numerator = argText.isEmpty ? '' : argText.first;
    final denominator = argText.length > 1 ? argText[1] : '';
    return '${_wrap(numerator)}/${_wrap(denominator)}';
  }

  /// Stack: base(annotation) (`\overset{a}{b}` -> b(a)).
  String _stack(List<String> argText) {
    final first = argText.isEmpty ? '' : argText.first;
    final base = argText.length > 1 ? argText[1] : '';
    return '$base($first)';
  }

  /// Matrix envs output `[ row ; row ]`; others render their sequence.
  String _emitEnvironment(String name, List<TexNode> items) {
    if (!LatexData.matrixEnvs.contains(name)) {
      return render(items);
    }
    final List<List<String>> rows = [];
    var cells = <String>[];
    var cell = StringBuffer();
    void flushRow() {
      if (cell.isNotEmpty) cells.add(cell.toString());
      rows.add(List.of(cells));
      cells = [];
      cell = StringBuffer();
    }

    for (final item in items) {
      if (item is TextNode && item.content == '&') {
        cells.add(cell.toString());
        cell = StringBuffer();
      } else if (item is TextNode && item.content == '\\') {
        flushRow();
      } else {
        cell.write(_emit(item));
      }
    }
    flushRow();
    final kept = rows.where((r) => r.any((c) => c.trim().isNotEmpty)).toList();
    if (kept.isEmpty) return '';
    if (kept.length == 1) {
      // A single row keeps the compact inline form (font-agnostic).
      return '[ ${kept.first.join(' ')} ]';
    }
    return _frameMatrix(kept);
  }

  String _flat(TexNode node) {
    return switch (node) {
      GroupNode(:final items) => render(items),
      TextNode(:final content) => content,
      _ => render([node]),
    };
  }
}

/// Box frame around a multi-row matrix, cells centered on [LatexData.padChar]
/// (figure space: half-width monospace, flattening-proof). Column width is
/// measured on the rendered cells, so nested formulas align too.
String _frameMatrix(List<List<String>> sourceRows, {int pad = 2}) {
  final rows = sourceRows.map((r) => r.map((c) => c.trim()).toList()).toList();
  final cols = rows.map((r) => r.length).reduce((a, b) => a > b ? a : b);
  final widths = List<int>.filled(cols, 0);
  for (final r in rows) {
    for (var i = 0; i < r.length; i++) {
      if (r[i].length > widths[i]) widths[i] = r[i].length;
    }
  }
  String center(String s, int w) {
    final rest = w - s.length;
    final l = rest ~/ 2;
    return LatexData.padChar * l + s + LatexData.padChar * (rest - l);
  }

  List<String> content(List<String> row) => [
    for (var i = 0; i < cols; i++)
      i < row.length
          ? center(row[i], widths[i] + 2 * pad)
          : LatexData.padChar * (widths[i] + 2 * pad),
  ];
  final lines = rows.map((r) => content(r).join(LatexData.padChar)).toList();
  final maxw = lines.map((s) => s.length).reduce((a, b) => a > b ? a : b);
  final buffer = StringBuffer('┌${LatexData.padChar * maxw}┐');
  for (final line in lines) {
    buffer.write('\n│$line│');
  }
  buffer.write('\n└${LatexData.padChar * maxw}┘');
  return buffer.toString();
}

const Map<String, TokenKind> _punctKinds = {
  '{': TokenKind.brace,
  '}': TokenKind.brace,
  '[': TokenKind.brack,
  ']': TokenKind.brack,
};

const Map<String, String> _pairs = {'{': '}', '}': '{', '[': ']', ']': '['};

final RegExp _alphaRegex = RegExp(r'^[\p{L}]$', unicode: true);
final RegExp _alphaNumericRegex = RegExp(r'^[\p{L}\p{N}]$', unicode: true);

String _normalizeSpaces(String text) {
  return text.replaceAll(RegExp(r' +'), ' ');
}

// Run with the prepared application's package_config and the official OHOS Dart
// SDK. Compilation must succeed without enabling experimental language features.
import 'package:petitparser/debug.dart';
import 'package:petitparser/indent.dart';
import 'package:petitparser/petitparser.dart';
import 'package:petitparser/reflection.dart';
import 'package:xml/xml.dart';

void check(bool value, String scenario) {
  if (!value) throw StateError('petitparser compatibility failed: $scenario');
}

class ValuesGrammar extends GrammarDefinition<List<int>> {
  @override
  Parser<List<int>> start() => ref0(values).end();

  Parser<List<int>> values() => digit()
      .plus()
      .flatten()
      .map(int.parse)
      .plusSeparated(char(','))
      .map((value) => value.elements);
}

void main() {
  final integer = digit().plus().flatten().map(int.parse).end();
  check(integer.parse('123').value == 123, 'integer mapping');
  check(integer.parse('123x') is Failure, 'complete-input failure');
  check(char('A', ignoreCase: true).parse('a') is Success, 'character factory');
  check(char('😀', unicode: true).end().parse('😀').value == '😀',
      'Unicode character factory');
  check(pattern('a-z0-9').plus().flatten().parse('a1z').value == 'a1z',
      'range and lookup predicates');
  check(ValuesGrammar().build().parse('1,20,300').value.join('|') == '1|20|300',
      'grammar references and separated lists');

  final builder = ExpressionBuilder<num>();
  builder.primitive(digit().plus().flatten().trim().map(num.parse));
  builder.group().wrapper(char('(').trim(), char(')').trim(),
      (left, value, right) => value);
  builder.group().prefix(char('-').trim(), (operator, value) => -value);
  builder.group().left(char('*').trim(), (left, operator, right) => left * right);
  builder.group().left(char('+').trim(), (left, operator, right) => left + right);
  final expression = builder.build().end();
  check(expression.parse('1 + 2 * 3').value == 7, 'operator precedence');
  check(expression.parse('-(1 + 2) * 3').value == -9, 'wrapper and prefix');

  const token = Token('b', 'a\r\nb', 3, 4);
  check(token.line == 2 && token.column == 1, 'CRLF token position');
  check(letter().plus().flatten().allMatches('one two').join('|') == 'one|two',
      'matcher iterators');
  check(Analyzer(integer).parsers.isNotEmpty, 'reflection constructors');
  check(Indent().same.parse('') is Success, 'indentation constructor');
  var profiles = 0;
  check(profile(integer, output: (frame) => profiles++)
      .parse('42').value == 42 && profiles > 0, 'debug profile constructors');

  final document = XmlDocument.parse('<root><item id="1">A &amp; B</item></root>');
  final item = document.rootElement.getElement('item')!;
  check(item.getAttribute('id') == '1' && item.innerText == 'A & B',
      'upstream XML dependency integration');
  print('petitparser 7.1.0: Dart 3.12 kernel and parsing checks passed');
}

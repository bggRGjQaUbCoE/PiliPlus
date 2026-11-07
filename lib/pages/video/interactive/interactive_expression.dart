/// 互动视频受限表达式引擎。
///
/// 语法（基于真实 edgeinfo_v2 样本）：
/// - 语句：多语句以 `;` 分隔（末尾 `;` 可省略）；每条语句是赋值或纯表达式；
/// - 赋值：`$var = expr`（变量以 `$` 开头，与 id_v2 一致；亦兼容无 `$` 前缀的
///   字母/数字/下划线标识符）；
/// - 运算：`+ - * /`（截断除法语义未确认，样本仅出现 `+ -`；`/` 按浮点除法，
///   `%` 未在样本出现，按取模支持）、一元 `- +`；
/// - 比较：`== != > >= < <=`，结果 1.0/0.0；
/// - 逻辑：`&& || !`，短路求值，结果 1.0/0.0；
/// - 字面量：整数/小数，如 `1`、`1.00`、`.5`、`1e3`；负数经一元负号；
/// - 括号分组；空白（含全角空格）忽略。
///
/// 实现：纯 Dart tokenizer/parser/evaluator 三层，无 eval、无字符串替换执行。
/// 任何词法/语法/求值错误都返回 [ExpressionFailure]，由调用方决定回退策略；
/// 不抛出异常，保证单条坏表达式不影响整个互动节点。
library;

/// 表达式诊断信息（调试日志用）。
class ExpressionFailure {
  final String source;
  final String stage;
  final int offset;
  final String message;

  const ExpressionFailure(this.source, this.stage, this.offset, this.message);

  @override
  String toString() =>
      'ExpressionFailure($stage@$offset: $message, src="$source")';
}

/// 词法单元。
enum TokenType {
  number,
  variable,
  identifier,
  plus, // +
  minus, // -
  star, // *
  slash, // /
  percent, // %
  assign, // =
  eq, // ==
  ne, // !=
  gt, // >
  ge, // >=
  lt, // <
  le, // <=
  and, // &&
  or, // ||
  not, // !
  lparen,
  rparen,
  semicolon,
  end,
}

class Token {
  final TokenType type;
  final String text;
  final double? number;
  final int offset;

  const Token(this.type, this.text, {this.number, this.offset = 0});

  @override
  String toString() => 'Token($type, "$text")';
}

/// 将源码切分为 [Token] 列表；非法字符中止并返回失败。
(Object, ExpressionFailure?) tokenize(String source) {
  final List<Token> tokens = <Token>[];
  int i = 0;
  while (i < source.length) {
    final String ch = source[i];
    // 空白（含全角空格 U+3000、不间断空格）
    if (ch == ' ' ||
        ch == '\t' ||
        ch == '\n' ||
        ch == '\r' ||
        ch == '　' ||
        ch == ' ') {
      i++;
      continue;
    }
    // 数字字面量（不允许变量后紧跟数字，如 $a1 由变量扫描处理）
    if (_isDigit(ch) ||
        (ch == '.' && i + 1 < source.length && _isDigit(source[i + 1]))) {
      final int start = i;
      bool seenDot = false;
      while (i < source.length && (_isDigit(source[i]) || source[i] == '.')) {
        if (source[i] == '.') {
          if (seenDot) {
            break;
          }
          seenDot = true;
        }
        i++;
      }
      // 科学计数法 1e3 / 1e-3
      if (i < source.length &&
          (source[i] == 'e' || source[i] == 'E') &&
          i + 1 < source.length &&
          (_isDigit(source[i + 1]) ||
              ((source[i + 1] == '+' || source[i + 1] == '-') &&
                  i + 2 < source.length &&
                  _isDigit(source[i + 2])))) {
        i += 2;
        while (i < source.length && _isDigit(source[i])) {
          i++;
        }
      }
      final String text = source.substring(start, i);
      final double? value = double.tryParse(text);
      if (value == null) {
        return (
          tokens,
          ExpressionFailure(source, 'lexer', start, '非法数字 "$text"'),
        );
      }
      tokens.add(Token(TokenType.number, text, number: value, offset: start));
      continue;
    }
    // 变量 $xxx
    if (ch == r'$') {
      final int start = i;
      i++;
      while (i < source.length && _isWordChar(source[i])) {
        i++;
      }
      // 变量名保留 `$` 前缀，与 hidden_vars 的 id_v2 完全对齐
      final String text = source.substring(start, i);
      if (text.isEmpty) {
        return (
          tokens,
          ExpressionFailure(source, 'lexer', start, r'"$" 后缺少变量名'),
        );
      }
      tokens.add(Token(TokenType.variable, text, offset: start));
      continue;
    }
    // 标识符（兼容无 $ 前缀变量）
    if (_isAlpha(ch)) {
      final int start = i;
      while (i < source.length && _isWordChar(source[i])) {
        i++;
      }
      tokens.add(
        Token(TokenType.identifier, source.substring(start, i), offset: start),
      );
      continue;
    }
    // 运算符
    final (TokenType?, int) op = _matchOperator(source, i);
    if (op.$1 == null) {
      return (
        tokens,
        ExpressionFailure(source, 'lexer', i, '无法识别的字符 "$ch"'),
      );
    }
    tokens.add(
      Token(op.$1!, source.substring(i, i + op.$2), offset: i),
    );
    i += op.$2;
  }
  tokens.add(Token(TokenType.end, '', offset: source.length));
  return (tokens, null);
}

(TokenType?, int) _matchOperator(String s, int i) {
  final String two = i + 1 < s.length ? s.substring(i, i + 2) : '';
  switch (two) {
    case '==':
      return (TokenType.eq, 2);
    case '!=':
      return (TokenType.ne, 2);
    case '>=':
      return (TokenType.ge, 2);
    case '<=':
      return (TokenType.le, 2);
    case '&&':
      return (TokenType.and, 2);
    case '||':
      return (TokenType.or, 2);
    // 常见变体：中文全角、连续比较的容错不算成功——仅按字面支持。
  }
  switch (s[i]) {
    case '+':
      return (TokenType.plus, 1);
    case '-':
      return (TokenType.minus, 1);
    case '*':
      return (TokenType.star, 1);
    case '/':
      return (TokenType.slash, 1);
    case '%':
      return (TokenType.percent, 1);
    case '>':
      return (TokenType.gt, 1);
    case '<':
      return (TokenType.lt, 1);
    case '!':
      return (TokenType.not, 1);
    case '(':
      return (TokenType.lparen, 1);
    case ')':
      return (TokenType.rparen, 1);
    case ';':
      return (TokenType.semicolon, 1);
    case '=':
      // 单个 = 按赋值处理
      return (TokenType.assign, 1);
  }
  return (null, 0);
}

bool _isDigit(String ch) =>
    ch.codeUnitAt(0) >= 0x30 && ch.codeUnitAt(0) <= 0x39;

bool _isAlpha(String ch) {
  final int c = ch.codeUnitAt(0);
  return (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A) || c > 0x7F;
}

bool _isWordChar(String ch) => _isDigit(ch) || _isAlpha(ch) || ch == '_';

/// AST 节点。
sealed class ExprNode {
  const ExprNode();
}

class NumberNode extends ExprNode {
  final double value;
  const NumberNode(this.value);
}

class VarNode extends ExprNode {
  final String name;
  const VarNode(this.name);
}

class UnaryNode extends ExprNode {
  final TokenType op; // minus / not / plus
  final ExprNode operand;
  const UnaryNode(this.op, this.operand);
}

class BinaryNode extends ExprNode {
  final TokenType op; // + - * / % == != > >= < <= && ||
  final ExprNode left;
  final ExprNode right;
  const BinaryNode(this.op, this.left, this.right);
}

class AssignNode extends ExprNode {
  final String name;
  final ExprNode value;
  const AssignNode(this.name, this.value);
}

/// 解析后的程序：语句列表。
class Program {
  final List<ExprNode> statements;
  final String source;
  const Program(this.statements, this.source);
}

/// 递归下降解析器。运算优先级从低到高：
/// 赋值、`||`、`&&`、`== !=`、`> >= < <=`、`+ -`、`* / %`、一元、主。
class Parser {
  final List<Token> tokens;
  final String source;
  int pos = 0;

  Parser(this.tokens, this.source);

  (Program?, ExpressionFailure?) parse() {
    final List<ExprNode> statements = <ExprNode>[];
    while (true) {
      final Token tok = peek();
      if (tok.type == TokenType.end) {
        break;
      }
      if (tok.type == TokenType.semicolon) {
        // 空语句（";;"）跳过
        pos++;
        continue;
      }
      final (ExprNode?, ExpressionFailure?) node = parseExpression();
      if (node.$1 == null) {
        return (
          null,
          node.$2 ?? ExpressionFailure(source, 'parser', tok.offset, '表达式无法解析'),
        );
      }
      if (node.$2 != null) {
        return (null, node.$2);
      }
      statements.add(node.$1!);
      final Token after = peek();
      if (after.type == TokenType.semicolon) {
        pos++;
        continue;
      }
      if (after.type != TokenType.end) {
        return (
          null,
          ExpressionFailure(
            source,
            'parser',
            after.offset,
            '语句后存在多余内容 "${after.text}"',
          ),
        );
      }
    }
    return (Program(statements, source), null);
  }

  Token peek() => tokens[pos];

  /// 表达式入口：赋值或普通表达式。
  (ExprNode?, ExpressionFailure?) parseExpression() {
    // 赋值形式：variable = expr
    final Token first = peek();
    if (first.type == TokenType.variable ||
        first.type == TokenType.identifier) {
      // 向前看一个 token 判断是否赋值
      if (pos + 1 < tokens.length && tokens[pos + 1].type == TokenType.assign) {
        final String name = first.text;
        pos += 2;
        final (ExprNode?, ExpressionFailure?) rhs = parseOr();
        if (rhs.$2 != null || rhs.$1 == null) {
          return (null, rhs.$2);
        }
        return (AssignNode(name, rhs.$1!), null);
      }
    }
    return parseOr();
  }

  (ExprNode?, ExpressionFailure?) parseOr() {
    (ExprNode?, ExpressionFailure?) left = parseAnd();
    if (left.$1 == null) {
      return (null, left.$2 ?? _unexpected());
    }
    while (peek().type == TokenType.or) {
      pos++;
      final (ExprNode?, ExpressionFailure?) right = parseAnd();
      if (right.$2 != null || right.$1 == null) {
        return (null, right.$2);
      }
      left = (BinaryNode(TokenType.or, left.$1!, right.$1!), null);
    }
    return left;
  }

  (ExprNode?, ExpressionFailure?) parseAnd() {
    (ExprNode?, ExpressionFailure?) left = parseEquality();
    if (left.$1 == null) {
      return (null, left.$2 ?? _unexpected());
    }
    while (peek().type == TokenType.and) {
      pos++;
      final (ExprNode?, ExpressionFailure?) right = parseEquality();
      if (right.$2 != null || right.$1 == null) {
        return (null, right.$2);
      }
      left = (BinaryNode(TokenType.and, left.$1!, right.$1!), null);
    }
    return left;
  }

  (ExprNode?, ExpressionFailure?) parseEquality() {
    (ExprNode?, ExpressionFailure?) left = parseComparison();
    if (left.$1 == null) {
      return (null, left.$2 ?? _unexpected());
    }
    while (peek().type == TokenType.eq || peek().type == TokenType.ne) {
      final TokenType op = peek().type;
      pos++;
      final (ExprNode?, ExpressionFailure?) right = parseComparison();
      if (right.$2 != null || right.$1 == null) {
        return (null, right.$2);
      }
      left = (BinaryNode(op, left.$1!, right.$1!), null);
    }
    return left;
  }

  (ExprNode?, ExpressionFailure?) parseComparison() {
    (ExprNode?, ExpressionFailure?) left = parseAdditive();
    if (left.$1 == null) {
      return (null, left.$2 ?? _unexpected());
    }
    while (peek().type == TokenType.gt ||
        peek().type == TokenType.ge ||
        peek().type == TokenType.lt ||
        peek().type == TokenType.le) {
      final TokenType op = peek().type;
      pos++;
      final (ExprNode?, ExpressionFailure?) right = parseAdditive();
      if (right.$2 != null || right.$1 == null) {
        return (null, right.$2);
      }
      left = (BinaryNode(op, left.$1!, right.$1!), null);
    }
    return left;
  }

  (ExprNode?, ExpressionFailure?) parseAdditive() {
    (ExprNode?, ExpressionFailure?) left = parseMultiplicative();
    if (left.$1 == null) {
      return (null, left.$2 ?? _unexpected());
    }
    while (peek().type == TokenType.plus || peek().type == TokenType.minus) {
      final TokenType op = peek().type;
      pos++;
      final (ExprNode?, ExpressionFailure?) right = parseMultiplicative();
      if (right.$2 != null || right.$1 == null) {
        return (null, right.$2);
      }
      left = (BinaryNode(op, left.$1!, right.$1!), null);
    }
    return left;
  }

  (ExprNode?, ExpressionFailure?) parseMultiplicative() {
    (ExprNode?, ExpressionFailure?) left = parseUnary();
    if (left.$1 == null) {
      return (null, left.$2 ?? _unexpected());
    }
    while (peek().type == TokenType.star ||
        peek().type == TokenType.slash ||
        peek().type == TokenType.percent) {
      final TokenType op = peek().type;
      pos++;
      final (ExprNode?, ExpressionFailure?) right = parseUnary();
      if (right.$2 != null || right.$1 == null) {
        return (null, right.$2);
      }
      left = (BinaryNode(op, left.$1!, right.$1!), null);
    }
    return left;
  }

  /// 兜底失败（理论上不可达；防止 (null, null) 逃逸）。
  ExpressionFailure _unexpected() =>
      ExpressionFailure(source, 'parser', peek().offset, '表达式无法解析');

  (ExprNode?, ExpressionFailure?) parseUnary() {
    final Token tok = peek();
    if (tok.type == TokenType.minus || tok.type == TokenType.plus) {
      pos++;
      final (ExprNode?, ExpressionFailure?) operand = parseUnary();
      if (operand.$2 != null || operand.$1 == null) {
        return (null, operand.$2);
      }
      return (UnaryNode(tok.type, operand.$1!), null);
    }
    if (tok.type == TokenType.not) {
      pos++;
      final (ExprNode?, ExpressionFailure?) operand = parseUnary();
      if (operand.$2 != null || operand.$1 == null) {
        return (null, operand.$2);
      }
      return (UnaryNode(TokenType.not, operand.$1!), null);
    }
    return parsePrimary();
  }

  (ExprNode?, ExpressionFailure?) parsePrimary() {
    final Token tok = peek();
    switch (tok.type) {
      case TokenType.number:
        pos++;
        return (NumberNode(tok.number!), null);
      case TokenType.variable:
      case TokenType.identifier:
        pos++;
        return (VarNode(tok.text), null);
      case TokenType.lparen:
        pos++;
        final (ExprNode?, ExpressionFailure?) inner = parseOr();
        if (inner.$2 != null || inner.$1 == null) {
          return (null, inner.$2);
        }
        if (peek().type != TokenType.rparen) {
          return (
            null,
            ExpressionFailure(source, 'parser', peek().offset, '缺少右括号'),
          );
        }
        pos++;
        return (inner.$1, null);
      case TokenType.end:
        return (
          null,
          ExpressionFailure(source, 'parser', tok.offset, '表达式意外结束'),
        );
      default:
        return (
          null,
          ExpressionFailure(
            source,
            'parser',
            tok.offset,
            '意外的符号 "${tok.text}"',
          ),
        );
    }
  }
}

/// 求值环境：变量名 → 值。
typedef ExpressionEnv = Map<String, double>;

/// 编译缓存，避免同一表达式反复 parse。
final Map<String, (Program?, ExpressionFailure?)> _programCache =
    <String, (Program?, ExpressionFailure?)>{};

/// 编译表达式；失败返回 (null, failure)。
(Program?, ExpressionFailure?) compile(String source) {
  final cached = _programCache[source];
  if (cached != null) {
    return cached;
  }
  final (Object tokens, ExpressionFailure? lexErr) = tokenize(source);
  if (lexErr != null) {
    final result = (null as Program?, lexErr);
    if (_programCache.length < 512) {
      _programCache[source] = result;
    }
    return result;
  }
  final (Program?, ExpressionFailure?) parsed = Parser(
    tokens as List<Token>,
    source,
  ).parse();
  if (_programCache.length < 512) {
    _programCache[source] = parsed;
  }
  return parsed;
}

/// 求值结果。
sealed class EvalResult {
  const EvalResult();
}

class EvalValue extends EvalResult {
  final double value;
  const EvalValue(this.value);

  bool get asBool => value != 0;
}

class EvalFailure extends EvalResult {
  final String message;
  const EvalFailure(this.message);
}

/// 求值单个表达式节点（纯函数）。
EvalResult evalNode(
  ExprNode node,
  ExpressionEnv env, {
  List<ExpressionFailure>? log,
  String source = '',
}) {
  switch (node) {
    case NumberNode(:final value):
      return EvalValue(value);
    case VarNode(:final name):
      final double? v = env[name];
      if (v == null) {
        return EvalFailure('未知变量 "$name"');
      }
      return EvalValue(v);
    case UnaryNode(:final op, :final operand):
      final EvalResult v = evalNode(operand, env, log: log, source: source);
      if (v is EvalFailure) {
        return v;
      }
      final double x = (v as EvalValue).value;
      switch (op) {
        case TokenType.minus:
          return EvalValue(-x);
        case TokenType.plus:
          return EvalValue(x);
        case TokenType.not:
          return EvalValue(x == 0 ? 1 : 0);
        default:
          return const EvalFailure('未知一元运算');
      }
    case BinaryNode(:final op, :final left, :final right):
      switch (op) {
        case TokenType.and:
        case TokenType.or:
          // 短路求值
          final EvalResult l = evalNode(left, env, log: log, source: source);
          if (l is EvalFailure) {
            return l;
          }
          final bool lb = (l as EvalValue).asBool;
          if (op == TokenType.and && !lb) {
            return const EvalValue(0);
          }
          if (op == TokenType.or && lb) {
            return const EvalValue(1);
          }
          final EvalResult r = evalNode(right, env, log: log, source: source);
          if (r is EvalFailure) {
            return r;
          }
          return EvalValue((r as EvalValue).asBool ? 1 : 0);
        default:
          final EvalResult l = evalNode(left, env, log: log, source: source);
          if (l is EvalFailure) {
            return l;
          }
          final EvalResult r = evalNode(right, env, log: log, source: source);
          if (r is EvalFailure) {
            return r;
          }
          final double a = (l as EvalValue).value;
          final double b = (r as EvalValue).value;
          switch (op) {
            case TokenType.plus:
              return EvalValue(a + b);
            case TokenType.minus:
              return EvalValue(a - b);
            case TokenType.star:
              return EvalValue(a * b);
            case TokenType.slash:
              if (b == 0) {
                return const EvalFailure('除数为 0');
              }
              return EvalValue(a / b);
            case TokenType.percent:
              if (b == 0) {
                return const EvalFailure('取模除数为 0');
              }
              return EvalValue(a % b);
            case TokenType.eq:
              return EvalValue(a == b ? 1 : 0);
            case TokenType.ne:
              return EvalValue(a != b ? 1 : 0);
            case TokenType.gt:
              return EvalValue(a > b ? 1 : 0);
            case TokenType.ge:
              return EvalValue(a >= b ? 1 : 0);
            case TokenType.lt:
              return EvalValue(a < b ? 1 : 0);
            case TokenType.le:
              return EvalValue(a <= b ? 1 : 0);
            default:
              return const EvalFailure('未知二元运算');
          }
      }
    case AssignNode(:final name, :final value):
      final EvalResult v = evalNode(value, env, log: log, source: source);
      if (v is EvalFailure) {
        return v;
      }
      env[name] = (v as EvalValue).value;
      return v;
  }
}

/// 求值结果：执行多条语句后的最终值（最后一条语句的值）。
(Object result, ExpressionFailure? failure) evalProgram(
  Program program,
  ExpressionEnv env, {
  List<ExpressionFailure>? log,
}) {
  Object last = const EvalValue(0);
  for (final ExprNode stmt in program.statements) {
    final EvalResult r = evalNode(stmt, env, log: log, source: program.source);
    if (r is EvalFailure) {
      final ExpressionFailure failure = ExpressionFailure(
        program.source,
        'eval',
        0,
        r.message,
      );
      log?.add(failure);
      return (r, failure);
    }
    last = r;
  }
  return (last, null);
}

/// 便捷方法：编译并求值。
/// 返回 (value, failure)。成功时 failure 为 null。
(Object, ExpressionFailure?) evaluate(
  String source,
  ExpressionEnv env, {
  List<ExpressionFailure>? log,
}) {
  final (Program? program, ExpressionFailure? err) = compile(source);
  if (err != null || program == null) {
    log?.add(err!);
    return (const EvalValue(0), err);
  }
  return evalProgram(program, env, log: log);
}

/// 条件求值：成立返回 true；求值失败或结果为 0 返回 false（保守策略）。
(bool, ExpressionFailure?) evalCondition(
  String condition,
  ExpressionEnv env, {
  List<ExpressionFailure>? log,
}) {
  final (Object result, ExpressionFailure? err) = evaluate(
    condition,
    env,
    log: log,
  );
  if (err != null) {
    return (false, err);
  }
  if (result is EvalValue) {
    return (result.asBool, null);
  }
  return (false, ExpressionFailure(condition, 'eval', 0, '未知求值结果'));
}

/// 执行 native_action 语句序列；在 [env] 原地修改。
/// 任一语句失败即中止（env 可能已被部分修改——调用方需在副本上执行）。
(Object, ExpressionFailure?) evalAction(
  String action,
  ExpressionEnv env, {
  List<ExpressionFailure>? log,
}) {
  return evaluate(action, env, log: log);
}

import 'package:PiliPlus/pages/video/interactive/interactive_expression.dart';
import 'package:flutter_test/flutter_test.dart';

/// 求值成功则返回数值，失败返回 null 并可断言 [failure]。
double? _num(String src, ExpressionEnv env) {
  final (Object result, ExpressionFailure? err) = evaluate(src, env);
  if (err != null) {
    return null;
  }
  return (result as EvalValue).value;
}

ExpressionFailure? _err(String src, ExpressionEnv env) {
  final (Object result, ExpressionFailure? err) = evaluate(src, env);
  if (err != null) {
    return err;
  }
  if (result is EvalFailure) {
    return ExpressionFailure(src, 'eval', 0, result.message);
  }
  return null;
}

void main() {
  group('expression: 运算与优先级', () {
    test('四则优先级', () {
      expect(_num('1+2*3', <String, double>{}), 7);
      expect(_num('(1+2)*3', <String, double>{}), 9);
      expect(_num('10-2-3', <String, double>{}), 5);
      expect(_num('7/2', <String, double>{}), 3.5);
      expect(_num('7%3', <String, double>{}), 1);
    });

    test('小数与科学计数', () {
      expect(_num('1.00+2.50', <String, double>{}), 3.5);
      expect(_num('.5*4', <String, double>{}), 2);
      expect(_num('1e3', <String, double>{}), 1000);
    });

    test('一元负号/正号/非', () {
      expect(_num('-3+1', <String, double>{}), -2);
      expect(_num('-(1+2)', <String, double>{}), -3);
      expect(_num('!0', <String, double>{}), 1);
      expect(_num('!5', <String, double>{}), 0);
    });

    test('比较与逻辑', () {
      expect(_num('2>1', <String, double>{}), 1);
      expect(_num('2>=3', <String, double>{}), 0);
      expect(_num('1<2', <String, double>{}), 1);
      expect(_num('2<=2', <String, double>{}), 1);
      expect(_num('1==1', <String, double>{}), 1);
      expect(_num('1!=1', <String, double>{}), 0);
      expect(_num('1&&1', <String, double>{}), 1);
      expect(_num('1&&0', <String, double>{}), 0);
      expect(_num('0||1', <String, double>{}), 1);
      // 比较优先级高于逻辑
      expect(_num('1>0 && 2>1', <String, double>{}), 1);
    });

    test('短路求值：右侧不求值（未知变量也不报错）', () {
      expect(_num(r'0 && $unknown', <String, double>{r'$unknown': 1}), 0);
      final ExpressionEnv env = <String, double>{};
      expect(_num(r'0 && $nope', env), 0);
      expect(_num(r'1 || $nope', env), 1);
      // 不短路时会失败
      expect(_err(r'1 && $nope', env), isNotNull);
    });
  });

  group('expression: 变量与赋值', () {
    test('变量引用', () {
      final ExpressionEnv env = <String, double>{r'$HP': 10};
      expect(_num(r'$HP*2', env), 20);
    });

    test('赋值与多语句', () {
      final ExpressionEnv env = <String, double>{r'$a': 1, r'$b': 2};
      // 真实样本形态：$a=$a+1.00;$b=$b-2.00
      final (Object result, ExpressionFailure? err) = evalAction(
        r'$a=$a+1.00;$b=$b-2.00',
        env,
      );
      expect(err, isNull);
      expect((result as EvalValue).value, 0);
      expect(env[r'$a'], 2);
      expect(env[r'$b'], 0);
    });

    test('末尾分号/空语句', () {
      final ExpressionEnv env = <String, double>{r'$a': 1};
      expect(_num(r'$a=$a+1;', env), 2);
      expect(_num('', env), 0);
      expect(_num('   ', env), 0);
    });

    test('未知变量 → 失败', () {
      final ExpressionFailure? err = _err(r'$missing+1', <String, double>{});
      expect(err, isNotNull);
      expect(err!.message, contains('未知变量'));
    });

    test('除零 → 失败', () {
      expect(_err('1/0', <String, double>{})!.message, contains('除数为 0'));
      expect(_err('1%0', <String, double>{})!.message, contains('取模'));
    });

    test('非法语法/非法字符 → 失败且不抛异常', () {
      expect(_err('1+', <String, double>{}), isNotNull);
      expect(_err('(1+2', <String, double>{}), isNotNull);
      expect(_err('1 @ 2', <String, double>{}), isNotNull);
      expect(_err('== 1', <String, double>{}), isNotNull);
    });
  });

  group('expression: evalCondition / evalAction 语义', () {
    test('evalCondition：真/假/失败', () {
      final ExpressionEnv env = <String, double>{r'$v': 3};
      final List<ExpressionFailure> log = <ExpressionFailure>[];
      expect(evalCondition(r'$v>=1.00 && $v<=80.00', env, log: log).$1, isTrue);
      expect(evalCondition(r'$v>5', env).$1, isFalse);
      final (bool ok, ExpressionFailure? err) = evalCondition(
        r'$nope>1',
        env,
        log: log,
      );
      expect(ok, isFalse);
      expect(err, isNotNull);
      expect(log, isNotEmpty);
    });

    test('evalAction 在 env 原地修改', () {
      final ExpressionEnv env = <String, double>{r'$loop': 1};
      final (Object result, ExpressionFailure? err) = evalAction(
        r'$loop=$loop+1.00',
        env,
      );
      expect(err, isNull);
      expect((result as EvalValue).value, 2);
      expect(env[r'$loop'], 2);
    });

    test('evalAction 中途失败：不抛异常，返回失败', () {
      final ExpressionEnv env = <String, double>{r'$a': 1};
      final (Object result, ExpressionFailure? err) = evalAction(
        r'$a=$a+1.00;$b=$missing+1',
        env,
      );
      expect(err, isNotNull);
      expect(result, isA<EvalFailure>());
    });
  });

  group('expression: 真实样本语法', () {
    test('文档样本条件', () {
      final ExpressionEnv env = <String, double>{
        r'$H7g_64_PG2EVS': 36,
        r'$lMQqQ994Sk': 1,
      };
      expect(
        evalCondition(
          r'$H7g_64_PG2EVS>=1.00 && $H7g_64_PG2EVS<=80.00',
          env,
        ).$1,
        isTrue,
      );
      expect(evalCondition(r'$lMQqQ994Sk==1.00', env).$1, isTrue);
    });

    test('含特殊字符的变量名（_64_ / _35_）', () {
      final ExpressionEnv env = <String, double>{
        r'$C7s0d_64_4X_64_5O': 2,
        r'$BXY7erTt_35_Bn': 5,
      };
      expect(
        _num(r'$C7s0d_64_4X_64_5O+$BXY7erTt_35_Bn', env),
        7,
      );
    });

    test('全角空格/不间断空格不影响解析', () {
      expect(_num('1　+　2', <String, double>{}), 3);
    });
  });
}

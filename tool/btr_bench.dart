// Usage: dart run tool/btr_bench.dart <media-url> [threads]
// Starts BtrProxy, prints the loopback URL, keeps running until killed.
import 'dart:io';
import '../lib/services/btr_proxy/btr_proxy.dart';

Future<void> main(List<String> args) async {
  if (args.length > 1) BtrProxy.threads = int.parse(args[1]);
  final u = await BtrProxy.instance.wrap(args[0]);
  stdout.writeln(u);
  await Future<void>.delayed(const Duration(minutes: 10));
  exit(0);
}

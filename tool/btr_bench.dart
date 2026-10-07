// Usage: dart run tool/btr_bench.dart <media-url> [threads|auto] [mainland|overseas]
// Starts BtrProxy, prints the loopback URL, keeps running until killed.
import 'dart:io';
import '../lib/services/btr_proxy/btr_proxy.dart';

Future<void> main(List<String> args) async {
  if (args.length > 1 && args[1] != 'auto') {
    BtrConfig.autoThreads = false;
    BtrConfig.threads = int.parse(args[1]);
  }
  if (args.length > 2) BtrConfig.mode = BtrCdnMode.values.byName(args[2]);
  final u = await BtrProxy.instance.wrap(args[0]);
  stdout.writeln(u);
  await Future<void>.delayed(const Duration(minutes: 10));
  exit(0);
}

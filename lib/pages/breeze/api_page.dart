import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/services/breeze/breeze_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:material_ui/material_ui.dart';

class BreezeApiPage extends StatefulWidget {
  const BreezeApiPage({super.key});

  @override
  State<BreezeApiPage> createState() => _BreezeApiPageState();
}

class _BreezeApiPageState extends State<BreezeApiPage> {
  late final _config = BreezeService.config;
  late BreezeProvider _provider = _config.provider;
  late BreezeProtocol _protocol = _config.apiProtocol;
  late final _url = TextEditingController(text: _config.apiUrl);
  late final _model = TextEditingController(text: _config.apiModel);
  late final _key = TextEditingController(text: _config.apiKey);
  bool _obscure = true;
  bool _busy = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _status = _config.configured ? '已配置 API' : '请先设置 API';
  }

  @override
  void dispose() {
    _url.dispose();
    _model.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _save() => BreezeService.saveApi(
    apiKey: _key.text,
    provider: _provider,
    apiUrl: _url.text,
    apiModel: _model.text,
    apiProtocol: _protocol,
  );

  Future<void> _run(String working, Future<String> Function() task) async {
    setState(() {
      _busy = true;
      _status = working;
    });
    try {
      _status = await task();
    } catch (e) {
      _status = e.toString();
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = _provider == BreezeProvider.custom;
    final note = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.outline,
    );
    return SimpleScaffold(
      appBar: AppBar(title: const Text('API 设置')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          MediaQuery.viewPaddingOf(context).bottom + 100,
        ),
        children: [
          SegmentedButton<BreezeProvider>(
            segments: const [
              ButtonSegment(value: BreezeProvider.jev, label: Text('Jev 官方')),
              ButtonSegment(
                value: BreezeProvider.custom,
                label: Text('第三方 / 自定义'),
              ),
            ],
            selected: {_provider},
            onSelectionChanged: (v) => setState(() => _provider = v.first),
          ),
          const SizedBox(height: 8),
          Text(
            custom ? '使用自定义 API' : '直连 api.typesafe.ai · jev-latest',
            style: note,
          ),
          if (custom) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<BreezeProtocol>(
              initialValue: _protocol,
              decoration: const InputDecoration(labelText: '接口协议'),
              items: const [
                DropdownMenuItem(
                  value: BreezeProtocol.openai,
                  child: Text('OpenAI 兼容（Chat Completions）'),
                ),
                DropdownMenuItem(
                  value: BreezeProtocol.jev,
                  child: Text('Jev 兼容'),
                ),
              ],
              onChanged: (v) => setState(() => _protocol = v ?? _protocol),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _url,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'API 地址',
                hintText: 'https://example.com/v1/chat/completions',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _model,
              autocorrect: false,
              decoration: const InputDecoration(labelText: '模型名称'),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _key,
            obscureText: _obscure,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: 'API Key',
              suffixIcon: IconButton(
                tooltip: _obscure ? '显示' : '隐藏',
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '密钥仅存本机，不随设置导出。识别会将文字、作者名称、标题和链接发送给 API 服务商并使用你的额度；不读取图片或视频。',
            style: note,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: _busy
                    ? null
                    : () => _run('正在保存…', () async {
                        await _save();
                        SmartDialog.showToast('已保存');
                        return '已保存';
                      }),
                child: const Text('保存 API 设置'),
              ),
              OutlinedButton(
                onPressed: _busy
                    ? null
                    : () => _run('正在测试 API…', () async {
                        await _save();
                        await BreezeService.test();
                        return '连接正常，已返回有效识别结果';
                      }),
                child: const Text('测试连接'),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => _run('正在删除…', () async {
                        await BreezeService.clearApiKey();
                        _key.clear();
                        return '密钥已删除';
                      }),
                child: const Text('删除密钥'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(_status, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

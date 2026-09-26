// Syncs BiliBreeze prompts into PiliPlus.
// Usage: node sync-breeze-prompts.cjs <bili-breeze dir> <PiliPlus dir>
//
// Prompt text, rules version, length limit and the default fold thresholds
// (tuned together with the prompt) are copied into
// lib/services/breeze/breeze_prompts.dart. Request assembly is Dart code and
// is not translated: test/services/breeze_prompt_fixtures.json holds the
// extension's own sanitize/cacheKey/request results for fixed cases, and
// breeze_rules_test.dart fails when the Dart port no longer matches them.
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const crypto = require('node:crypto');
const {execFileSync} = require('node:child_process');

const [ext, pili] = process.argv.slice(2).map(p => path.resolve(p));
if (!ext || !pili) throw new Error('usage: sync-breeze-prompts.cjs <bili-breeze> <PiliPlus>');

const read = file => fs.readFileSync(path.join(ext, file), 'utf8').replace(/\r\n/g, '\n');
const prompts = vm.createContext({});
for (const file of ['prompts/classification.js', 'prompts/giveaway.js']) vm.runInContext(read(file), prompts);
const get = name => vm.runInContext(name, prompts);
const version = get('CLASSIFICATION_VERSION');
const limit = get('PROMPT_LIMIT');
const adThreshold = get('DEFAULT_AD_THRESHOLD');
const cautiousThreshold = get('DEFAULT_CAUTIOUS_THRESHOLD');
const defaultPrompt = get('DEFAULT_PROMPT');
const giveawayPrompt = get('GIVEAWAY_PROMPT');
for (const [name, value] of Object.entries({version, defaultPrompt, giveawayPrompt})) {
  if (typeof value !== 'string' || !value) throw new Error(`${name} missing`);
}
for (const [name, value] of Object.entries({PROMPT_LIMIT: limit, DEFAULT_AD_THRESHOLD: adThreshold, DEFAULT_CAUTIOUS_THRESHOLD: cautiousThreshold})) {
  if (!Number.isInteger(value)) throw new Error(`${name} missing`);
}
const source = execFileSync('git', ['-C', ext, 'log', '-1', '--format=%h', '--', 'prompts'], {encoding: 'utf8'}).trim();

// Explicit \n escapes keep the text exact on CRLF checkouts.
const lit = s => "'" + s.replace(/\\/g, '\\\\').replace(/\$/g, '\\$').replace(/'/g, "\\'").replace(/\n/g, '\\n') + "'";
const multi = s => s.split('\n').map((line, i, all) => '    ' + lit(line + (i < all.length - 1 ? '\n' : ''))).join('\n');

const dart = `import 'dart:convert';

// Generated from PosvdM/bili-breeze prompts/ at ${source} by
// .github/scripts/sync-breeze-prompts.cjs. Edit the extension, not the text
// here; the request assembly below is checked against the extension by
// test/services/breeze_prompt_fixtures.json.

/// Bump when classification rules change, so cached decisions are not reused.
const breezeClassificationVersion = ${lit(version)};
const breezePromptLimit = ${limit};

/// Default fold thresholds (%), tuned for [breezeDefaultPrompt].
const breezeDefaultAdThreshold = ${adThreshold};
const breezeDefaultCautiousThreshold = ${cautiousThreshold};

/// Editable classification rules; the output format is always appended.
const breezeDefaultPrompt =
${multi(defaultPrompt)};

const breezeGiveawayPrompt =
${multi(giveawayPrompt)};

/// Shared prompt assembly for Jev and OpenAI-compatible services.
Map<String, dynamic> buildClassificationPayload(
  Map<String, dynamic> state, {
  required String rulesPrompt,
  required bool openai,
  required String model,
  required bool lottery,
}) {
  final rules = rulesPrompt.isEmpty ? breezeDefaultPrompt : rulesPrompt;
  final fields = ['ad_prob', 'recruitment_prob', 'event_prob'];
  final questions = <String, dynamic>{
    'is_ad': {'type': 'noul', 'instructions': '$rules\\n返回广告概率。'},
    'is_recruitment': {
      'type': 'noul',
      'instructions': '$rules\\n返回真实岗位招聘概率。',
    },
    'is_event': {'type': 'noul', 'instructions': '$rules\\n返回活动宣传概率。'},
  };
  if (lottery) {
    questions['giveaway_primary'] = {
      'type': 'noul',
      'instructions': '$breezeGiveawayPrompt\\n返回主要抽奖的置信度。',
    };
    questions['giveaway_incidental'] = {
      'type': 'noul',
      'instructions': '$breezeGiveawayPrompt\\n返回附带抽奖的置信度。',
    };
    fields.addAll(['giveaway_primary_prob', 'giveaway_incidental_prob']);
  }
  final output = '只输出 JSON，包含 \${fields.join(', ')}，各值均为 0 到 1 的数字。';
  if (openai) {
    return {
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content': [
            rules,
            if (lottery) breezeGiveawayPrompt,
            output,
          ].join('\\n\\n'),
        },
        {'role': 'user', 'content': jsonEncode(state)},
      ],
    };
  }
  return {'model': model, 'state': state, 'questions': questions};
}

/// Trims and caps an edited prompt; the built-in text is stored as empty.
String normalizeBreezePrompt(Object? value) {
  var text = value is String ? value.trim() : '';
  if (text.length > breezePromptLimit) {
    text = text.substring(0, breezePromptLimit);
  }
  return text == breezeDefaultPrompt ? '' : text;
}
`;

// Expected results from the extension's own functions.
const digest = value => crypto.createHash('sha256').update(JSON.stringify(value)).digest('hex');
const background = require(path.join(ext, 'tests/helpers/background.cjs'))({
  crypto: crypto.webcrypto, TextEncoder, URL, AbortController, setTimeout, clearTimeout, fetch: async () => {},
  chrome: {
    storage: {local: {setAccessLevel: async () => {}, get: async d => d, set: async () => {}, remove: async () => {}}, onChanged: {addListener() {}}},
    runtime: {id: 'sync', getURL: p => p, onMessage: {addListener() {}}},
    tabs: {query: async () => []}, permissions: {contains: async () => true}
  }
});
const lottery = {kind: 'dynamic', text: '互动抽奖 转发关注抽1人送耳机', originalText: '感谢支持', forwardedText: '互动抽奖', links: ['https://t.bilibili.com/1']};
const official = {kind: 'dynamic', author: '  游戏科学  ', text: '《黑神话：钟馗》首支预告', links: []};
const pinned = {kind: 'pinned', author: '测试UP', text: '补充说明：视频第三分钟口误，正确年份是2024年。', title: '视频标题', links: ['https://www.bilibili.com/video/BV1xx411c7mD']};
const url = 'https://example.test/v1/chat/completions';
const cases = [
  {name: 'jev giveaway', raw: lottery, config: {provider: 'jev', rulesPrompt: ''}},
  {name: 'jev author context', raw: official, config: {provider: 'jev', rulesPrompt: ''}},
  {name: 'jev pinned comment', raw: pinned, config: {provider: 'jev', rulesPrompt: ''}},
  {name: 'jev edited prompt', raw: official, config: {provider: 'jev', rulesPrompt: '游戏官方号宣传新活动也算广告'}},
  {name: 'openai giveaway edited prompt', raw: lottery, config: {provider: 'custom', apiProtocol: 'openai', apiUrl: url, apiModel: ' m ', rulesPrompt: '只判断品牌商单。'}},
  {name: 'openai author context', raw: official, config: {provider: 'custom', apiProtocol: 'openai', apiUrl: url, apiModel: 'm', rulesPrompt: ''}},
  {name: 'jev-compatible custom', raw: lottery, config: {provider: 'custom', apiProtocol: 'jev', apiUrl: url, apiModel: 'model-x', rulesPrompt: ''}}
];

(async () => {
  background.cases = cases;
  const results = [];
  for (let i = 0; i < cases.length; i++) {
    const [state, isLottery, cacheKey, payload] = await vm.runInContext(`(async () => {
      const c = cases[${i}], config = {...c.config, rulesPrompt: normalizePrompt(c.config.rulesPrompt)};
      const state = sanitize(c.raw), lottery = isGiveaway(state.text);
      return [state, lottery, await cacheKey(state, config), buildClassificationRequest(state, config, lottery)];
    })()`, background);
    results.push({...cases[i], expected: {lottery: isLottery, state: digest(state), cacheKey, payload: digest(payload)}});
  }
  const fixtures = {
    source: `PosvdM/bili-breeze prompts/ at ${source}`,
    classificationVersion: version,
    promptLimit: limit,
    defaultAdThreshold: adThreshold,
    defaultCautiousThreshold: cautiousThreshold,
    defaultPrompt: digest(defaultPrompt),
    giveawayPrompt: digest(giveawayPrompt),
    cases: results
  };
  fs.writeFileSync(path.join(pili, 'lib/services/breeze/breeze_prompts.dart'), dart);
  fs.writeFileSync(path.join(pili, 'test/services/breeze_prompt_fixtures.json'), JSON.stringify(fixtures, null, 2) + '\n');
  console.log(`synced ${version} from ${source}`);
})().catch(e => { console.error(e); process.exit(1); });

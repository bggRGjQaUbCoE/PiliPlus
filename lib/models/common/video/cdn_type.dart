// ignore_for_file: constant_identifier_names

//https://github.com/yujincheng08/BiliRoaming/blob/master/app/src/main/res/values/strings_raw.xml
//https://github.com/yujincheng08/BiliRoaming/blob/master/app/src/main/res/values/arrays.xml

enum CDNService {
  baseUrl('基础URL（不推荐）'),
  backupUrl('备用URL'),
  ali('ali（阿里云）', 'upos-sz-mirrorali.bilivideo.com'),
  alib('alib（阿里云）', 'upos-sz-mirroralib.bilivideo.com'),
  alio1('alio1（阿里云）', 'upos-sz-mirroralio1.bilivideo.com'),
  cos('cos（腾讯云）', 'upos-sz-mirrorcos.bilivideo.com'),
  cosb('cosb（腾讯云，VOD加速类型）', 'upos-sz-mirrorcosb.bilivideo.com'),
  coso1('coso1（腾讯云）', 'upos-sz-mirrorcoso1.bilivideo.com'),
  hw('hw（华为云，融合CDN）', 'upos-sz-mirrorhw.bilivideo.com'),
  hwb('hwb（华为云，融合CDN）', 'upos-sz-mirrorhwb.bilivideo.com'),
  hwo1('hwo1（华为云，融合CDN）', 'upos-sz-mirrorhwo1.bilivideo.com'),
  hw_08c('08c（华为云，融合CDN）', 'upos-sz-mirror08c.bilivideo.com'),
  hw_08h('08h（华为云，融合CDN）', 'upos-sz-mirror08h.bilivideo.com'),
  hw_08ct('08ct（华为云，融合CDN）', 'upos-sz-mirror08ct.bilivideo.com'),
  tf_hw('tf_hw（华为云）', 'upos-tf-all-hw.bilivideo.com'),
  tf_tx('tf_tx（腾讯云）', 'upos-tf-all-tx.bilivideo.com'),
  akamai('akamai（Akamai海外）', 'upos-hz-mirrorakam.akamaized.net'),
  aliov('aliov（阿里云海外）', 'upos-sz-mirroraliov.bilivideo.com'),
  cosov('cosov（腾讯云海外）', 'upos-sz-mirrorcosov.bilivideo.com'),
  hwov('hwov（华为云海外）', 'upos-sz-mirrorhwov.bilivideo.com'),
  hk_bcache('hk_bcache（Bilibili海外）', 'cn-hk-eq-bcache-01.bilivideo.com');

  String get code => name;
  static final fromCode = values.byName;

  final String description;
  final String host;

  const CDNService(this.description, [this.host = '']);
}

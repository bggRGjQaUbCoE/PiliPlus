enum AppFontFamily {
  system(label: '系统默认'),
  lxgwWenKaiGbScreen(
    label: '霞鹜文楷',
    fontFamily: 'LXGW WenKai GB Screen',
    fileName: 'LXGWWenKaiGBScreen-1.522.ttf',
    downloadUrls: [
      'https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v1.522/LXGWWenKaiGBScreen.ttf',
    ],
    downloadSize: 26037854,
    sha256: '23ec023913e1851925eb94462c4b0ccd1d78bb89533745aaa8cc682ccd339dc0',
  ),
  lxgwZhenKaiGb(
    label: '霞鹜臻楷',
    fontFamily: 'LXGW ZhenKai GB',
    fileName: 'LXGWZhenKaiGB-Regular.ttf',
    downloadUrls: [
      'https://mirrors.aliyun.com/CTAN/fonts/lxgw-fonts/LXGWZhenKaiGB-Regular.ttf',
      'https://mirrors.ctan.org/fonts/lxgw-fonts/LXGWZhenKaiGB-Regular.ttf',
    ],
    downloadSize: 17545474,
    sha256: '40876902a7ce25268ab710ad8fe6e2b63bc002aa4b68d22fd45fc1243726ced5',
  ),
  lxgwNeoXiHeiScreen(
    label: '霞鹜新晰黑',
    fontFamily: 'LXGW Neo XiHei Screen',
    fileName: 'LXGWNeoXiHeiScreen.ttf',
    downloadUrls: [
      'https://mirrors.aliyun.com/CTAN/fonts/lxgw-fonts/LXGWNeoXiHeiScreen.ttf',
      'https://mirrors.ctan.org/fonts/lxgw-fonts/LXGWNeoXiHeiScreen.ttf',
    ],
    downloadSize: 7608410,
    sha256: 'fc6bbcc2695488073dfe8ad89bde89563cc963fbe04fb7a48c141988f9ba9620',
  ),
  lxgwZhuqueFangsong(
    label: '霞鹜朱雀仿宋',
    fontFamily: 'LXGW Zhuque Fangsong',
    fileName: 'LXGWZhuqueFangsong-Regular.ttf',
    downloadUrls: [
      'https://mirrors.aliyun.com/CTAN/fonts/lxgw-fonts/LXGWZhuqueFangsong-Regular.ttf',
      'https://mirrors.ctan.org/fonts/lxgw-fonts/LXGWZhuqueFangsong-Regular.ttf',
    ],
    downloadSize: 8824084,
    sha256: '558c62730844fe54ba220146ed62f859d4e2880188d92d985f8921c6e3743bc4',
  ),
  sourceHanSansCn(
    label: '思源黑体',
    fontFamily: 'Source Han Sans CN',
    fileName: 'SourceHanSansCN-Regular-2.005.otf',
    downloadUrls: [
      'https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-Regular.otf',
      'https://raw.githubusercontent.com/adobe-fonts/source-han-sans/2.005R/SubsetOTF/CN/SourceHanSansCN-Regular.otf',
    ],
    downloadSize: 8429224,
    sha256: 'e2bc8a2e7f37474b774fff8db758681ece40bb6947a90d571bce9dd60671a8e4',
  ),
  sourceHanSerifCn(
    label: '思源宋体',
    fontFamily: 'Source Han Serif CN',
    fileName: 'SourceHanSerifCN-Regular-2.003.otf',
    downloadUrls: [
      'https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-serif/SubsetOTF/CN/SourceHanSerifCN-Regular.otf',
      'https://raw.githubusercontent.com/adobe-fonts/source-han-serif/2.003R/SubsetOTF/CN/SourceHanSerifCN-Regular.otf',
    ],
    downloadSize: 11626108,
    sha256: '3754ea669c530e2473354f8f6d9f79680a44d7e26ec7d00eeabee4a7e0753c5d',
  ),
  miSans(
    label: 'MiSans',
    fontFamily: 'MiSans',
    fileName: 'MiSans-Regular.ttf',
    downloadUrls: [
      'https://hyperos.mi.com/font-download/MiSans.zip',
    ],
    downloadSize: 8122324,
    sha256: '9c120f0a849bc0aa5048daae2a3c0f6eecd828b5b33fce682a9622833f5feea6',
    downloadArchive: AppFontDownloadArchive(
      entryName: 'MiSans/ttf/MiSans-Regular.ttf',
      downloadSize: 227880072,
      sha256:
          'b6aa1fc827035922612df8edf36e5609bca1c5441e25cd57572204569b7b81d9',
    ),
    licenseUrl: 'https://hyperos.mi.com/font/zh/download/',
    licenseNotice: '本软件将使用 MiSans。下载和使用即表示你同意小米官方许可协议。',
  ),
  harmonyOsSansSc(
    label: 'HarmonyOS Sans',
    fontFamily: 'HarmonyOS Sans SC',
    fileName: 'HarmonyOS_Sans_SC_Regular.ttf',
    downloadUrls: [
      'https://developer.huawei.com/images/download/general/HarmonyOS-Sans.zip',
    ],
    downloadSize: 8261128,
    sha256: '297b088424be212207df2ce8b98e335468b782aa6b96832af0b8b773d711e2b1',
    downloadArchive: AppFontDownloadArchive(
      entryName:
          'HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Regular.ttf',
      downloadSize: 52165952,
      sha256:
          'fb02c86e358cd9aad8d4dfa957ee502381e7ee2e94499a9133add4324b6ce69a',
      licenseEntryName: 'HarmonyOS Sans/HarmonyOS_Sans_SC/LICENSE.txt',
      licenseFileName: 'HarmonyOS-Sans-LICENSE.txt',
    ),
    licenseUrl:
        'https://developer.huawei.com/consumer/cn/doc/design-guides/font-0000001828772001',
    licenseNotice: '本软件将使用 HarmonyOS Sans。下载和使用即表示你同意华为官方许可协议。',
  ),
  fusionPixel(
    label: '缝合像素字体',
    fontFamily: 'Fusion Pixel 12px Proportional zh_hans',
    fileName: 'fusion-pixel-12px-proportional-zh_hans.otf',
    downloadUrls: [
      'https://github.com/TakWolf/fusion-pixel-font/releases/download/2026.07.01/fusion-pixel-font-12px-proportional-otf-v2026.07.01.zip',
    ],
    downloadSize: 4923444,
    sha256: '3928b779becceb88a23c415d2c27c8fdaddf43698a34f95ba95f5b0ce8423c9a',
    downloadArchive: AppFontDownloadArchive(
      entryName: 'fusion-pixel-12px-proportional-zh_hans.otf',
      downloadSize: 24685008,
      sha256:
          '29eb03b52e5ed1299e963406455904eb721c77553783b9bd2807e0901a2df294',
    ),
  ),
  ;

  const AppFontFamily({
    required this.label,
    this.fontFamily,
    this.fileName,
    this.downloadUrls,
    this.downloadSize,
    this.sha256,
    this.downloadArchive,
    this.licenseUrl,
    this.licenseNotice,
  }) : assert(
         (fontFamily == null &&
                 fileName == null &&
                 downloadUrls == null &&
                 downloadSize == null &&
                 sha256 == null &&
                 downloadArchive == null &&
                 licenseUrl == null &&
                 licenseNotice == null) ||
             (fontFamily != null &&
                 fileName != null &&
                 downloadUrls != null &&
                 downloadSize != null &&
                 sha256 != null &&
                 ((licenseUrl == null && licenseNotice == null) ||
                     (licenseUrl != null && licenseNotice != null))),
       );

  final String label;
  final String? fontFamily;
  final String? fileName;
  final List<String>? downloadUrls;
  final int? downloadSize;
  final String? sha256;
  final AppFontDownloadArchive? downloadArchive;
  final String? licenseUrl;
  final String? licenseNotice;

  bool get isSystem => this == system;

  int? get transferSize => downloadArchive?.downloadSize ?? downloadSize;

  static AppFontFamily fromName(Object? value) => values.firstWhere(
    (item) => item.name == value,
    orElse: () => system,
  );
}

final class AppFontDownloadArchive {
  const AppFontDownloadArchive({
    required this.entryName,
    required this.downloadSize,
    required this.sha256,
    this.licenseEntryName,
    this.licenseFileName,
  }) : assert(
         (licenseEntryName == null && licenseFileName == null) ||
             (licenseEntryName != null && licenseFileName != null),
       );

  final String entryName;
  final int downloadSize;
  final String sha256;
  final String? licenseEntryName;
  final String? licenseFileName;
}

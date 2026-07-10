enum AppFontFamily {
  system(label: '系统默认'),
  lxgwWenKaiGbScreen(
    label: '霞鹜文楷',
    fontFamily: 'LXGW WenKai GB Screen',
    fileName: 'LXGWWenKaiGBScreen-1.522.ttf',
    downloadUrl:
        'https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v1.522/LXGWWenKaiGBScreen.ttf',
    downloadSize: 26037854,
    sha256: '23ec023913e1851925eb94462c4b0ccd1d78bb89533745aaa8cc682ccd339dc0',
  ),
  sourceHanSerifCn(
    label: '思源宋体',
    fontFamily: 'Source Han Serif CN',
    fileName: 'SourceHanSerifCN-Regular-2.003.otf',
    downloadUrl:
        'https://raw.githubusercontent.com/adobe-fonts/source-han-serif/2.003R/SubsetOTF/CN/SourceHanSerifCN-Regular.otf',
    downloadSize: 11626108,
    sha256: '3754ea669c530e2473354f8f6d9f79680a44d7e26ec7d00eeabee4a7e0753c5d',
  ),
  ;

  const AppFontFamily({
    required this.label,
    this.fontFamily,
    this.fileName,
    this.downloadUrl,
    this.downloadSize,
    this.sha256,
  }) : assert(
         (fontFamily == null &&
                 fileName == null &&
                 downloadUrl == null &&
                 downloadSize == null &&
                 sha256 == null) ||
             (fontFamily != null &&
                 fileName != null &&
                 downloadUrl != null &&
                 downloadSize != null &&
                 sha256 != null),
       );

  final String label;
  final String? fontFamily;
  final String? fileName;
  final String? downloadUrl;
  final int? downloadSize;
  final String? sha256;

  bool get isSystem => this == system;

  static AppFontFamily fromName(Object? value) => values.firstWhere(
    (item) => item.name == value,
    orElse: () => system,
  );
}

// mpv --hwdec=help
import 'dart:io' show Platform;

import 'package:PiliPlus/l10n/l10n.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

enum HwDecType {
  no('no'),
  auto('auto'),
  autoSafe('auto-safe'),
  autoCopy('auto-copy'),
  d3d12va('d3d12va'),
  d3d12vaCopy('d3d12va-copy'),
  d3d11va('d3d11va'),
  d3d11vaCopy('d3d11va-copy'),
  dxva2('dxva2'),
  dxva2Copy('dxva2-copy'),
  videotoolbox('videotoolbox'),
  videotoolboxCopy('videotoolbox-copy'),
  vaapi('vaapi'),
  vaapiCopy('vaapi-copy'),
  nvdec('nvdec'),
  nvdecCopy('nvdec-copy'),
  drm('drm'),
  drmCopy('drm-copy'),
  vulkan('vulkan'),
  vulkanCopy('vulkan-copy'),
  vdpau('vdpau'),
  vdpauCopy('vdpau-copy'),
  mediacodec('mediacodec'),
  mediacodecCopy('mediacodec-copy'),
  cuda('cuda'),
  cudaCopy('cuda-copy'),
  crystalhd('crystalhd'),
  rkmpp('rkmpp'),
  amf('amf'),
  amfCopy('amf-copy'),
  qsv('qsv'),
  qsvCopy('qsv-copy'),
  ;

  final String hwdec;
  String get desc => switch (this) {
    no => L10n.current.hwDecTypeNoDesc,
    auto => L10n.current.hwDecTypeAutoDesc,
    autoSafe => L10n.current.hwDecTypeAutoSafeDesc,
    autoCopy => L10n.current.hwDecTypeAutoCopyDesc,
    d3d12va => L10n.current.hwDecTypeD3d12vaDesc,
    d3d12vaCopy => L10n.current.hwDecTypeD3d12vaCopyDesc,
    d3d11va => L10n.current.hwDecTypeD3d11vaDesc,
    d3d11vaCopy => L10n.current.hwDecTypeD3d11vaCopyDesc,
    dxva2 => L10n.current.hwDecTypeDxva2Desc,
    dxva2Copy => L10n.current.hwDecTypeDxva2CopyDesc,
    videotoolbox => 'VideoToolbox (macOS / iOS)',
    videotoolboxCopy => L10n.current.hwDecTypeVideotoolboxCopyDesc,
    vaapi => 'VAAPI (Linux)',
    vaapiCopy => L10n.current.hwDecTypeVaapiCopyDesc,
    nvdec => L10n.current.hwDecTypeNvdecDesc,
    nvdecCopy => L10n.current.hwDecTypeNvdecCopyDesc,
    drm => 'DRM (Linux)',
    drmCopy => L10n.current.hwDecTypeDrmCopyDesc,
    vulkan => L10n.current.hwDecTypeVulkanDesc,
    vulkanCopy => L10n.current.hwDecTypeVulkanCopyDesc,
    vdpau => 'VDPAU (Linux)',
    vdpauCopy => L10n.current.hwDecTypeVdpauCopyDesc,
    mediacodec => 'MediaCodec (Android)',
    mediacodecCopy => L10n.current.hwDecTypeMediacodecCopyDesc,
    cuda => L10n.current.hwDecTypeCudaDesc,
    cudaCopy => L10n.current.hwDecTypeCudaCopyDesc,
    crystalhd => L10n.current.hwDecTypeCrystalhdDesc,
    rkmpp => L10n.current.hwDecTypeRkmppDesc,
    amf => L10n.current.hwDecTypeAmfDesc,
    amfCopy => L10n.current.hwDecTypeAmfCopyDesc,
    qsv => L10n.current.hwDecTypeQsvDesc,
    qsvCopy => L10n.current.hwDecTypeQsvCopyDesc,
  };
  const HwDecType(this.hwdec);

  static final String kHwdec = Platform.isAndroid
      ? kDebugMode
            ? autoSafe.hwdec
            : [mediacodec.hwdec, autoSafe.hwdec].join(',')
      : auto.hwdec;
}

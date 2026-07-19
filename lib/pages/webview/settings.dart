import 'dart:io';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

InAppWebViewSettings buildAuthenticatedWebViewSettings(String userAgent) =>
    InAppWebViewSettings(
      clearCache: false,
      javaScriptEnabled: true,
      forceDark: ForceDark.AUTO,
      useHybridComposition: false,
      algorithmicDarkeningAllowed: true,
      useShouldOverrideUrlLoading: true,
      userAgent: userAgent,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    );

InAppWebViewSettings buildGeetestWebViewSettings() => InAppWebViewSettings(
  clearCache: false,
  javaScriptEnabled: true,
  forceDark: ForceDark.AUTO,
  useHybridComposition: false,
  algorithmicDarkeningAllowed: true,
  useShouldOverrideUrlLoading: true,
  userAgent: BrowserUa.mob,
  mixedContentMode: .MIXED_CONTENT_ALWAYS_ALLOW,
  incognito: true,
  allowFileAccess: false,
  allowsLinkPreview: false,
  allowContentAccess: false,
  useOnDownloadStart: false,
  geolocationEnabled: false,
  thirdPartyCookiesEnabled: false,
  enterpriseAuthenticationAppLinkPolicyEnabled: false,
  saveFormData: false,
  safeBrowsingEnabled: false,
  isFraudulentWebsiteWarningEnabled: false,
  domStorageEnabled: false,
  databaseEnabled: false,
  cacheEnabled: false,
  cacheMode: .LOAD_NO_CACHE,
  horizontalScrollBarEnabled: false,
  verticalScrollBarEnabled: false,
  overScrollMode: .NEVER,
  pageZoom: Platform.isIOS ? 3 : 1,
);

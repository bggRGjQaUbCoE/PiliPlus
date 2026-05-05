1. PiliPlus is a Flutter Android app for Bilibili. Use FVM Flutter 3.41.6 only, never system Flutter. State management is GetX (forked). Each page has view.dart and controller.dart. Shared logic goes in lib/pages/common/.

2. Key dependencies: dio (network), hive_ce (storage), media_kit (video), canvas_danmaku (danmaku). Many deps are git forks from bggRGjQaUbCoE.

3. Follow existing code patterns. Check imports before adding new dependencies. Use Get.find<T>() for DI and Obx()/GetBuilder() for reactive UI.

4. Never expose API keys or secrets. Never modify android/build.gradle.kts or android/settings.gradle.kts mirror configs.

5. Required env vars before any build or run:
```
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

6. Build commands are in .trae/AGENT_QUICKSTART.md. For release builds use --obfuscate --split-debug-info=build/debug_info.

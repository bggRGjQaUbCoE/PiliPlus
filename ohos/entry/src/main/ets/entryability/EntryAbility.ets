import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import { PiliPlusPlatformPlugin } from '../plugins/PiliPlusPlatformPlugin';

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine): void {
    super.configureFlutterEngine(flutterEngine);
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    const plugins = flutterEngine.getPlugins();
    if (plugins === null) {
      throw new Error('The Flutter engine has no plugin registry.');
    }
    plugins.add(new PiliPlusPlatformPlugin());
  }
}

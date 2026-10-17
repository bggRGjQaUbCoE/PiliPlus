import path from 'path';
import { appTasks } from '@ohos/hvigor-ohos-plugin';
import { flutterHvigorPlugin } from 'flutter-hvigor-plugin';

export default {
  system: appTasks,
  plugins: [flutterHvigorPlugin(path.dirname(__dirname))]
};

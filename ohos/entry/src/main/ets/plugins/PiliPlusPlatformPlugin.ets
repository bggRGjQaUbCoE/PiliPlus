import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

/** Platform operations used by the existing PiliPlus interface. */
export class PiliPlusPlatformPlugin implements FlutterPlugin, AbilityAware, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private abilityContext: common.UIAbilityContext | null = null;

  getUniqueClassName(): string {
    return 'PiliPlusPlatformPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'piliplus/ohos');
    this.channel.setMethodCallHandler(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channel?.setMethodCallHandler(null);
    this.channel = null;
    this.abilityContext = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.abilityContext = binding.getAbility().context;
  }

  onDetachedFromAbility(): void {
    this.abilityContext = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case 'moveToBackground': {
        const context = this.abilityContext;
        if (context === null) {
          result.error('NO_ABILITY', 'The application is not attached to a UIAbility.', null);
          return;
        }
        context.moveAbilityToBackground().then(() => {
          result.success(null);
        }).catch((error: BusinessError) => {
          result.error('MOVE_TO_BACKGROUND_FAILED', error.message, error.code);
        });
        return;
      }
      default:
        result.notImplemented();
    }
  }
}

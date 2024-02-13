import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { KVDBUtil, PreferencesUtil } from '@listen4/common';
import { DataConstants } from '../constants/EntryConstants';
import { Netease } from '@listen4/apis/src/main/ets/netease/Netease';
import { NeteaseConstants } from '@listen4/apis';


export default class EntryAbility extends UIAbility {
  listen4Preferences: PreferencesUtil;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    AppStorage.SetOrCreate<KVDBUtil>('neteaseKV', new KVDBUtil(this.context, 'netease', this.context.abilityInfo.bundleName))


    // 保存 | 读取 cookie
    this.listen4Preferences = new PreferencesUtil(this.context, this.context.abilityInfo.moduleName);
    this.listen4Preferences.has(DataConstants.PREFERENCES_COOKIE_KEY).then(async (has) => {
      if (has) {
        let json = (await this.listen4Preferences.get(DataConstants.PREFERENCES_COOKIE_KEY, "{}")) as string;
        let cookie: object = JSON.parse(json)
        AppStorage.SetOrCreate<object>(NeteaseConstants.NETEASE_COOKIE, cookie);
      } else {
        await Netease.User.anonimous();
        this.listen4Preferences.put(
          DataConstants.PREFERENCES_COOKIE_KEY,
          JSON.stringify(AppStorage.Get<object>(NeteaseConstants.NETEASE_COOKIE))
        );
        this.listen4Preferences.flush();
      }
    })

  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');


    windowStage.getMainWindow().then((windowClass: window.Window) => {
      // 全屏展示
      windowClass.setWindowLayoutFullScreen(true);
      // 隐藏状态栏
      windowClass.setWindowSystemBarEnable([])
      // 获取状态栏高度
      // let barHeight: number = px2vp(windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT).topRect.height)
      // AppStorage.SetAndProp<number>(EntryConstants.STATUS_BAR_HEIGHT_KEY,barHeight);
    })

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}




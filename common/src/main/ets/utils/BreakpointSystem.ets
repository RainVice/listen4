import { BreakpointConstants } from '../constants/BreakpointConstants'
import mediaQuery from '@ohos.mediaquery';




/**
 * 分辨率类型选项
 * @class BreakPointTypeOption
 * @template T - 元类型
 */
declare interface BreakPointTypeOption<T> {
  /**
   * 小屏幕尺寸的选项，默认值为T类型
   */
  sm?: T
  /**
   * 中等屏幕尺寸的选项，默认值为T类型
   */
  md?: T
  /**
   * 大屏幕尺寸的选项，默认值为T类型
   */
  lg?: T
  /**
   * 超大屏幕尺寸的选项，默认值为T类型
   */
  xl?: T
  /**
   * 超超大屏幕尺寸的选项，默认值为T类型
   */
  xxl?: T
}

/**
 * 自定义分辨率类型
 * @class BreakPointType
 * @template T - 元类型
 */
export class BreakPointType<T> {

  /**
   * 分辨率选项
   * @property option - BreakPointTypeOption<T>
   */
  options: BreakPointTypeOption<T>;

  /**
   * 构造函数
   * @constructor
   * @param {BreakPointTypeOption<T>} options - 分辨率选项
   */
  constructor(options: BreakPointTypeOption<T>){
    this.options = options;
  }

  /**
   * 获取当前分辨率的值
   * @method getValue
   * @returns {T} 当前分辨率的值
   */
  getValue(){
    return this.options[AppStorage.Get<string>(BreakpointConstants.CURRENT_BREAKPOINT)] as T;
  }

}

// 响应屏幕尺寸断点变化的类
export class BreakpointSystem {

  // 小屏幕监听器
  private static smListener?: mediaQuery.MediaQueryListener;
  // 中等屏幕监听器
  private static mdListener?: mediaQuery.MediaQueryListener;
  // 大屏幕监听器
  private static lgListener?: mediaQuery.MediaQueryListener;

  // 注册监听器
  public static register() {
    // 注册小屏幕媒体查询监听器
    this.smListener = mediaQuery.matchMediaSync(BreakpointConstants.RANGE_SM);
    this.smListener?.on('change',(mediaQueryResult: mediaQuery.MediaQueryResult) => {
      if (mediaQueryResult.matches) {
        // 当小屏幕时，设置当前断点为SM
        AppStorage.Set<string>(BreakpointConstants.CURRENT_BREAKPOINT, BreakpointConstants.SM);
      }
    });
    // 注册中等屏幕媒体查询监听器
    this.mdListener = mediaQuery.matchMediaSync(BreakpointConstants.RANGE_MD);
    this.mdListener?.on('change',(mediaQueryResult: mediaQuery.MediaQueryResult) => {
      if (mediaQueryResult.matches) {
        // 当中等屏幕时，设置当前断点为MD
        AppStorage.Set<string>(BreakpointConstants.CURRENT_BREAKPOINT, BreakpointConstants.MD);
      }
    });
    // 注册大屏幕媒体查询监听器
    this.lgListener = mediaQuery.matchMediaSync(BreakpointConstants.RANGE_LG);
    this.lgListener?.on('change',(mediaQueryResult: mediaQuery.MediaQueryResult) => {
      if (mediaQueryResult.matches) {
        // 当大屏幕时，设置当前断点为LG
        AppStorage.Set<string>(BreakpointConstants.CURRENT_BREAKPOINT, BreakpointConstants.LG);
      }
    })
  }

  // 注销监听器
  public static unregister() {
    // 注销小屏幕媒体查询监听器
    this.smListener.off('change');
    // 注销中等屏幕媒体查询监听器
    this.mdListener.off('change');
    // 注销大屏幕媒体查询监听器
    this.lgListener.off('change');
  }
}

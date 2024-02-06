export class BreakpointConstants{


  /**
   * 尺寸常量 SM，代表小尺寸
   */
  static readonly SM: string = 'sm';

  /**
   * 尺寸常量 MD，代表中尺寸
   */
  static readonly MD: string = 'md';

  /**
   * 尺寸常量 LG，代表大尺寸
   */
  static readonly LG: string = 'lg';

  /**
   * 要查询设备类型的当前断点。
   */
  static readonly CURRENT_BREAKPOINT: string = 'currentBreakpoint';

  /**
   * 小设备宽度范围。
   */
  static readonly RANGE_SM: string = '(320vp<=width<520vp)';

  /**
   * 中等设备宽度范围。
   */
  static readonly RANGE_MD: string = '(520vp<=width<840vp)';

  /**
   * 大设备宽度范围。
   */
  static readonly RANGE_LG: string = '(840vp<=width)';


}
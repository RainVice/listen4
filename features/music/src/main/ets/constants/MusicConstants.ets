export class ColorConstants {
  static readonly COLOR_FULL: number = 255;
  static readonly COLOR_WITHE: string = 'rgba(255, 255, 255, 1.00)';
}

/**
 * 歌单Item
 */
export class RecommendPlaylistItemConstants {
  /**
   * 宽度
   */
  static readonly WIDTH: number = 250;
  /**
   * 高度
   */
  static readonly HEIGHT: number = 250;
  /**
   * 模糊度
   */
  static readonly BLUR: number = 20;
  /**
   * 圆角半径
   */
  static readonly BORDER_RADIUS: number = 15;
  /**
   * 字体颜色
   */
  static readonly FONT_COLOR: string = ColorConstants.COLOR_WITHE;
  /**
   * 最大行数
   */
  static readonly MAX_LINES: number = 3;
  /**
   * 最大字体大小
   */
  static readonly MAX_FONT_SIZE: number = 30;
  /**
   * 最小字体大小
   */
  static readonly MIN_FONT_SIZE: number = 25;
  /**
   * 边距
   */
  static readonly MARGIN: number = 20;
}

export class MusicRecommendConstants {
  /**
   * 标题
   */
  static readonly TITLE: string = '音乐';
  /**
   * 推荐歌单
   */
  static readonly RECOMMEND_PLAYLIST: string = '推荐歌单>';
}
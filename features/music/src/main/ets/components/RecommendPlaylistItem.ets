import { LayoutConstants } from '@listen4/common/src/main/ets/constants/LayoutConstants';
import http from '@ohos.net.http';
import image from '@ohos.multimedia.image';
import effectKit from '@ohos.effectKit';
import { PersonalizedResult } from '@listen4/apis';
import { ColorConstants, RecommendPlaylistItemConstants } from '../constants/MusicConstants';

@Preview
@Component
export struct RecommendPlaylistItem {
  @Prop @Watch('getPic') personalizedResult: PersonalizedResult;
  @State private pixelMap: image.PixelMap = null;
  @State private mainColor: string = RecommendPlaylistItemConstants.FONT_COLOR;
  @State private fontColor: string = RecommendPlaylistItemConstants.FONT_COLOR;

  aboutToAppear() {
    this.getPic()
  }

  build() {
    Stack() {

      Image(this.pixelMap)
        .width(LayoutConstants.FULL_PERCENT)
        .height(LayoutConstants.FULL_PERCENT)
        .blur(RecommendPlaylistItemConstants.BLUR)
        .borderRadius(RecommendPlaylistItemConstants.BORDER_RADIUS)
        .colorBlend(this.mainColor)
      Text(this.personalizedResult.name)
        .maxLines(RecommendPlaylistItemConstants.MAX_LINES)
        .maxFontSize(RecommendPlaylistItemConstants.MAX_FONT_SIZE)
        .minFontSize(RecommendPlaylistItemConstants.MIN_FONT_SIZE)
        .fontColor(this.fontColor)
        .fontWeight(FontWeight.Bold)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .margin(RecommendPlaylistItemConstants.MARGIN)
    }
    .width(RecommendPlaylistItemConstants.WIDTH)
    .height(RecommendPlaylistItemConstants.HEIGHT)

  }

  getPic() {
    // 网络请求图片，获取主色调，设置字体颜色
    http.createHttp().request(
      this.personalizedResult.picUrl,
      { expectDataType: http.HttpDataType.ARRAY_BUFFER }
    ).then(async (res) => {
      // 将图片资源转为像素图（PixelMap）
      this.pixelMap = await image.createImageSource(res.result as ArrayBuffer)
        .createPixelMap()
      let colorPicker: effectKit.ColorPicker = await effectKit.createColorPicker(this.pixelMap)
      // 获取主色调
      let rgba = colorPicker.getMainColorSync()
      // 获取主色
      this.mainColor = `rgba(${rgba.red},${rgba.green},${rgba.blue},0.3)`
      // 取反色
      this.fontColor = `rgba(${ColorConstants.COLOR_FULL - rgba.red},${ColorConstants.COLOR_FULL - rgba.green},${ColorConstants.COLOR_FULL - rgba.blue},${rgba.alpha / ColorConstants.COLOR_FULL})`
    })
  }
}
import image from '@ohos.multimedia.image';
import { RecommendPlaylistItemConstants } from '../constants/MusicConstants';
import { NetWorkUtil } from '@listen4/common/src/main/ets/utils/NetWorkUtil';
import { LayoutConstants } from '@listen4/common/src/main/ets/constants/LayoutConstants';


@Component
export struct CoverItem {
  @Prop @Watch('getPic') url: string = '';
  @Prop text: string;
  @State private pixelMap: image.PixelMap = null;
  @State private mainColor: string = RecommendPlaylistItemConstants.FONT_COLOR;
  @State private fontColor: string = RecommendPlaylistItemConstants.FONT_COLOR;

  aboutToAppear() {
    this.getPic()
  }

  build() {
    Column() {
      Image(this.pixelMap)
        .width(RecommendPlaylistItemConstants.IMAGE_WIDTH)
        .height(RecommendPlaylistItemConstants.IMAGE_HEIGHT)// .blur(RecommendPlaylistItemConstants.BLUR)
        .borderRadius({
          topLeft: RecommendPlaylistItemConstants.BORDER_RADIUS,
          topRight: RecommendPlaylistItemConstants.BORDER_RADIUS
        })
        .colorBlend(this.mainColor)
      Text(this.text)
        .backgroundColor(this.mainColor)
        .width(LayoutConstants.FULL_PERCENT)
        .layoutWeight(1)
        .maxLines(RecommendPlaylistItemConstants.MAX_LINES)
        .maxFontSize(RecommendPlaylistItemConstants.MAX_FONT_SIZE)
        .minFontSize(RecommendPlaylistItemConstants.MIN_FONT_SIZE)
        .fontColor(this.fontColor)
        .fontWeight(FontWeight.Bold)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .padding(RecommendPlaylistItemConstants.PADDING)
        .borderRadius({
          bottomLeft: RecommendPlaylistItemConstants.BORDER_RADIUS,
          bottomRight: RecommendPlaylistItemConstants.BORDER_RADIUS
        })
      // .margin(RecommendPlaylistItemConstants.MARGIN)
    }
    .width(RecommendPlaylistItemConstants.WIDTH)
    .height(RecommendPlaylistItemConstants.HEIGHT)

  }

  async getPic() {
    let model = await NetWorkUtil.getPic(this.url);
    this.pixelMap = model.image;
    this.mainColor = model.mainColor;
    this.fontColor = model.fontColor;
  }
}
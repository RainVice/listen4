import { LayoutConstants } from '@listen4/common/src/main/ets/constants/LayoutConstants';
import image from '@ohos.multimedia.image';
import { RecommendPlaylistItemConstants } from '../constants/MusicConstants';
import { NetWorkUtil } from '@listen4/common/src/main/ets/utils/NetWorkUtil';

// @Preview
// @Component
// export struct CoverItem {
//   @Prop @Watch('getPic') personalizedResult: PersonalizedResult;
//   @State private pixelMap: image.PixelMap = null;
//   @State private mainColor: string = RecommendPlaylistItemConstants.FONT_COLOR;
//   @State private fontColor: string = RecommendPlaylistItemConstants.FONT_COLOR;
//
//   aboutToAppear() {
//     this.getPic()
//   }
//
//   build() {
//     Stack() {
//       Image(this.pixelMap)
//         .width(LayoutConstants.FULL_PERCENT)
//         .height(LayoutConstants.FULL_PERCENT)
//         .blur(RecommendPlaylistItemConstants.BLUR)
//         .borderRadius(RecommendPlaylistItemConstants.BORDER_RADIUS)
//         .colorBlend(this.mainColor)
//       Text(this.personalizedResult.name)
//         .maxLines(RecommendPlaylistItemConstants.MAX_LINES)
//         .maxFontSize(RecommendPlaylistItemConstants.MAX_FONT_SIZE)
//         .minFontSize(RecommendPlaylistItemConstants.MIN_FONT_SIZE)
//         .fontColor(this.fontColor)
//         .fontWeight(FontWeight.Bold)
//         .textOverflow({ overflow: TextOverflow.Ellipsis })
//         .textAlign(TextAlign.Center)
//         .margin(RecommendPlaylistItemConstants.MARGIN)
//     }
//     .width(RecommendPlaylistItemConstants.WIDTH)
//     .height(RecommendPlaylistItemConstants.HEIGHT)
//
//   }
//
//   async getPic() {
//     let model = await NetWorkUtil.getPic(this.personalizedResult.picUrl);
//     this.pixelMap = model.image;
//     this.mainColor = model.mainColor;
//     this.fontColor = model.fontColor;
//   }
// }
@Preview
@Component
export struct CoverItem {
  @Prop @Watch('getPic') url: string;
  @Prop text: string;
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
        .sourceSize({ width: 512, height: 512 })
      Text(this.text)
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

  async getPic() {
    let model = await NetWorkUtil.getPic(this.url);
    this.pixelMap = model.image;
    this.mainColor = model.mainColor;
    this.fontColor = model.fontColor;
  }
}
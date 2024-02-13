import { RecommendPlaylistItemConstants } from '../constants/MusicConstants';
import { NetWorkUtil, PicModel } from '@listen4/common';
import { LayoutConstants } from '@listen4/common/src/main/ets/constants/LayoutConstants';


@Component
export struct CoverItem {
  @Prop text: string;
  @State model: PicModel = {};
  @Prop url: string;
  @Prop selectUrl: string;

  async aboutToAppear() {
    if (AppStorage.Has(this.url)) {
      this.model = AppStorage.Get(this.url)
    } else {
      this.model = await NetWorkUtil.getPic(this.url)
      AppStorage.Set(this.url, this.model)
    }
  }

  build() {
    Column() {
      Image(this.model.image)
        .width(RecommendPlaylistItemConstants.IMAGE_WIDTH)
        .height(RecommendPlaylistItemConstants.IMAGE_HEIGHT)// .blur(RecommendPlaylistItemConstants.BLUR)
        .borderRadius({
          topLeft: RecommendPlaylistItemConstants.BORDER_RADIUS,
          topRight: RecommendPlaylistItemConstants.BORDER_RADIUS
        })
      // .colorBlend(this.model.mainColor)
      Column() {
        Text(this.text)
          .maxLines(RecommendPlaylistItemConstants.MAX_LINES)
          .maxFontSize(RecommendPlaylistItemConstants.MAX_FONT_SIZE)
          .minFontSize(RecommendPlaylistItemConstants.MIN_FONT_SIZE)
          .fontColor(this.model.fontColor)
          .fontWeight(FontWeight.Bold)
          .textOverflow({ overflow: TextOverflow.Ellipsis })// .textAlign(TextAlign.Center)
          .textAlign(TextAlign.Start)
          .height(LayoutConstants.FULL_PERCENT)
          .width(LayoutConstants.FULL_PERCENT)
      }
      .borderRadius({
        bottomLeft: RecommendPlaylistItemConstants.BORDER_RADIUS,
        bottomRight: RecommendPlaylistItemConstants.BORDER_RADIUS
      })
      .backgroundColor(this.model.mainColor)
      .padding(RecommendPlaylistItemConstants.PADDING)
      .layoutWeight(1)
      .width(LayoutConstants.FULL_PERCENT)
    }
    .width(RecommendPlaylistItemConstants.WIDTH)
    .height(RecommendPlaylistItemConstants.HEIGHT)

  }
}


@Component
export struct MusicListItem {
  songInfo: object;
  index: number;

  build() {

    Row({ space: 10 }) {

      Text(`${this.index + 1}`)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Gray)
        .fontSize(15)
        .width(40)
        .textAlign(TextAlign.Center)

      Image(this.songInfo['al']['picUrl'] + '?param=50y50')
        .width(50)
        .height(50)
        .borderRadius(10)
      Column({ space: 5 }) {
        Text(this.songInfo ? this.songInfo['name'] : '音乐名')// .fontSize(16)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width(LayoutConstants.FULL_PERCENT)
          .maxLines(1)
        Text(this.songInfo ? this.songInfo['ar'].map((ar) => ar['name']).join(' | ') : '歌手')
          .fontSize(12)
          .fontColor(Color.Gray)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width(LayoutConstants.FULL_PERCENT)
          .maxLines(1)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)

      Blank()

      Button() {
        Image($r('app.media.ic_public_more_list'))
          .width(20)
          .height(20)
          .backgroundColor(Color.White)
      }
    }
    .justifyContent(FlexAlign.Start)
    // .alignItems(VerticalAlign.Top)
    .padding(10)
    .width(LayoutConstants.FULL_PERCENT)
  }
}
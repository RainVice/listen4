import { BarHeader, LayoutConstants } from '@listen4/common';
import { Netease, PersonalizedResult } from '@listen4/apis';
import { RecommendPlaylistItem } from './RecommendPlaylistItem';
import { MusicRecommendConstants } from '../constants/MusicConstants';


@Preview
@Component
export struct MusicRecommend {
  @State playList: PersonalizedResult[] = [];
  scroller: Scroller = new Scroller();

  async aboutToAppear() {
    this.playList = (await Netease.PlayList.personalized())
  }

  build() {

    Column() {
      BarHeader({ title: MusicRecommendConstants.TITLE })
      Scroll() {
        Column() {
          Text(MusicRecommendConstants.RECOMMEND_PLAYLIST)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          List({ space: 10, scroller: this.scroller }) {
            ForEach(this.playList, (item: PersonalizedResult) => {
              ListItem() {
                RecommendPlaylistItem({ personalizedResult: item })
              }
            }, (item) => JSON.stringify(item))
          }
          .width(LayoutConstants.FULL_PERCENT)
          .height(250)
          .margin({ top: 20 })
          .listDirection(Axis.Horizontal)

        }
        .alignItems(HorizontalAlign.Start)
        .width(LayoutConstants.FULL_PERCENT)
      }
      .padding({ left: 20, right: 20 })

    }
    .height(LayoutConstants.FULL_PERCENT)
    .width(LayoutConstants.FULL_PERCENT)

  }
}
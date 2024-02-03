import { BarHeader, LayoutConstants } from '@listen4/common';
import { Netease, PersonalizedResult } from '@listen4/apis';


@Preview
@Component
export struct MusicRecommend {
  @State playList: PersonalizedResult[] = [];

  async aboutToAppear() {
    this.playList = (await Netease.PlayList.personalized())
  }

  build() {

    Column() {
      BarHeader({ title: '音乐' })
      Scroll() {
        Column() {

          Text('推荐歌单>')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

          List({ space: 10 }) {

            ForEach(this.playList, (item: PersonalizedResult, index: number) => {
              ListItem() {

                Text(item.name)

              }
            }, (item) => JSON.stringify(item))

          }
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
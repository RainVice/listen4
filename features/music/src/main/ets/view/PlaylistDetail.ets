import { Netease } from '@listen4/apis';
import { LayoutConstants, ListAdapter } from '@listen4/common';

@Component
export struct PlayListCover {
  /**
   * 歌单封面
   */
  picUrl: string;
  /**
   * 歌单名字
   */
  name: string;
  /**
   * 歌单描述
   */
  @Prop description: string;

  build() {

    Column({ space: 10 }) {
      Image(this.picUrl)
        .borderRadius(20)
        .width(200)
        .height(200)

      Text(this.name)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
      Text(this.description)
        .maxLines(1)
        .textAlign(TextAlign.Center)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }.padding({ left: 20, right: 20 })

  }
}

@Preview
@Component
export struct PlayListMusics {
  @Prop musicIds: number[];
  @State musicList: object = {};
  musicListAdapter: ListAdapter<object> = new ListAdapter<object>();

  async aboutToAppear() {
    this.musicList = await Netease.Music.musicDetail(this.musicIds);
    this.musicListAdapter.notifyDataReload(this.musicList['songs']);
  }

  build() {

    List() {
      LazyForEach(this.musicListAdapter, (item) => {
        ListItem() {
          Text(item['name'])
        }
      }, (item) => JSON.stringify(item))
    }
    .width(LayoutConstants.FULL_PERCENT)
    .height(LayoutConstants.FULL_PERCENT)

  }
}

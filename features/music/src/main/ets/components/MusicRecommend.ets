import { FirstLevelTitleBar, LayoutConstants, ListAdapter, PicModel } from '@listen4/common';
import { Netease } from '@listen4/apis';
import { CoverItem } from './Items';
import router from '@ohos.router';


@Preview
@Component
export struct MusicRecommend {
  @State playList: object[] = [];
  @State newMusic: object[] = [];
  @State selectUrl: string = '';
  /**
   * 歌单列表适配器
   */
  playListAdapter: ListAdapter<object> = new ListAdapter<object>(this.playList);
  newmusicAdapter: ListAdapter<object> = new ListAdapter<object>(this.newMusic);
  /**
   * 图片列表数据
   */
  imageDatas: Map<string, PicModel> = new Map<string, PicModel>();

  async aboutToAppear() {
    this.playList = (await Netease.PlayList.personalized())
    this.playListAdapter.notifyDataReload(this.playList);
    this.newMusic = (await Netease.Music.newMusic())
    this.newmusicAdapter.notifyDataReload(this.newMusic);
  }

  build() {
    Column() {
      FirstLevelTitleBar({ title: $r('app.string.music_recommend_music') })
      Scroll() {
        Column({ space: 20 }) {
          // 推荐歌单
          this.Card<object>(
            $r('app.string.music_recommend_playlist'),
            this.playListAdapter,
            (item: object) => {
              router.pushUrl({
                url: 'pages/PlaylistDetail',
                params: item
              })
            }
          )


          // 推荐音乐
          this.Card<object>(
            $r('app.string.music_new_music'),
            this.newmusicAdapter,
          )


        }
        .alignItems(HorizontalAlign.Start)
        .width(LayoutConstants.FULL_PERCENT)
      }
      .padding({ left: 20, right: 20 })
      .layoutWeight(1)
    }
    .height(LayoutConstants.FULL_PERCENT)
    .width(LayoutConstants.FULL_PERCENT)
  }

  @Builder
  Card<T>(title: Resource, adapter: IDataSource, click: (item?: T) => void = (item: T) => {
  }) {
    Text(title)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
    List({ space: 10 }) {
      LazyForEach(adapter, (item: T) => {
        ListItem() {
          CoverItem({
            selectUrl: this.selectUrl,
            url: item['picUrl'],
            text: item['name']
          })
            .onClick(() => {
              this.selectUrl = item['picUrl']
              click(item)
            })
        }
      }, (item: T) => JSON.stringify(item))
    }
    .width(LayoutConstants.FULL_PERCENT)
    // .height(250)
    .listDirection(Axis.Horizontal)

  }
}
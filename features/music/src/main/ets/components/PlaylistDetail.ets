import { Netease } from '@listen4/apis/src/main/ets/netease/Netease';
import {
  BreakpointConstants,
  BreakPointType,
  LayoutConstants,
  ListAdapter,
  NetWorkUtil,
  PicModel
} from '@listen4/common';
import { MusicListItem } from './Items';

@Component
export struct PlayListCover {
  /**
   * 歌单封面 url
   */
  url: string;
  /**
   * 歌单名字
   */
  name: string;
  /**
   * 歌单描述
   */
  @Prop description: string;
  @State model: PicModel = {};
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;

  async aboutToAppear() {
    if (AppStorage.Has(this.url)) {
      this.model = AppStorage.Get(this.url)
    } else {
      this.model = await NetWorkUtil.getPic(this.url)
      AppStorage.Set(this.url, this.model)
    }
  }

  build() {

    Scroll() {

      GridRow({
        columns: { sm: 12, md: 12, lg: 12 },
        gutter: 5
      }) {
        GridCol({
          span: { sm: 4, md: 12, lg: 12 }
        }) {
          Image(this.model.image)
            .borderRadius(20)
            .width(new BreakPointType<number>({ sm: 80, md: 200, lg: 200 }).getValue(this.currentBreakpoint))
            .height(new BreakPointType<number>({ sm: 80, md: 200, lg: 200 }).getValue(this.currentBreakpoint))
          // .colorBlend(this.model.mainColor)
        }

        GridCol({
          span: { sm: 8, md: 12, lg: 12 }
        }) {
          Column() {
            Text(this.name)
              .fontSize(19)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(new BreakPointType<number>({
                sm: 2,
                md: Infinity,
                lg: Infinity
              }).getValue(this.currentBreakpoint))
              .fontWeight(FontWeight.Bold)
              .textAlign(this.currentBreakpoint === BreakpointConstants.SM ? TextAlign.Start : TextAlign.Center)
              .width(LayoutConstants.FULL_PERCENT)
            Text(this.description)
              .maxLines(new BreakPointType<number>({
                sm: 2,
                md: Infinity,
                lg: Infinity
              }).getValue(this.currentBreakpoint))
              .textAlign(this.currentBreakpoint === BreakpointConstants.SM ? TextAlign.Start : TextAlign.Center)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width(LayoutConstants.FULL_PERCENT)
          }
          // .padding(10)
          .justifyContent(FlexAlign.Center)
          .width(LayoutConstants.FULL_PERCENT)
          .height(new BreakPointType<number>({ sm: 80, md: 200, lg: 200 }).getValue(this.currentBreakpoint))
        }
      }
    }
    .scrollBar(BarState.Off)
    .scrollable(
      this.currentBreakpoint === BreakpointConstants.SM ?
      ScrollDirection.None :
      ScrollDirection.Vertical
    )
    // .height(LayoutConstants.FULL_PERCENT)
    .width(LayoutConstants.FULL_PERCENT)
    .padding(10)

    // Column({ space: 10 }) {
    //   Image(this.model.image)
    //     .borderRadius(20)
    //     .width(200)
    //     .height(200)
    //     .colorBlend(this.model.mainColor)
    //
    //   Text(this.name)
    //     .fontSize(20)
    //     .textOverflow({ overflow: TextOverflow.Ellipsis })
    //     .maxLines(1)
    //     .fontWeight(FontWeight.Bold)
    //     .textAlign(TextAlign.Center)
    //   Text(this.description)
    //     .maxLines(1)
    //     .textAlign(TextAlign.Center)
    //     .textOverflow({ overflow: TextOverflow.Ellipsis })
    // }.padding({ left: 20, right: 20 })

  }
}

@Component
export struct PlayListMusics {
  /**
   * 断点
   */
  @StorageProp('currentBreakpoint') @Watch('changeScroll') currentBreakpoint: string = BreakpointConstants.SM;
  /**
   * 歌曲id
   */
  @Prop musicIds: number[];
  /**
   * 0代表滚动到Scroll顶部，1代表中间值，2代表滚动到Scroll底部。
   */
  @Link scrollPosition: number;
  /**
   * 0代表滚动到List顶部，1代表中间值，2代表滚动到List底部。
   */
  @Link listPosition: number;
  musicInfoList: object[] = [];
  /**
   * 滚动组件控制器
   */
  scroller: Scroller;
  /**
   * 列表适配器
   */
  adapter: ListAdapter<object>;
  mapMusicInfo: Map<number, object> = new Map<number, object>();
  imageMap: Map<string, PicModel> = new Map<string, PicModel>();
  /**
   * 起始位置
   */
  startIndex = 0;
  /**
   * 结束位置
   */
  endIndex = 30;
  /**
   * 是否加载
   */
  @State isLoding: boolean = true;

  aboutToAppear() {
    this.adapter = new ListAdapter<object>(this.musicInfoList)
    this.getMusicList();
  }

  build() {
    Column() {
      List() {
        LazyForEach(this.adapter, (item, index) => {
          ListItem() {
            MusicListItem({
              index: index,
              songInfo: item,
              imageFun: async (url) => {
                if (this.imageMap.has(url)) {
                  let model = this.imageMap.get(url);
                  return model;
                }
                let model = await NetWorkUtil.getPic(url, 100, 100)
                this.imageMap.set(url, model);
                return model;
              }
            })
          }
        }, (item) => JSON.stringify(item))
        ListItem() {
          LoadingProgress()
        }
        .visibility(this.isLoding ? Visibility.Visible : Visibility.None)
        .height(56)
        .width(LayoutConstants.FULL_PERCENT)

        ListItem() {
          Text('没有更多了')
        }
        .visibility(!this.isLoding ? Visibility.Visible : Visibility.None)
        .height(56)
        .width(LayoutConstants.FULL_PERCENT)
      }
      .divider({
        strokeWidth: 2,
        color: '#1a000000',
        startMargin: 30,
        endMargin: 30
      })
      .onReachStart(() => {
        this.listPosition = 0;
      })
      .onReachEnd(() => {
        this.listPosition = 2;
        this.getMusicList();
      })
      .onScrollFrameBegin((offset: number, state: ScrollState) => {
        // 小尺寸屏幕滑动逻辑冲突处理
        if (this.currentBreakpoint === BreakpointConstants.SM) {
          if (this.listPosition === 0 && this.scrollPosition === 0 && offset >= 0) {
            this.scroller.scrollBy(0, offset)
            this.scrollPosition = 1;
            return { offsetRemain: 0 }
          }
          else if (this.listPosition === 0 && this.scrollPosition === 1 && offset >= 0) {
            this.scroller.scrollBy(0, offset)
            return { offsetRemain: 0 }
          }
          if (this.listPosition === 1 && this.scrollPosition === 0 && offset >= 0) {
            this.scroller.scrollBy(0, offset)
            this.scrollPosition = 1;
            return { offsetRemain: 0 }
          } else if (this.listPosition === 1 && this.scrollPosition === 1 && offset >= 0) {
            this.scroller.scrollBy(0, offset)
            return { offsetRemain: 0 }
          }


          if (offset <= 0 && this.listPosition === 0) {
            this.scroller.scrollBy(0, offset)
            this.scrollPosition = 1;
            return { offsetRemain: 0 }
          }
        }

        this.listPosition = 1;
        return { offsetRemain: offset };
      })
      .edgeEffect(EdgeEffect.None)
      .height('100%')
      .width('100%')
    }
  }

  changeScroll() {
    this.scrollPosition = 0;
  }

  /**
   * 获取音乐列表
   */
  async getMusicList() {
    if (this.startIndex >= this.musicIds.length) {
      this.isLoding = false;
      return
    }
    let musics = await Netease.Music.musicDetail(this.musicIds.slice(this.startIndex, this.endIndex))
    this.startIndex = this.endIndex;
    this.endIndex += 30;
    if (this.endIndex > this.musicIds.length) {
      this.endIndex = this.musicIds.length;
    }
    this.musicInfoList = this.musicInfoList.concat(musics['songs'])
    this.adapter.notifyDataReload(this.musicInfoList)
  }
}

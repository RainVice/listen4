import { Netease } from '@listen4/apis';
import { BreakpointConstants, LayoutConstants, SecondLevelTitleBar } from '@listen4/common';
import { PlayListCover, PlayListMusics } from '@listen4/music';
import router from '@ohos.router';

@Entry
@Component
struct PlaylistDetail {
  /**
   * 歌单信息
   */
  playListInfo: object = router.getParams();
  /**
   * 断点
   */
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;
  /**
   * 歌单详情
   */
  @State playListDetail: object = null;
  /**
   * 0代表滚动到Scroll顶部，1代表中间值，2代表滚动到Scroll底部。
   */
  @State scrollPosition: number = 0;
  /**
   * 0代表滚动到List顶部，1代表中间值，2代表滚动到List底部。
   */
  @State listPosition: number = 0;
  @State headerText: string = '返回';
  scroller: Scroller = new Scroller();

  async aboutToAppear() {
    this.playListDetail = await Netease.PlayList.detail(this.playListInfo['id']);
    // this.playListDetail['trackIds'].map(trackId => trackId['id']);
  }

  build() {

    Column() {
      // 只有在尺寸等于sm的时候，标题显示在此
      if (this.currentBreakpoint === BreakpointConstants.SM) {
        SecondLevelTitleBar({ title: this.headerText })
      }

      Scroll(this.scroller) {
        GridRow({
          columns: { sm: 4, md: 8, lg: 12 },
          gutter: 10
        }) {
          GridCol({
            span: { sm: 4, md: 3, lg: 4 }
          }) {
            Column() {
              // 只有在尺寸不等于sm的时候，标题显示在此
              if (this.currentBreakpoint !== BreakpointConstants.SM) {
                SecondLevelTitleBar()
              }
              PlayListCover({
                url: this.playListInfo['picUrl'],
                name: this.playListInfo['name'],
                description: this.playListDetail ? this.playListDetail['description'] : '暂无介绍'
              })
                .onVisibleAreaChange([0.2], (isVisible: boolean, currentRatio: number) => {
                  // 不显示之后把歌单名称显示到标题
                  if (isVisible) {
                    this.headerText = '返回';
                  } else {
                    this.headerText = this.playListInfo['name'];
                  }
                })
            }
          }

          GridCol({ span: { sm: 4, md: 5, lg: 8 } }) {
            Column() {
              if (this.playListDetail) {
                PlayListMusics({
                  musicIds: this.playListDetail['trackIds'].map(trackId => trackId['id']),
                  scrollPosition: $scrollPosition,
                  listPosition: $listPosition,
                  scroller: this.scroller
                })
              }
            }
          }
        }
      }
      .scrollBar(BarState.Off)
      // .edgeEffect(EdgeEffect.Spring)
      .onScrollEdge((side) => {
        if (side === Edge.Top) {
          this.scrollPosition = 0
        } else if (side === Edge.Bottom) {
          this.scrollPosition = 2
        }
      })
      .align(Alignment.TopStart)
      .scrollable(
        this.currentBreakpoint === BreakpointConstants.SM ?
        ScrollDirection.Vertical :
        ScrollDirection.None
      )
      .width(LayoutConstants.FULL_PERCENT)
      .layoutWeight(1)
    }
    .width(LayoutConstants.FULL_PERCENT)
    .height(LayoutConstants.FULL_PERCENT)

  }
}

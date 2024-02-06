import { Netease } from '@listen4/apis';
import { BreakpointConstants, LayoutConstants, SecondLevelTitleBar } from '@listen4/common';
import { PlayListCover, PlayListMusics } from '@listen4/music';
import router from '@ohos.router';

@Entry
@Component
struct PlaylistDetail {
  @State playListInfo: object = router.getParams();
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;
  @State playListDetail: object = null;

  async aboutToAppear() {
    this.playListDetail = await Netease.PlayList.detail(this.playListInfo['id']);
    console.log(JSON.stringify(this.playListDetail));
    return
  }

  build() {

    Column() {

      // 只有在尺寸等于sm的时候，标题显示在此
      if (this.currentBreakpoint === BreakpointConstants.SM) {
        SecondLevelTitleBar()
      }

      Scroll() {
        // todo 处理 List 与 Scroll 滑动冲突问题
        GridRow({
          columns: { sm: 4, md: 8, lg: 12 },
          gutter: 10
        }) {
          GridCol({
            span: { sm: 4, md: 3, lg: 4 }
          }) {
            Column() {
              // 只有在尺寸不等于等于sm的时候，标题显示在此
              if (this.currentBreakpoint !== BreakpointConstants.SM) {
                SecondLevelTitleBar()
              }
              PlayListCover({
                picUrl: this.playListInfo['picUrl'],
                name: this.playListInfo['name'],
                description: this.playListDetail ? this.playListDetail['description'] : '暂无介绍'
              })
            }
          }

          GridCol({
            span: { sm: 4, md: 5, lg: 8 }
          }) {
            Column() {
              if (this.playListDetail) {
                PlayListMusics({
                  musicIds: this.playListDetail['trackIds'].map(trackId => trackId['id'])
                })
              }
            }
          }
        }
      }
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

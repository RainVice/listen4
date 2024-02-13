import { BreakpointConstants, SecondLevelTitleBar } from '@listen4/common';
import { HotReviews, MusicCover } from '@listen4/music';

@Entry
@Component
struct MusicDetail {
  /**
   * 断点
   */
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;

  build() {

    Column() {

      if (this.currentBreakpoint === BreakpointConstants.SM) {
        SecondLevelTitleBar()
      }
      GridRow({
        columns: { sm: 4, md: 8, lg: 12 },
        gutter: 10
      }) {


        GridCol({
          span: { sm: 4, md: 3, lg: 4 }
        }) {
          Column() {
            if (this.currentBreakpoint !== BreakpointConstants.SM) {
              SecondLevelTitleBar()
            }
            MusicCover()
          }
        }

        GridCol({
          span: { sm: 4, md: 5, lg: 8 }
        }) {
          Column() {
            HotReviews()
          }
        }

      }
    }


    // Column({ space: 20 }) {
    //
    //   SecondLevelTitleBar()
    //
    //   MusicCover()
    //
    //   HotReviews()
    //
    //
    // }
    // .justifyContent(FlexAlign.Center)

  }
}
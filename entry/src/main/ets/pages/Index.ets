import { BreakpointConstants, BreakpointSystem, LayoutConstants } from '@listen4/common';
import { ComponentConstants } from '../constants/EntryConstants';
import { bottomInfo, BottomNavigationInfo } from '../viewmodel/BottomNavigationData';
import { MusicRecommend } from '@listen4/music';


@Entry
@Component
struct Index {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;
  @StorageProp('statusBarHeight') statusBarHeight: number = 0;
  @State currentPageIndex: number = 0;

  aboutToAppear() {
    BreakpointSystem.register();
  }

  aboutToDisappear() {
    BreakpointSystem.unregister();
  }

  build() {
    Row() {
      Tabs({
        barPosition: this.currentBreakpoint === BreakpointConstants.LG ? BarPosition.Start : BarPosition.End,
        index: this.currentPageIndex
      }) {
        TabContent() {
          MusicRecommend()
        }
        .tabBar(this.BottomNavigation(bottomInfo[ComponentConstants.HOME_INDEX]))

        TabContent()
          .tabBar(this.BottomNavigation(bottomInfo[ComponentConstants.LOVE_INDEX]))

      }
      .onChange((index: number) => {
        this.currentPageIndex = index;
      })
      .vertical(this.currentBreakpoint === BreakpointConstants.LG)
    }
    .margin({
      top: this.statusBarHeight
    })
    .height(LayoutConstants.FULL_PERCENT)
  }

  @Builder
  BottomNavigation(info: BottomNavigationInfo) {
    Column({ space: ComponentConstants.NAVIGATION_BUTTON_SPACE }) {

      Image(info.img)
        .width(ComponentConstants.NAVIGATION_BUTTON_ICON_SIZE)
        .height(ComponentConstants.NAVIGATION_BUTTON_ICON_SIZE)
        .colorBlend(this.currentPageIndex === info.index ? info.selectColor : info.color)
      Text(info.title)
        .visibility(this.currentPageIndex === info.index ? Visibility.Visible : Visibility.None)
        .fontColor(this.currentPageIndex === info.index ? info.selectColor : info.color)
        .fontSize(ComponentConstants.NAVIGATION_BUTTON_TEXT_SIZE)
        .fontWeight(FontWeight.Bolder)

    }
  }
}
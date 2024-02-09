import router from '@ohos.router';
import { BreakpointConstants } from '../constants/BreakpointConstants';
import { HeaderConstants } from '../constants/HeaderConstants';
import { LayoutConstants } from '../constants/LayoutConstants';
import { BreakPointType } from '../utils/BreakpointSystem';


@Component
export struct FirstLevelTitleBar {
  @Prop title: Resource;

  build() {
    Column() {
      Text(this.title)
        .fontWeight(FontWeight.Bold)
        .fontSize(HeaderConstants.TITLE_FONT_SIZE)
    }
    .padding({
      left: HeaderConstants.PADDING_LEFT
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .height(HeaderConstants.HEADER_HEIGHT)
    .width(LayoutConstants.FULL_PERCENT)
  }
}

@Component
export struct SecondLevelTitleBar {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;
  @Prop title: string = '返回';
  breakPointType: BreakPointType<number> = new BreakPointType<number>({ sm: 25, md: 18, lg: 25 })

  build() {

    Row({ space: 10 }) {
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.ic_public_back'))
          .width(this.breakPointType.getValue(this.currentBreakpoint))
          .height(this.breakPointType.getValue(this.currentBreakpoint))
      }.backgroundColor(Color.White)
      .onClick(() => {
        router.back();
      })

      Text(this.title)
        .maxFontSize(new BreakPointType<number>({ sm: 20, md: 15, lg: 20 }).getValue(this.currentBreakpoint))
        .minFontSize(new BreakPointType<number>({ sm: 15, md: 12, lg: 15 }).getValue(this.currentBreakpoint))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)

      // Blank()

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.ic_public_more'))
          .width(this.breakPointType.getValue(this.currentBreakpoint))
          .height(this.breakPointType.getValue(this.currentBreakpoint))
      }.backgroundColor(Color.White)

    }
    .backgroundColor(Color.White)
    .padding({ left: 20, right: 20 })
    .height(new BreakPointType<number>({ sm: 56, md: 45, lg: 56 }).getValue(this.currentBreakpoint))
    .width(LayoutConstants.FULL_PERCENT)
  }
}
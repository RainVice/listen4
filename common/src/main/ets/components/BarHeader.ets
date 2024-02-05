import { HeaderConstants } from '../constants/HeaderConstants';
import { LayoutConstants } from '../constants/LayoutConstants';

@Preview
@Component
export struct BarHeader {
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
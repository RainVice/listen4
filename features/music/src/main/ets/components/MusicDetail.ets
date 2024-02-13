/**
 * 音乐详情组件
 */
import { LayoutConstants } from '@listen4/common/src/main/ets/constants/LayoutConstants'

@Component
export struct MusicCover {
  build() {

    Row({ space: 10 }) {

      Image('https://infinitypro-img.infinitynewtab.com/wallpaper/travel/6268.jpg')
        .width(60)
        .height(60)
        .borderRadius(60)

      Text('音乐名')

    }
    .justifyContent(FlexAlign.Start)
    .width('90%')

  }
}


@Component
export struct HotReviews {
  build() {


    Column() {

      //热评
      Text('热评').margin(10)


    }
    .borderRadius(10)
    .shadow({
      radius: 10,
      color: '#33000000',
    })
    .width('90%')
    .height(LayoutConstants.FULL_PERCENT)

  }
}
import { BreakpointConstants, BreakPointType, FirstLevelTitleBar, LayoutConstants } from '@listen4/common';
import router from '@ohos.router';
/**
 * todo 因登录验证问题无法解决，暂时搁置，收藏页面
 */
@Component
export struct Like {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;

  build() {

    Column({ space: 10 }) {
      FirstLevelTitleBar({ title: $r('app.string.like_title_bar') })
      Scroll() {
        Column({ space: 10 }) {
          GridRow({ columns: { sm: 4, md: 8, lg: 12 }, gutter: 10 }) {

            // 登陆信息
            GridCol({ span: { sm: 4, md: 4, lg: 6 } }) {
              Stack() {
                Image('https://infinitypro-img.infinitynewtab.com/wallpaper/travel/6268.jpg')
                  .width(LayoutConstants.FULL_PERCENT)
                  .height(LayoutConstants.FULL_PERCENT)
                  .borderRadius(10)
                  .blur(20)
                Column({ space: 5 }) {
                  Text('用户名')
                    .fontSize(25)
                    .fontWeight(FontWeight.Bold)
                  Text('信息1')// .fontWeight(FontWeight.Bold)
                    .fontColor('#99000000')
                  Text('信息2')// .fontWeight(FontWeight.Bold)
                    .fontColor('#99000000')
                }.width('90%')
                // .height(LayoutConstants.FULL_PERCENT)
                .alignItems(HorizontalAlign.Start)
              }
              .width(LayoutConstants.FULL_PERCENT)
              .height(new BreakPointType<number>({
                sm: 150,
                md: 150,
                lg: 200
              }).getValue(this.currentBreakpoint))
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Login'
                })
              })
            }
            .borderRadius(10)
            .shadow({
              radius: 10,
              color: '#4d000000',
            })

            // 播放控制器
            GridCol({ span: { sm: 4, md: 4, lg: 6 } }) {
              Stack() {
                Image('https://infinitypro-img.infinitynewtab.com/wallpaper/travel/6268.jpg')
                  .width(LayoutConstants.FULL_PERCENT)
                  .height(LayoutConstants.FULL_PERCENT)
                  .borderRadius(10)
                  .blur(20)
                Column({ space: 5 }) {
                  Text('音乐名')
                    .fontSize(25)
                    .fontWeight(FontWeight.Bold)
                  Text('歌词')
                    .fontSize(18)
                    .fontColor('#80000000')
                    .fontWeight(FontWeight.Bold)

                  Blank()
                  Row({ space: 5 }) {
                    Column() {
                      Button('上一曲')
                    }.layoutWeight(1)

                    Column() {
                      Button('上一曲')
                    }.layoutWeight(1)

                    Column() {
                      Button('上一曲')
                    }.layoutWeight(1)

                  }
                }.width('80%')
                .height('80%')
              }
              .width(LayoutConstants.FULL_PERCENT)
              .height(new BreakPointType<number>({
                sm: 150,
                md: 150,
                lg: 200
              }).getValue(this.currentBreakpoint))
            }
            .borderRadius(10)
            .shadow({
              radius: 10,
              color: '#4d000000',
            })

            GridCol({ span: { sm: 4, md: 4, lg: 4 } }) {
              Row() {
                Column({ space: 5 }) {
                  Button('')
                  Text('每日推荐')
                    .fontSize(14)
                    .fontColor('#99000000')
                }.layoutWeight(1)

                Column({ space: 5 }) {
                  Button('')
                  Text('心动模式`')
                    .fontSize(14)
                    .fontColor('#99000000')
                }.layoutWeight(1)

                Column({ space: 5 }) {
                  Button('')
                  Text('电台`')
                    .fontSize(14)
                    .fontColor('#99000000')
                }.layoutWeight(1)

                Column({ space: 5 }) {
                  Button('')
                  Text('历史记录')
                    .fontSize(14)
                    .fontColor('#99000000')
                }.layoutWeight(1)

              }.width('90%').height(80)
            }
            .borderRadius(10)
            .shadow({
              radius: 10,
              color: '#4d000000',
            })


            // 喜欢的音乐
            GridCol({ span: { sm: 4, md: 4, lg: 4 } }) {
              Row() {
                Text('喜欢的音乐').fontSize(18).fontWeight(FontWeight.Bold)
              }
              .width('90%')
              .height(80)
            }
            .borderRadius(10)
            .shadow({
              radius: 10,
              color: '#4d000000',
            })

            // 收藏歌单
            GridCol({ span: { sm: 4, md: 4, lg: 4 } }) {
              Row() {
                Text('收藏歌单').fontSize(18).fontWeight(FontWeight.Bold)
              }
              .width('90%')
              .height(80)
            }
            .borderRadius(10)
            .shadow({
              radius: 10,
              color: '#4d000000',
            })

          }
          .padding({ left: 20, right: 20 })
        }.width(LayoutConstants.FULL_PERCENT)

      }
      .align(Alignment.Top)
      .width(LayoutConstants.FULL_PERCENT)
      .height(LayoutConstants.FULL_PERCENT)
    }
    .width(LayoutConstants.FULL_PERCENT)
    .height(LayoutConstants.FULL_PERCENT)

  }
}
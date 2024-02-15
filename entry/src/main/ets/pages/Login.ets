import { Netease } from '@listen4/apis/src/main/ets/netease/Netease';
import { FirstLevelTitleBar, LayoutConstants } from '@listen4/common';
/**
 * todo 登录页面
 */
@Entry
@Component
struct Login {
  @State username: string = '123';
  @State password: string = '';

  build() {

    GridRow({
      columns: { sm: 12, md: 12, lg: 12 },
      gutter: 10
    }) {
      GridCol({
        span: { sm: 0, md: 2, lg: 3 }
      })

      GridCol({
        span: { sm: 12, md: 8, lg: 6 }
      }) {
        Column({ space: 20 }) {
          FirstLevelTitleBar({ title: $r('app.string.login_text') })
          TextInput({ placeholder: $r('app.string.login_username_tip') })
            .width(LayoutConstants.FULL_PERCENT)
            .height(50)
            .fontSize(18)
            .onChange((value) => {
              this.username = value;
            })


          TextInput({ placeholder: $r('app.string.login_password_tip') })
            .type(InputType.Password)
            .width(LayoutConstants.FULL_PERCENT)
            .height(50)
            .fontSize(18)
            .onChange((value) => {
              this.password = value;
            })


          Button($r('app.string.login_text'))
            .width(LayoutConstants.FULL_PERCENT)
            .height(50)
            .onClick(() => {
              // todo 登录
              Netease.Music.songUrl(['516657140'])
            })

        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .width('90%')
        .height(LayoutConstants.FULL_PERCENT)
      }

    }

  }
}
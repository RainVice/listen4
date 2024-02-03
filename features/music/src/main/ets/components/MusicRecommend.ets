import { BarHeader, LayoutConstants, Logger} from '@listen4/common'
import {Netease} from '@listen4/apis'
@Component
export struct MusicRecommend{

  build(){

    Column(){
      BarHeader({title: '音乐'})

      Scroll(){
        Column(){

          Text('推荐歌单>')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

          Button('获取')
            .onClick(async () => {
              let obj = await Netease.User.anonimous();
              Logger.infoWithTag('结果',JSON.stringify(obj));
            })


        }
        .alignItems(HorizontalAlign.Start)
        .width(LayoutConstants.FULL_PERCENT)
      }
      .padding({ left: 20,right: 20 })

    }
    .height(LayoutConstants.FULL_PERCENT)
    .width(LayoutConstants.FULL_PERCENT)

  }


  async aaa(): Promise<string>{
    return 'string';
  }

}
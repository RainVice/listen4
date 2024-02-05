import image from '@ohos.multimedia.image';
import http from '@ohos.net.http';
import effectKit from '@ohos.effectKit';

export interface PicModel {

  image?: image.PixelMap;
  mainColor?: string;
  fontColor?: string;

}

export class NetWorkUtil {
  /**
   * 获取图片信息
   * @param url 图片url
   * @returns 是否从本地读取
   */
  static async getPic(url: string, local: boolean = true): Promise<PicModel> {

    if (!url.includes('param')) {
      url += '?param=512y512'
    }

    if (local && AppStorage.Has(url)) {
      let model = AppStorage.Get<PicModel>(url);
      return model;
    }
    // 网络请求图片，获取主色调，设置字体颜色
    let res = await http.createHttp().request(url, { expectDataType: http.HttpDataType.ARRAY_BUFFER })
    let model: PicModel = {};
    // 将图片资源转为像素图（PixelMap）
    model.image = await image.createImageSource(res.result as ArrayBuffer).createPixelMap();
    let colorPicker: effectKit.ColorPicker = await effectKit.createColorPicker(model.image);
    // 获取主色调
    let rgba = colorPicker.getMainColorSync();
    // 获取主色
    model.mainColor = `rgba(${rgba.red},${rgba.green},${rgba.blue},0.3)`;
    // 取反色
    model.fontColor = `rgba(${255 - rgba.red},${255 - rgba.green},${255 - rgba.blue},${rgba.alpha / 255})`;
    AppStorage.SetOrCreate<PicModel>(url, model);
    return model;
  }
}

import { crypto } from '../utils/crypto';
import http from '@ohos.net.http';
import { NeteaseConstants } from '../constants/NeteaseConstants';

const config = {
  "anonymous_token": "bf8bfeabb1aa84f9c8c3906c04a04fb864322804c83f5d607e91a04eae463c9436bd1a17ec353cf780b396507a3f7464e8a60f4bbc019437993166e004087dd32d1490298caf655c2353e58daa0bc13cc7d5c198250968580b12c1b8817e3f5c807e650dd04abd3fb8130b7ae43fcc5b",
  "resourceTypeMap": {
    "0": "R_SO_4_",
    "1": "R_MV_5_",
    "2": "A_PL_0_",
    "3": "R_AL_3_",
    "4": "A_DJ_1_",
    "5": "R_VI_62_",
    "6": "A_EV_2_",
    "7": "A_DR_14_"
  }
}

/**
 * UAOption枚举类型，表示可选的用户代理类型
 */
export enum UserAgentOption {
  // 移动端用户代理
  Mobile = 'mobile',
  // 电脑端用户代理
  PC = 'pc'
}

export interface Options {

  ua?: string;
  realIP?: string;
  ip?: string;
  crypto?: string;
  url?: string;
  proxy?: string;
  cookie?: object;

}

export class Api {
  /**
   * 发送网络请求
   * @param method 请求方法
   * @param url 请求地址
   * @param data 请求数据
   * @param options 请求选项
   * @returns 返回Promise对象，包含请求结果
   */
  public static async send(method: http.RequestMethod, url: string, data: object = {}, options: Options = {
    crypto: 'weapi'
  }): Promise<http.HttpResponse> {
    if (!url.includes('https://music.163.com/')) {
      url = ('https://music.163.com/' + url).replace('m//', 'm/');
    }
    let headers = this.getHeader(method, url, options);
    headers = await this.setCookie(headers, options);

    // 加密
    if (options.crypto === 'weapi') {
      let csrfToken = this.getCookie()['__csrf']
      data['csrf_token'] = csrfToken ? csrfToken : ''
      data = await crypto.weapi(data)
      url = url.replace(/\w*api/, 'weapi')
    }
    else if (options.crypto === 'linuxapi') {
      data = await crypto.linuxapi({
        method: method,
        url: url.replace(/\w*api/, 'api'),
        params: data,
      })
      headers['User-Agent'] =
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36'
      url = 'https://music.163.com/api/linux/forward'
    }
    else if (options.crypto === 'eapi') {
      let cookie = this.getCookie();
      cookie = {
        ...options.cookie,
        ...cookie,
      }
      const csrfToken = cookie['__csrf'] || ''
      const header = {
        osver: cookie['osver'] || '', //系统版本
        deviceId: cookie['deviceId'] || '', //encrypt.base64.encode(imei + '\t02:00:00:00:00:00\t5106025eb79a5247\t70ffbaac7')
        appver: cookie['appver'] || '8.9.70', // app版本
        versioncode: cookie['versioncode'] || '140', //版本号
        mobilename: cookie['mobilename'] || '', //设备model
        buildver: cookie['buildver'] || Date.now(),
        resolution: cookie['resolution'] || '1920x1080', //设备分辨率
        __csrf: csrfToken,
        os: cookie['os'] || 'android',
        channel: cookie['channel'] || '',
        requestId: `${Date.now()}_${Math.floor(Math.random() * 1000)
          .toString()
          .padStart(4, '0')}`,
      }
      if (cookie['MUSIC_U']) header['MUSIC_U'] = cookie['MUSIC_U']
      if (cookie['MUSIC_A']) header['MUSIC_A'] = cookie['MUSIC_A']
      headers['Cookie'] = Object.keys(header)
        .map((key) => encodeURIComponent(key) + '=' + encodeURIComponent(header[key]),)
        .join('; ');
      data['header'] = header
      data = await crypto.eapi(url, data)
      url = url.replace(/\w*api/, 'eapi')
    }
    // 配置
    let config: http.HttpRequestOptions = {
      method: method,
      header: headers,
      extraData: Object.keys(data)
        .map((key) => encodeURIComponent(key) + '=' + encodeURIComponent(data[key]),)
        .join('&'),
      readTimeout: 1000,
      connectTimeout: 1000,
      expectDataType: options.crypto === 'eapi' ? http.HttpDataType.ARRAY_BUFFER : http.HttpDataType.OBJECT,
    }

    // todo 添加代理功能
    // ...


    return http.createHttp().request(url, config)
  }

  /**
   * 选择用户代理
   * @param ua 用户代理类型
   * @returns 随机选择的用户代理字符串
   */
  private static chooseUserAgent(ua: string): string {
    const userAgentList = {
      mobile: [
      // iOS 13.5.1 14.0 beta with safari
        'Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Mobile/15E148 Safari/604.1',
        'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.',
        // iOS with qq micromsg
        'Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/602.1.50 (KHTML like Gecko) Mobile/14A456 QQ/6.5.7.408 V1_IPH_SQ_6.5.7_1_APP_A Pixel/750 Core/UIWebView NetType/4G Mem/103',
        'Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/7.0.15(0x17000f27) NetType/WIFI Language/zh',
        // Android -> Huawei Xiaomi
        'Mozilla/5.0 (Linux; Android 9; PCT-AL10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.64 HuaweiBrowser/10.0.3.311 Mobile Safari/537.36',
        'Mozilla/5.0 (Linux; U; Android 9; zh-cn; Redmi Note 8 Build/PKQ1.190616.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/71.0.3578.141 Mobile Safari/537.36 XiaoMi/MiuiBrowser/12.5.22',
        // Android + qq micromsg
        'Mozilla/5.0 (Linux; Android 10; YAL-AL00 Build/HUAWEIYAL-AL00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2581 MMWEBSDK/200801 Mobile Safari/537.36 MMWEBID/3027 MicroMessenger/7.0.18.1740(0x27001235) Process/toolsmp WeChat/arm64 NetType/WIFI Language/zh_CN ABI/arm64',
        'Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; BKK-AL10 Build/HONORBKK-AL10) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/66.0.3359.126 MQQBrowser/10.6 Mobile Safari/537.36',
      ],
      pc: [
      // macOS 10.15.6  Firefox / Chrome / Safari
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:80.0) Gecko/20100101 Firefox/80.0',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.30 Safari/537.36',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15',
        // Windows 10 Firefox / Chrome / Edge
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.30 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/13.10586',
      // Linux 就算了
      ],
    }
    let realUserAgentList =
      userAgentList[ua] || userAgentList.mobile.concat(userAgentList.pc)
    return realUserAgentList[Math.floor(Math.random() * realUserAgentList.length)];
  }


  /**
   * 获取请求头
   * @param method 请求方法
   * @param url 请求URL
   * @param options 请求选项
   * @returns 请求头对象
   */
  private static getHeader(method: http.RequestMethod, url: string, options: Options): object {
    // 设置User-Agent
    let headers = { 'User-Agent': this.chooseUserAgent(options.ua) }
    // 设置Content-Type
    if (method === http.RequestMethod.POST)
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    // 设置Referer
    headers['Referer'] = 'https://music.163.com';
    // 设置IP
    let ip: string = options.realIP || options.ip || '::1';
    headers['X-Real-IP'] = ip;
    headers['X-Forwarded-For'] = ip;
    // 设置Connection
    headers['Connection'] = 'keep-alive'

    return headers;
  }


  /**
   * 设置cookie
   * @param headers 请求头
   * @param options 选项
   * @returns Promise对象，返回更新后的请求头
   */
  private static async setCookie(headers: object, options: Options): Promise<object> {
    let cookie = this.getCookie();
    cookie = {
      ...options.cookie,
      ...cookie,
      __remember_me: true,
      NMTID: (await crypto.randomBytes(16)).toString('hex'),
      _ntes_nuid: (await crypto.randomBytes(16)).toString('hex'),
    }
    if (!cookie['MUSIC_U'] && !cookie['MUSIC_A']) {
      cookie['MUSIC_A'] = config.anonymous_token;
    }

    headers['Cookie'] = Object.keys(cookie)
      .map((key) => encodeURIComponent(key) + '=' + encodeURIComponent(cookie[key]))
      .join('; ');
    return headers;
  }

  /**
   * 获取cookie
   * @returns 返回cookie对象
   */
  private static getCookie(): object {
    let cookie = AppStorage.Get<object>(NeteaseConstants.NETEASE_COOKIE) || {};
    return cookie;
  }
}


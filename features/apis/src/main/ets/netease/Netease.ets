import http from '@ohos.net.http';
import { NeteaseConstants } from '../constants/NeteaseConstants';
import { Api, Options } from './Api';
import { DataKeys, KVDBUtil } from '@listen4/common';
import { crypto } from '../utils/crypto';

export namespace Netease {


  /**
   * 登陆选项
   */
  export enum LoginOption {
    Phone,
    Email
  }

  /**
   * 设备选项
   */
  export enum DeviceOption {

    IOS = 'ios',
    ANDROID = 'android',
    PC = 'pc'

  }


  /**
   * 用户相关接口
   */
  export class User {
    /**
     * 手机验证码登录
     * @param phone 电话
     * @param code 验证码
     */
    public static async cellphone(phone: string, code: string) {
      let data = {
        'captcha': code,
        'countrycode': '86',
        'phone': phone,
        'rememberLogin': true
      }

      Api.send(http.RequestMethod.POST, 'weapi/login/cellphone', data).then((response) => {
        return
      })
        .catch((err) => {
          return
        })
    }

    public static async send(phone: string) {
      let data = {
        'cellphone': phone,
        'ctcode': '86'
      }

      Api.send(http.RequestMethod.POST, 'weapi/sms/captcha/sent', data).then((response) => {
        return
      })
    }

    /**
     * todo 邮箱或手机登陆,会跳验证，暂时无法使用
     * @param username 账号
     * @param password 密码
     * @param loginOption 登陆选项
     */
    public static async Login(username: string, password: string, loginOption: LoginOption = LoginOption.Phone) {

      // md5 加密
      password = await crypto.md5(password);

      // 设置数据
      if (loginOption === LoginOption.Phone) {
        let data = {
          'phone': username,
          'password': password,
          'countrycode': '86',
          'rememberLogin': 'true'
        }
      }
      else if (loginOption === LoginOption.Email) {
        let data = {
          'username': username,
          'password': password,
          'rememberLogin': 'true'
        }
        let options: Options = {
          crypto: 'weapi',
          ua: 'pc',
          cookie: {
            os: DeviceOption.IOS,
            appver: '8.7.01'
          }
        }

        Api.send(http.RequestMethod.POST, 'api/login', data, options).then((response) => {
          return
        })

      }
      else {
        return;
      }


    }

    /**
     * 游客登陆
     */
    public static async anonimous(): Promise<http.HttpResponse> {
      let option: Options = {
        crypto: 'weapi',
        cookie: {
          os: DeviceOption.IOS
        }
      }
      let data = {
        username: 'MzEwMjcwYmY0Y2Y0ODcwMzU0ZDFkZmIxMmMzMGYyMTkgVlBaanMwNmtrb1BYMGxOVzVUMUJ3Zz09',
      }
      let result = await Api.send(
        http.RequestMethod.POST,
        '/api/register/anonimous',
        data,
        option
      )
      let cookies = this.parseCookies(result.cookies);
      this.setCookie(cookies);
      return result
    }

    /**
     * 设置cookie
     * @param cookies cookie数组
     */
    private static setCookie(cookies: string[][]) {
      let cookie = {}
      cookies.forEach((coo) => {
        cookie[coo[5] || 'null'] = coo[6] || 'null';
      })
      AppStorage.SetOrCreate<object>(NeteaseConstants.NETEASE_COOKIE, cookie);
    }

    /**
     * 解析cookie字符串
     * @param cookies cookie字符串
     * @returns cookie数组
     */
    private static parseCookies(cookies: string) {
      return cookies.split('\n').map((line) => line.trim().split('\t'));
    }
  }

  /**
   * 歌单相关接口
   */
  export class PlayList {
    /**
     * 获取推荐歌单
     * @param context 上下文
     * @param local 是否读取本机缓存
     * @returns
     */
    public static async personalized(local: boolean = true): Promise<object[]> {

      const kvdb = AppStorage.Get<KVDBUtil>(DataKeys.NETEASE_KV)
      try {
        if (!local) {
          throw new Error('network');
        }
        let json = await kvdb.get('PlayList.personalized') as string;
        let temp = JSON.parse(json)
        if (typeof temp === 'string') {
          return JSON.parse(temp)['result']
        }
        return temp['result'];
      }
      catch (err) {
        // 没有本地缓存，请求
        let url = 'weapi/personalized/playlist'
        let data = {
          limit: 30,
          total: true,
          n: 1000
        }
        let result = await Api.send(http.RequestMethod.POST, url, data);
        let res = result.result;
        // 保存到本地
        await kvdb.put('PlayList.personalized', JSON.stringify(res));
        return res['result'];
      }
    }

    /**
     * 获取歌单详情
     * @param id 歌单id
     * @returns
     */
    public static async detail(id: number) {
      let url = 'api/v6/playlist/detail'
      let data = {
        id: id,
        n: 100000,
        s: 8,
      }
      let option: Options = {
        crypto: 'api',
      }
      let result = await Api.send(http.RequestMethod.POST, url, data, option);
      if (typeof result.result === 'string') {
        let json = result.result;
        return JSON.parse(json)['playlist'];
      } else {
        return result.result['playlist'];
      }
    }
  }

  /**
   * 音乐相关接口
   */
  export class Music {
    /**
     * todo 获取歌曲url
     * @param ids 歌曲id
     * @returns
     */
    public static async songUrl(ids: string[]) {
      const data = {
        ids: '[' + ids.map((id) => id).join(',') + ']',
        br: 999000
      }
      Api.send(http.RequestMethod.POST, 'eapi/song/enhance/player/url', data, {
        crypto: 'eapi',
        cookie: { os: 'pc' },
        url: '/api/song/enhance/player/url'
      }).then((response) => {
        return
      }).catch((err) => {
        return
      })
    }

    /**
     * 获取最新音乐
     * @param local 是否读取本地缓存
     * @returns
     */
    public static async newMusic(local: boolean = true): Promise<object[]> {
      const kvdb = AppStorage.Get<KVDBUtil>(DataKeys.NETEASE_KV)
      try {
        if (!local) {
          throw new Error('network');
        }
        let json = await kvdb.get('Music.newMusic') as string;
        let temp = JSON.parse(json)
        if (typeof temp === 'string') {
          return JSON.parse(temp)['result']
        }
        return temp['result'];
      } catch (err) {
        let url = 'api/personalized/newsong'
        const data = {
          type: 'recommend',
          limit: 10,
          areaId: 0,
        }
        let result = await Api.send(http.RequestMethod.POST, url, data);
        let res = result.result;
        await kvdb.put('Music.newMusic', JSON.stringify(res));
        return res['result']
      }
    }


    /**
     * 获取音乐详情
     * @param ids 歌曲id
     * @returns
     */
    public static async musicDetail(ids: number[]): Promise<object> {
      const data = {
        c: '[' + ids.map((id) => '{"id":' + id + '}').join(',') + ']',
        ids: '[' + ids.map((id) => id).join(',') + ']'
      }
      const url = 'weapi/v3/song/detail';
      let res = await Api.send(http.RequestMethod.POST, url, data, { crypto: 'weapi' })
      if (typeof res.result === 'string') {
        let json = res.result;
        console.log(`json:${json}`)
        return JSON.parse(json);
      } else {
        return res.result;
      }
    }

    public static async musicDetail1(ids: number[]): Promise<object> {
      const data = {
        c: '[' + ids.map((id) => '{"id":' + id + '}').join(',') + ']',
        // ids: '[' + ids.map((id) => id).join(',') + ']'
      }
      const url = 'weapi/v3/song/detail';
      return Api.send(http.RequestMethod.POST, url, data, { crypto: 'weapi' }).then(res => {
        if (typeof res.result === 'string') {
          let json = res.result;
          console.log(`json:${json}`)
          return JSON.parse(json);
        } else {
          return res.result;
        }
      }).catch(err => {
        return
      })
    }
  }
}

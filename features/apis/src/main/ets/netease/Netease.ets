import http from '@ohos.net.http';
import { NeteaseConstants } from '../constants/NeteaseConstants';
import { Api, Options } from './Api';
import { DataKeys, KVDBUtil } from '@listen4/common';

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
    public static async

    /**
     * 邮箱或手机登陆
     * @param username 账号
     * @param password 密码
     * @param loginOption 登陆选项
     */
    public static Login(username: string, password: string, loginOption: LoginOption = LoginOption.Phone) {

      // md5 加密 password
      // password = crypto.createHash('md5').update(password).digest('hex');

      // 设置数据
      let data;
      if (loginOption === LoginOption.Phone) {
        data = {
          'phone': username,
          'password': password,
          'countrycode': '86',
          'rememberLogin': 'true'
        }
      }
      else if (loginOption === LoginOption.Email) {
        data = {
          'username': username,
          'password': password,
          'rememberLogin': 'true'
        }
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
      AppStorage.Set<object>(NeteaseConstants.NETEASE_COOKIE, cookie);
    }

    /**
     * 解析cookie字符串
     * @param cookies cookie字符串
     * @returns cookie数组
     */
    private static parseCookies(cookies: string) {
      return cookies.split('\n').map((line) => line.split(' '));
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
        let data = await kvdb.get('PlayList.personalized') as string;
        return (JSON.parse(data))['result'];
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
      let res = result.result as string;
      return JSON.parse(res)['playlist'];
    }
  }

  /**
   * 音乐相关接口
   */
  export class Music {
    public static async

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
        let data = await kvdb.get('Music.newMusic') as string;
        return JSON.parse(data)['result'];
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
      }
      const url = 'weapi/v3/song/detail';
      let res = await Api.send(http.RequestMethod.POST, url, data, { crypto: 'weapi' })
      return JSON.parse(res.result as string);
    }
  }
}

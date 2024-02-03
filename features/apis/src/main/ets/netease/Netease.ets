import http from '@ohos.net.http';
import { NeteaseConstants } from '../constants/NeteaseConstants';
import { Api, Options } from './Api';
import { Personalized, PersonalizedResult } from './Bean';

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
     * 推荐歌单
     */
    public static async personalized(): Promise<PersonalizedResult[]> {
      let url = 'weapi/personalized/playlist'
      let data = {
        limit: 30,
        total: true,
        n: 1000
      }
      let result = await Api.send(http.RequestMethod.POST, url, data);
      return (result.result as Personalized).result
    }
  }


}

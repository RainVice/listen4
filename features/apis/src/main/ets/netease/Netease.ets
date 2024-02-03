import http from '@ohos.net.http';
import { Api, Options } from './Api';
export namespace Netease{


  /**
   * 登陆选项
   */
  export enum LoginOption{
    Phone,
    Email
  }

  /**
   * 设备选项
   */
  export enum DeviceOption{

    IOS = 'ios' ,
    ANDROID = 'android',
    PC = 'pc'

  }



  /**
   * 用户相关接口
   */
  export class User{
    /**
     * 邮箱或手机登陆
     * @param username 账号
     * @param password 密码
     * @param loginOption 登陆选项
     */
    public static Login(username: string, password: string , loginOption: LoginOption = LoginOption.Phone){

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
      else if(loginOption === LoginOption.Email){
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
    public static async anonimous() : Promise<object>{
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
        'https://music.163.com/api/register/anonimous',
        data,
        option
      )

      let res = {"responseCode":200,"cookies":".music.163.com\tTRUE\t/eapi/clientlog\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/wapi/clientlog\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/eapi/feedback\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/neapi/clientlog\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/weapi/feedback\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/api/clientlog\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/neapi/clientlog\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/weapi/clientlog\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/eapi/feedback\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/weapi/feedback\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/wapi/feedback\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/neapi/feedback\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/api/clientlog\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/wapi/feedback\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/\tFALSE\t1708199702\t__csrf\tf211ecc3c9739aa263df26cf74857bff\r\n.music.163.com\tTRUE\t/\tFALSE\t3854387339\tMUSIC_A\tbf8bfeabb1aa84f9c8c3906c04a04fb864322804c83f5d607e91a04eae463c9436bd1a17ec353cf7ce90fd988fc0a5bf5c19c49be574dd4e993166e004087dd3cb374247a789757d203b63080f8ceda8f4bf066e6fe094b68be4803e9b31b77d807e650dd04abd3fb8130b7ae43fcc5b\r\n.music.163.com\tTRUE\t/openapi/clientlog\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/weapi/clientlog\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/wapi/clientlog\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/api/feedback\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736\r\n.music.163.com\tTRUE\t/eapi/clientlog\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/api/feedback\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/openapi/clientlog\tFALSE\t3854387339\tMUSIC_R_T\t0\r\n.music.163.com\tTRUE\t/neapi/feedback\tFALSE\t3854387339\tMUSIC_A_T\t1699405917736","header":{"cache-control":"no-store","content-encoding":"gzip","content-type":"application/json;charset=UTF-8","date":"Sat, 03 Feb 2024 11:52:48 GMT","expires":"Thu, 01 Jan 1970 00:00:00 GMT","gw-thread":"717436","gw-time":"1706961168300","mconfig-bucket":"999999","server":"nginx","set-cookie":"MUSIC_A_T=1699405917736; Max-Age=2147483647; Expires=Thu, 21 Feb 2092 15:06:55 GMT; Path=/neapi/feedback; Domain=.music.163.com","vary":"Accept-Encoding","x-from-src":"182.101.221.111","x-traceid":"0000018d6ed067a61e9c0aaba43ccb36","x-via":"MusicServer"},"result":"{\"code\":200,\"userId\":8952478924,\"createTime\":1699405917736}","resultType":0}

      if (result as http.HttpResponse){
        let response = result as http.HttpResponse;
        response.header

      }
      return result
    }

  }


}

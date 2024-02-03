import cryptoFramework from '@ohos.security.cryptoFramework';
import util from '@ohos.util';
import buffer from '@ohos.buffer';


const iv = buffer.from('0102030405060708');
const presetKey = buffer.from('0CoJUm6Qyw8W8jud');
const linuxapiKey = buffer.from('rFgB&h#%2?^eDg:Q');
const base62 = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
const publicKey = buffer.from('MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB');
const eapiKey = buffer.from('e82ckenh8dichen8')



export class crypto{

  public static async aes(data: buffer.Buffer, mode: string, key: buffer.Buffer, iv: buffer.Buffer): Promise<buffer.Buffer>{
    // 创建AES128密钥生成器
    let symKeyGenerator:cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    // 创建初始化向量IV参数
    let ivParam: cryptoFramework.IvParamsSpec = {iv: {data: new Uint8Array(iv.buffer)},algName: 'IvParamsSpec'}
    // 创建加密器
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|' + mode.toUpperCase());
    // 获取密钥
    let symKey: cryptoFramework.SymKey  = await symKeyGenerator.convertKey({data: new Uint8Array(key.buffer)});
    // 初始化加密器为加密模式
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE,symKey,ivParam);
    // 获取最后加密数据
    return buffer.from((await cipher.doFinal({data: new Uint8Array(data.buffer)})).data);
  }

  public static async rsa(data: buffer.Buffer, key: buffer.Buffer): Promise<buffer.Buffer>{
    data = buffer.concat([buffer.alloc(128 - data.length), data]);
    let keyU8A = new util.Base64Helper().decodeSync(new Uint8Array(key.buffer));
    // 创建加密器
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('RSA1024|NoPadding');
    // 创建RSA密钥生成器
    let asyKeyGenerator:cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    let keyPair: cryptoFramework.KeyPair = await asyKeyGenerator.convertKey({data: keyU8A},null);
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null);
    return buffer.from((await cipher.doFinal({data: new Uint8Array(data.buffer)})).data);
  }


  public static async weapi(data: object = {}): Promise<object>{
    // data['csrf_token'] = "d3652ced0fb8959ee281aeaf49b417be";
    const text: buffer.Buffer = buffer.from(JSON.stringify(data));
    // let secretKey: buffer.Buffer = buffer.from('XHWEgn5poWYwDvYT');
    let secretKey: buffer.Buffer = (await this.randomBytes(16));
    let temp = buffer.from((await this.aes(text,'cbc',presetKey,iv)).toString('base64'));
    let encSecKeyValue = await this.rsa(this.bufferReverse(secretKey), publicKey);
    let paramsValue = (await this.aes(temp,'cbc',secretKey,iv)).toString('base64');
    return {
      params: paramsValue ,
      encSecKey: encSecKeyValue.toString('hex'),
    }
  }

  public static async linuxapi(data: object = {}) : Promise<object>{
    return {};
  }
  public static async eapi(url: string,data: object = {}) : Promise<object>{
    return {};
  }

  public static bufferReverse(data: buffer.Buffer){
    return buffer.from(new Uint8Array(data.buffer).reverse())
  }

  /**
   * 将字符串转换为Uint8Array
   * @param {string} str - 要转换的字符串
   * @returns {Uint8Array} - 转换后的Uint8Array
   */
  public static strToUint8Array(str:string): Uint8Array {
    return new util.TextEncoder().encodeInto(str);
  }

  public static async randomBytes(size: number): Promise<buffer.Buffer>{
    let data = buffer.from((await cryptoFramework.createRandom().generateRandom(size)).data);
    let u8a = new Uint8Array(data.buffer).map((n) => base62.charAt(n % 62).charCodeAt(0))
    return buffer.from(u8a);
  }

  public static async decrypt (data: buffer.Buffer) : Promise<buffer.Buffer>{
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|ECB');
    let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    let symKey:cryptoFramework.SymKey = await symKeyGenerator.convertKey({data: new Uint8Array(eapiKey.buffer)})
    await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE,symKey,null);
    return buffer.from((await cipher.doFinal({data: new Uint8Array(data.buffer)})).data);
  }

}
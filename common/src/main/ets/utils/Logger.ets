import hilog from '@ohos.hilog';

let domain: number = 0x7777;
let tag: string = 'Listen4';

export class Logger {


  static debug(arg: string) {
    hilog.debug(domain, tag, arg);
  }

  static debugWithTag(newTag: string , arg: string) {
    hilog.debug(domain, newTag, arg);
  }

  static info(arg: string) {
    hilog.info(domain, tag, arg);
  }
  static infoWithTag(newTag: string , arg: string) {
    hilog.info(domain, newTag, arg);
  }

  static warn(arg: string) {
    hilog.warn(domain, tag, arg);
  }

  static warnWithTag(newTag: string , arg: string) {
    hilog.warn(domain, newTag, arg);
  }

  static error(arg: string) {
    hilog.error(domain, tag, arg);
  }

  static errorWithTag(newTag: string , arg: string) {
    hilog.error(domain, newTag, arg);
  }

  static fatal(arg: string) {
    hilog.fatal(domain, tag, arg);
  }

  static fatalWithTag(newTag: string , arg: string) {
    hilog.fatal(domain, newTag, arg);
  }


}

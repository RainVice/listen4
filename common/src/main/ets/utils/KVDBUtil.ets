import distributedKVStore from '@ohos.data.distributedKVStore';

export class KVDBUtil {
  private context: Context;
  private bundleName: string;
  private KVStore: distributedKVStore.SingleKVStore;

  constructor(context: Context, storeId: string, bundleName: string) {
    this.context = context;
    this.bundleName = bundleName;
    distributedKVStore.createKVManager({ context: this.context, bundleName: this.bundleName })
      .getKVStore<distributedKVStore.SingleKVStore>(storeId, {
        securityLevel: distributedKVStore.SecurityLevel.S1,
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION
      }).then(val => this.KVStore = val)
  }


  async put(key: string, value: Uint8Array | string | number | boolean) {
    await this.KVStore.put(key, value);
  }


  async get(key: string) : Promise<boolean | string | number | Uint8Array>{
    return await this.KVStore.get(key);
  }

  async delete(key: string) {
    await this.KVStore.delete(key);
  }

  async has(key: string) : Promise<boolean> {
    return new Promise<boolean>((res) => {
      this.get(key).then((data) => {
        res(data ? true : false)
      }).catch((err) => {
        res(false)
      })
    });
  }

}
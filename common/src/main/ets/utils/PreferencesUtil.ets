import dataPreferences from '@ohos.data.preferences';

export class PreferencesUtil {
  name: string;
  private context: Context;
  private preferences: dataPreferences.Preferences;

  constructor(context: Context, name: string) {
    this.context = context;
    this.name = name;
  }

  async get(key: string, defValue: dataPreferences.ValueType): Promise<dataPreferences.ValueType> {
    await this.hasPreferences();
    return await this.preferences.get(key, defValue);
  }

  async put(key: string, value: dataPreferences.ValueType): Promise<void> {
    await this.hasPreferences();
    return await this.preferences.put(key, value);
  }

  async has(key: string): Promise<boolean> {
    await this.hasPreferences();
    return await this.preferences.has(key);
  }

  async delete(key: string): Promise<void> {
    await this.hasPreferences();
    return await this.preferences.delete(key);
  }

  async getAll(): Promise<Object> {
    await this.hasPreferences();
    return await this.preferences.getAll();
  }

  async clear(): Promise<void> {
    await this.hasPreferences();
    return await this.preferences.clear();
  }

  async flush(): Promise<void> {
    await this.hasPreferences();
    return await this.preferences.flush();
  }

  // 判断有没有preferences
  private async hasPreferences(): Promise<boolean> {
    if (this.preferences) {
      return true;
    }
    this.preferences = await dataPreferences.getPreferences(this.context, this.name);
    return false;
  }



}
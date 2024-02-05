export class ListAdapter<T> implements IDataSource {
  private datas: T[];
  private listeners: DataChangeListener[] = [];

  constructor(datas: T[]) {
    this.datas = datas;
  }


  totalCount(): number {
    return this.datas.length;
  }

  getData(index: number): T {
    return this.datas[index];
  }


  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }


  notifyDataReload(t: T[] = null): void {
    if (t) this.datas = t;
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}
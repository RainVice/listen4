
export class BottomNavigationInfo {
  index: number;
  img: Resource;
  color: Resource;
  selectColor: Resource;
  title: Resource;
}


const bottomInfo: BottomNavigationInfo[] = [

  {

    index: 0,
    img: $r('app.media.ic_music'),
    color: $r('app.color.bottom_navigation_color'),
    selectColor: $r('app.color.bottom_navigation_color_selected'),
    title: $r('app.string.bottom_navigation_music')

  },

  {

    index: 1,
    img: $r("app.media.ic_love"),
    color: $r('app.color.bottom_navigation_color'),
    selectColor: $r('app.color.bottom_navigation_color_selected'),
    title: $r('app.string.bottom_navigation_love')

  }

]

export {bottomInfo}
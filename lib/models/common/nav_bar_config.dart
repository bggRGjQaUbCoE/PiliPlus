import 'package:flutter/material.dart';

// enum NavigationBarType {
//   home(
//     '首页',
//     Icon(Icons.home_outlined, size: 23),
//     Icon(Icons.home, size: 21),
//   ),
//   dynamics(
//     '动态',
//     Icon(Icons.motion_photos_on_outlined, size: 21),
//     Icon(Icons.motion_photos_on, size: 21),
//   ),
//   media(
//     '媒体库',
//     Icon(Icons.video_collection_outlined, size: 21),
//     Icon(Icons.video_collection, size: 21),
//   );

//   final Icon icon;
//   final Icon selectIcon;
//   final String label;

//   const NavigationBarType(this.label, this.icon, this.selectIcon);
// }

// TODO enum
List defaultNavigationBars = [
  {
    'id': 0,
    'icon': const Icon(
      Icons.home_outlined,
      size: 23,
    ),
    'selectIcon': const Icon(
      Icons.home,
      size: 23,
    ),
    'label': "首页",
    'count': 0,
  },
  {
    'id': 1,
    'icon': const Icon(
      Icons.motion_photos_on_outlined,
      size: 21,
    ),
    'selectIcon': const Icon(
      Icons.motion_photos_on,
      size: 21,
    ),
    'label': "动态",
    'count': 0,
  },
  {
    'id': 2,
    'icon': const Icon(
      Icons.video_collection_outlined,
      size: 21,
    ),
    'selectIcon': const Icon(
      Icons.video_collection,
      size: 21,
    ),
    'label': "媒体库",
    'count': 0,
  }
];

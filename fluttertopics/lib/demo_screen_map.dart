import 'package:flutter/material.dart';
import 'package:fluttertopics/topics/widgetsTopics/CustomScrollView/CustomScrollViewDemoScreen.dart';
import 'package:fluttertopics/topics/widgetsTopics/TabBar/tab_bar_demo.dart';

final Map<String, WidgetBuilder> demoScreens = {
  'TabBarDemo': (_) => TabBarDemo(),
  'CustomScrollViewDemoScreen': (_) => CustomScrollViewDemoScreen(),
  
};
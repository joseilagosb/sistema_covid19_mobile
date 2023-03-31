import 'package:flutter/material.dart';

enum TabItem { mapViewer, travelAssistant, collaborationPanel }

class TabItemData {
  const TabItemData({required this.title, required this.icon});
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.mapViewer: TabItemData(
      title: "Recorre",
      icon: Icons.map,
    ),
    TabItem.travelAssistant: TabItemData(
      title: "Planifica",
      icon: Icons.travel_explore,
    ),
    TabItem.collaborationPanel: TabItemData(
      title: "Colabora",
      icon: Icons.people,
    ),
  };
}

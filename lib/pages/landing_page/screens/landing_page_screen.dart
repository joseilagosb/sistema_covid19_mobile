import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vacapp_mobile/common_widgets/drawer_menu.dart';

import 'package:vacapp_mobile/pages/landing_page/bloc/landing_page_bloc.dart';
import 'package:vacapp_mobile/pages/landing_page/models/tab_item.dart';
import 'package:vacapp_mobile/pages/map_view/screens/map_view_screen.dart';
import 'package:vacapp_mobile/pages/travel_scheduler/travel_scheduler_splash_page.dart';
import 'package:vacapp_mobile/pages/send_feedback/send_feedback_splash_page.dart';

Map<TabItem, Widget Function(BuildContext, GlobalKey<ScaffoldState>)> get _widgetBuilders {
  return {
    TabItem.mapViewer: (_, scaffoldKey) => MapViewScreen.create(scaffoldKey),
    TabItem.travelAssistant: (_, __) => const ScheduleTravelPage(),
    TabItem.collaborationPanel: (_, __) => const SendFeedbackPage(),
  };
}

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  static Widget create() {
    return BlocProvider<LandingPageBloc>(
      create: (_) => LandingPageBloc(),
      child: const LandingPageScreen(),
    );
  }

  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    LandingPageBloc bloc = BlocProvider.of<LandingPageBloc>(context);

    return BlocBuilder<LandingPageBloc, LandingPageState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          drawer: const DrawerMenu(),
          endDrawerEnableOpenDragGesture: false,
          body: Builder(
            builder: (context) => _widgetBuilders[state.currentTab]!(context, scaffoldKey),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              _buildItem(TabItem.mapViewer, state.currentTab),
              _buildItem(TabItem.travelAssistant, state.currentTab),
              _buildItem(TabItem.collaborationPanel, state.currentTab),
            ],
            currentIndex: state.currentTab.index,
            onTap: (index) => bloc.add(SelectTab(selectedTab: TabItem.values[index])),
            backgroundColor: Colors.orange,
            selectedItemColor: Colors.black,
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem, TabItem currentTab) {
    final itemData = TabItemData.allTabs[tabItem]!;
    final size = currentTab == tabItem ? 28.0 : 24.0;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        size: size,
      ),
      label: itemData.title,
    );
  }
}

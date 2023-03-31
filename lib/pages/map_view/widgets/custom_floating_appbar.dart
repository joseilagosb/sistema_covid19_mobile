import 'package:flutter/material.dart';
import 'package:vacapp_mobile/pages/search/search_delegate.dart';

class CustomFloatingAppbar extends StatelessWidget {
  const CustomFloatingAppbar({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15,
      left: 15,
      right: 15,
      child: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AppBar(
            title: const Text('VACAPP 🐮'),
            centerTitle: true,
            backgroundColor: Colors.orangeAccent,
            leading: IconButton(
              onPressed: () => scaffoldKey.currentState!.openDrawer(),
              icon: const Icon(Icons.menu),
            ),
            actions: [
              IconButton(
                onPressed: () => _navigateToSearchScreen(context),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSearchScreen(BuildContext context) {
    showSearch(
      context: context,
      delegate: SearchDelegateService(),
    );
  }
}

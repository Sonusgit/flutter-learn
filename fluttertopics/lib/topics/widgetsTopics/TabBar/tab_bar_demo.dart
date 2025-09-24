import 'package:flutter/material.dart';

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // total tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TabBar Demo"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Home"),
              Tab(text: "Profile"),
              Tab(text: "Settings"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("Home Content")),
            Center(child: Text("Profile Content")),
            Center(child: Text("Settings Content")),
          ],
        ),
      ),
    );
  }
}

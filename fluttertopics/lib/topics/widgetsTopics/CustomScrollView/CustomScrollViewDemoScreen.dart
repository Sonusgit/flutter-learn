import 'package:flutter/material.dart';

class CustomScrollViewDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CustomScrollView Demo")),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(title: Text("Featured Section")),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              color: Colors.greenAccent,
              child: Center(child: Text("Static Header")),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(title: Text("List Item #$index")),
              childCount: 15,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                height: 300,
                color: Colors.blue[100 * ((index % 8) + 1)],
                child: Center(child: Text("Grid Item #$index")),
              ),
              childCount: 8,
            ),
          ),
        ],
      ),
    );
  }
}

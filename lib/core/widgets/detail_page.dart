import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.title,
    required this.children,
    this.actions = const [],
  });
  final String title;
  final List<Widget> children;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(padding: const EdgeInsets.all(20), children: children),
    bottomNavigationBar: actions.isEmpty
        ? null
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: actions
                    .map(
                      (a) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: a,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
  );
}

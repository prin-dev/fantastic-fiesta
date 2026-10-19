import 'package:flutter/widgets.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final PreferredSizeWidget? bottomAppBar;
  final Widget? floatingActionButton;
  final Color backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomAppBar,
    this.floatingActionButton,
    this.backgroundColor = const Color(0xFFF3F5F7),
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: Stack(
          children: [
            Column(
              children: [
                ?appBar,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: (bottomAppBar?.preferredSize.height ?? 0),
                    ),
                    child: body,
                  ),
                ),
              ],
            ),
            if (floatingActionButton != null)
              Positioned(right: 16, bottom: 16, child: floatingActionButton!),
            if (bottomAppBar != null)
              Positioned(left: 0, right: 0, bottom: 0, child: bottomAppBar!),
          ],
        ),
      ),
    );
  }
}

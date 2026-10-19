import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:hugeicons/hugeicons.dart';

class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? actionsPadding;
  final ShapeBorder? shape;
  final double height;

  const WidgetAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.foregroundColor,
    this.actionsPadding,
    this.shape,
    this.height = 72.0,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    final effectiveLeading =
        leading ??
        (canPop
            ? Semantics(
                button: true,
                label: 'Back',
                child: FossButton.icon(
                  semanticLabel: 'Back',
                  variant: .ghost,
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  icon: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowLeft01,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              )
            : null);

    BoxDecoration? boxDecoration;

    if (shape is Border) {
      boxDecoration = BoxDecoration(border: shape as Border);
    }

    final activeForegroundColor = foregroundColor ?? const Color(0xFFFFFFFF);

    return ColoredBox(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: height,
          decoration: boxDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: activeForegroundColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
            child: Row(
              spacing: context.fossTheme.spacing.unit * 2,
              children: [
                if (effectiveLeading != null) ...[effectiveLeading],
                FractionallySizedBox(
                  heightFactor: 0.5,
                  child: FossSeparator(orientation: .vertical),
                ),
                SizedBox(width: context.fossTheme.spacing.unit),
                Expanded(child: title),
                if (actions != null)
                  Padding(
                    padding: actionsPadding ?? EdgeInsets.zero,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

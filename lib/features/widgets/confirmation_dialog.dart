import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,

  required String message,
  String? description,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDangerous = false,
}) async {
  final result = await showFossAlertDialog<bool>(
    presentation: .centered,
    context: context,
    builder: (BuildContext context) {
      return FossAlertDialog(
        footerVariant: .filled,
        title: Text(title),
        content: Text(message),
        description: description != null ? Text(description) : null,
        actions: [
          FossButton(
            variant: .ghost,
            onPressed: () => Navigator.of(context).pop(false),

            child: Text(cancelText),
          ),
          FossButton(
            variant: .destructive,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

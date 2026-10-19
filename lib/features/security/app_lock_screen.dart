import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:movo/core/security/app_lock_manager.dart';
import 'package:provider/provider.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FossButton(
        variant: .primary,
        onPressed: () async {
          final authenticated = await context.read<AppLockManager>().unlock();
          if (!authenticated && context.mounted) {
            showFossToast(
              context,
              const FossToast(
                variant: FossToastVariant.error,
                title: Text('Authentication was not completed.'),
              ),
            );
          }
        },
        child: const Text('Unlock'),
      ),
    );
  }
}

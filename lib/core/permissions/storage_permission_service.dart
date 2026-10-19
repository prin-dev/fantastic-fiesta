import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:permission_handler/permission_handler.dart';

class StoragePermissionService {
  Future<bool> ensureStoragePermission(BuildContext context) async {
    if (!Platform.isAndroid) {
      return true;
    }

    final permission = await _storagePermission();
    if (await permission.isGranted) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }

    final shouldRequest = await showFossAlertDialog<bool>(
      context: context,
      presentation: .centered,
      builder: (context) => FossAlertDialog(
        footerVariant: .filled,
        title: const Text('Allow Storage Access'),
        content: const Text(
          'Movo needs storage access to save and restore backups and export transactions. '
          'Allow access when Android asks for permission.',
        ),
        actions: [
          FossButton(
            variant: .ghost,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not Now'),
          ),
          FossButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    if (shouldRequest != true || !context.mounted) {
      return false;
    }

    final status = await permission.request();
    if (status.isGranted) {
      return true;
    }

    if (!status.isPermanentlyDenied || !context.mounted) {
      return false;
    }

    final openSettings = await showFossAlertDialog<bool>(
      context: context,
      presentation: .centered,
      builder: (context) => FossAlertDialog(
        footerVariant: .filled,
        title: const Text('Storage Permission Required'),
        content: const Text(
          'Storage access was denied. Enable it in Android settings to save '
          'and restore backups and exports.',
        ),
        actions: [
          FossButton(
            variant: .ghost,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not Now'),
          ),
          FossButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (openSettings == true) {
      await openAppSettings();
    }

    return false;
  }

  Future<Permission> _storagePermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33
        ? Permission.manageExternalStorage
        : Permission.storage;
  }
}

class StoragePermissionGate extends StatefulWidget {
  const StoragePermissionGate({super.key, required this.child});

  final Widget child;

  @override
  State<StoragePermissionGate> createState() => _StoragePermissionGateState();
}

class _StoragePermissionGateState extends State<StoragePermissionGate> {
  final StoragePermissionService _permissionService =
      StoragePermissionService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _permissionService.ensureStoragePermission(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

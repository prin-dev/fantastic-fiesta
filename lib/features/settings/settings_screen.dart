import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:movo/app/dependencies/app_dependencies.dart';
import 'package:movo/app/settings/settings_service.dart';
import 'package:movo/core/backup/backup_service.dart';
import 'package:movo/core/components/app_scaffold.dart';
import 'package:movo/core/components/components.dart';
import 'package:movo/core/constants/app_config.dart';
import 'package:movo/core/export/excel_exporter.dart';
import 'package:movo/core/permissions/storage_permission_service.dart';
import 'package:movo/core/theme/movo_theme.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/order_table.dart';
import 'package:movo/data/repositories/order_repository.dart';
import 'package:movo/features/widgets/confirmation_dialog.dart';
import 'package:movo/utils/navigator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService _settingsService;
  late BackupDatabaseService _backupService;
  late ExcelExportService _excelService;
  late OrdersRepository _ordersRepository;
  late StoragePermissionService _storagePermissionService;

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopOwnerController = TextEditingController();

  bool _initialized = false;

  PaymentMethod _defaultPaymentMethod = PaymentMethod.cash;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _settingsService = context.settingsService;
      _backupService = context.backupDatabaseService;
      _excelService = context.excelExportService;
      _ordersRepository = context.ordersRepository;
      _storagePermissionService = context.storagePermissionService;
      _shopNameController.text = _settingsService.getShopName();
      _shopOwnerController.text = _settingsService.getShopOwner();
      _defaultPaymentMethod = _settingsService.getDefaultPaymentMethod();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _shopNameController.dispose();
    _shopOwnerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: BrandTopBar(title: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Information Section
            _buildSectionHeader('Shop Information'),
            _buildShopInformationSection(),

            const SizedBox(height: 16.0),

            // Application Settings Section
            _buildSectionHeader('Application Settings'),
            _buildApplicationSettingsSection(),

            const SizedBox(height: 16.0),

            // Data Management Section
            _buildSectionHeader('Data Management'),
            _buildDataManagementSection(),

            const SizedBox(height: 16.0),

            _buildSectionHeader('About'),
            _buildAboutSection(),

            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
      child: BrandText.subtitle(
        title,
        color: context.fossTheme.colors.foreground,
      ),
    );
  }

  Widget _buildShopInformationSection() {
    final tokens = context.fossTheme;
    final settingsService = context.settingsService;
    final shopName = settingsService.getShopName();
    final shopOwner = settingsService.getShopOwner();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      constraints: BoxConstraints(minHeight: 100),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tokens.colors.card,
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: tokens.spacing.unit * 4,
        children: [
          Expanded(
            child: Column(
              spacing: tokens.spacing.unit * 2,
              crossAxisAlignment: .start,
              children: [
                // BrandText.body('Shop information features are not yet implemented'),
                Row(
                  spacing: tokens.spacing.unit * 2,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedMenuRestaurant,
                      size: tokens.spacing.unit * 6,
                      color: tokens.colors.primary,
                    ),
                    BrandText.heading(shopName),
                  ],
                ),
                FossSeparator(decorative: true),
                Row(
                  spacing: tokens.spacing.unit * 2,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedUser02,
                      size: tokens.spacing.unit * 4,
                      color: tokens.colors.primary,
                    ),
                    BrandText.body(shopOwner),
                  ],
                ),
              ],
            ),
          ),
          FossButton(
            variant: .secondary,
            onPressed: () {
              showFossDialog(
                context: context,
                builder: (context) {
                  return FossDialog(
                    presentation: .centered,
                    footerVariant: .filled,
                    title: BrandText.title('Change Shop Information'),
                    content: Padding(
                      padding: EdgeInsets.all(tokens.spacing.unit * 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FossTextField(
                            label: 'Shop\'s Name',
                            controller: _shopNameController,
                          ),
                          const SizedBox(height: 16.0),
                          FossTextField(
                            label: 'Owner\'s Name',
                            controller: _shopOwnerController,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      FossButton(
                        variant: .ghost,
                        onPressed: () => Navigator.pop(context),
                        child: const BrandText.label('Cancel'),
                      ),
                      FossButton(
                        onPressed: () async {
                          final newShopName = _shopNameController.text.trim();
                          final newShopOwner = _shopOwnerController.text.trim();
                          if (newShopName.isNotEmpty) {
                            await settingsService.setShopName(newShopName);
                          }
                          if (newShopOwner.isNotEmpty) {
                            await settingsService.setShopOwner(newShopOwner);
                          }
                          if (mounted) {
                            Navigator.pop(context);
                          }
                          setState(() {
                            // Update the UI with the new shop information
                          });
                        },
                        child: BrandText.label(
                          'Save',
                          color: tokens.colors.primaryForeground,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: FossButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                context.fossTheme.colors.card,
              ),
              side: BorderSide(color: context.fossTheme.colors.border),
              borderRadius: context.fossTheme.radii.md,
            ),
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedEdit04,
              size: tokens.spacing.unit * 4,
              color: context.fossTheme.colors.primary,
            ),
            child: BrandText.body(
              'Change',
              color: context.fossTheme.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationSettingsSection() {
    final tokens = context.fossTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tokens.colors.card,
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: tokens.spacing.unit * 2,
        children: [
          const BrandText.body('Default Payment Method'),
          FossSelect<PaymentMethod>(
            value: _defaultPaymentMethod,
            items: PaymentMethod.values.map((method) {
              return FossSelectItem<PaymentMethod>(
                value: method,
                label: method.name.toUpperCase(),
              );
            }).toList(),
            onChanged: (PaymentMethod? newValue) async {
              if (newValue != null) {
                await _settingsService.setDefaultPaymentMethod(newValue);
                setState(() {
                  _defaultPaymentMethod = newValue;
                });
                if (mounted) {
                  showFossToast(
                    context,
                    FossToast(
                      title: BrandText.label('Default payment method updated'),
                      style: FossToastStyle(
                        backgroundColor: tokens.colors.success,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSection() {
    final tokens = context.fossTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tokens.colors.card,
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Column(
        children: [
          _buildDataManagementButton(
            icon: HugeIcons.strokeRoundedMenuRestaurant,
            title: 'Manage Menu',
            onTap: () {
              context.navigateToMenu();
            },
          ),
          const SizedBox(height: 12.0),
          _buildDataManagementButton(
            icon: HugeIcons.strokeRoundedFileDownload,
            title: 'Export Transactions',
            onTap: _handleExport,
          ),
          const SizedBox(height: 12.0),
          _buildDataManagementButton(
            icon: HugeIcons.strokeRoundedDatabaseBackup,
            title: 'Backup Database',
            onTap: _handleBackup,
          ),
          const SizedBox(height: 12.0),
          _buildDataManagementButton(
            icon: HugeIcons.strokeRoundedDatabaseRestore,
            title: 'Restore Database',
            onTap: () => _handleRestore(context),
            isDangerous: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementButton({
    required List<List<dynamic>> icon,
    required String title,
    required VoidCallback onTap,
    bool isDangerous = false,
  }) {
    final tokens = context.fossTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: tokens.colors.background,
          borderRadius: BorderRadius.circular(tokens.radii.sm),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isDangerous
                    ? tokens.colors.destructiveLight
                    : tokens.colors.primaryLight,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: HugeIcon(
                icon: icon,
                color: isDangerous
                    ? tokens.colors.destructiveLightForeground
                    : tokens.colors.primaryLightForeground,
                size: 24,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: BrandText.body(
                title,
                color: isDangerous
                    ? tokens.colors.destructiveLightForeground
                    : tokens.colors.foreground,
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedChevronRight,
              color: tokens.colors.foreground,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    final tokens = context.fossTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tokens.colors.card,
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Movo',
            style: tokens.typography.lg.copyWith(
              fontWeight: FontWeight.w600,
              color: tokens.colors.foreground,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Alpha Version $appVersion',
            style: tokens.typography.sm.copyWith(
              color: tokens.colors.foreground.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () async {
              final url = Uri.parse('https://bezieratelier.in');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                if (mounted) {
                  showFossToast(
                    context,
                    FossToast(
                      title: BrandText.label('Could not launch URL'),
                      style: FossToastStyle(
                        backgroundColor: tokens.colors.destructive,
                      ),
                    ),
                  );
                }
              }
            },
            child: RichText(
              text: TextSpan(
                text: 'Developed by ',
                style: tokens.typography.base.copyWith(
                  color: tokens.colors.foreground.withValues(alpha: 0.6),
                ),
                children: [
                  TextSpan(
                    text: 'Bézier Atelier',
                    style: tokens.typography.base.copyWith(
                      color: tokens.colors.destructiveLightForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport() async {
    if (!await _storagePermissionService.ensureStoragePermission(context)) {
      return;
    }

    final tokens = context.fossTheme;
    // Show loading dialog
    if (!mounted) return;
    showFossDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: FossCard(
          title: BrandText.title('Exporting Transactions'),
          content: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FossSpinner(),
                SizedBox(height: 16),
                BrandText.body(
                  'We are exporting your paid transactions. This may take a few moments.',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Fetch all paid orders
      final allOrders = await _ordersRepository.watchCompletedOrders().first;

      if (allOrders.isEmpty) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          showFossToast(
            context,
            FossToast(
              title: Text(
                'No paid orders to export',
                style: tokens.typography.sm.copyWith(
                  color: tokens.colors.foreground.withValues(alpha: 0.8),
                ),
              ),
              style: FossToastStyle(backgroundColor: tokens.colors.warning),
            ),
          );
        }
        return;
      }

      if (kDebugMode) {
        print('Fetched ${allOrders.length} paid orders for export');
      }

      // Fetch order items for each order
      Map<String, List<OrderItemsTableData>> orderItemsMap = {};

      for (final order in allOrders) {
        final items = await _ordersRepository.getOrderItemsByOrderId(order.id);
        orderItemsMap[order.id] = items;
      }

      // Generate CSV file
      final filePath = await _excelService.exportPaidOrders(
        allOrders,
        orderItemsMap,
      );

      // Share the file
      await _excelService.shareExport(filePath);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        showFossToast(
          context,
          FossToast(
            title: BrandText.subtitle('Export Successful'),
            description: BrandText.body(
              'File has been saved on your Downloads folder.',
            ),
            style: FossToastStyle(backgroundColor: tokens.colors.background),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        _showDialog(
          'Export Failed',
          'Could not export transactions. Please try again.\n\nError: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _handleBackup() async {
    if (!await _storagePermissionService.ensureStoragePermission(context)) {
      return;
    }

    // Show loading dialog
    if (!mounted) return;
    showFossDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: FossCard(
          title: BrandText.subtitle('Creating Backup'),
          content: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FossSpinner(),
                SizedBox(height: 16),
                BrandText.body(
                  'We are creating a backup of your database. This may take a few moments.',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Create backup
      final backupPath = await _backupService.createBackup();

      // Share the backup file
      await _backupService.shareBackup(backupPath);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        showFossToast(
          context,
          FossToast(
            title: BrandText.title('Backup Successful'),
            description: BrandText.body(
              'Database backup has been saved on Downloads folder.',
            ),
            style: FossToastStyle(
              backgroundColor: context.fossTheme.colors.success,
              titleStyle: context.fossTheme.typography.base.copyWith(
                color: context.fossTheme.colors.foreground,
              ),
              descriptionStyle: context.fossTheme.typography.sm.copyWith(
                color: context.fossTheme.colors.foreground.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        _showDialog(
          'Backup Failed',
          'Could not create backup. Please try again.\n\nError: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _handleRestore(BuildContext context) async {
    if (!await _storagePermissionService.ensureStoragePermission(context)) {
      return;
    }

    // Show file picker
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (kDebugMode) {
      print('File picker result: ${result.first.extension}');
    }

    if (result.isEmpty) {
      return; // User cancelled
    }

    if (result.single.extension != 'db') {
      _showDialog(
        'Invalid File',
        'Please select a valid database backup file with .db extension.',
      );
      return;
    }

    final filePath = result.single.path;
    if (filePath == null) {
      _showDialog(
        'Invalid File',
        'Could not access the selected file. Please try again.',
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Restore Database?',
      message: 'This will replace all current data with the backup. This action cannot be undone. The app will restart after restore.',
      confirmText: 'Restore',
      cancelText: 'Cancel',
      isDangerous: true,
    );

    if (!confirmed || !mounted) {
      return;
    }

    // Show loading dialog
    showFossDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: FossCard(
          title: BrandText.title('Restoring Database'),
          content: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FossSpinner(),
                SizedBox(height: 16),
                BrandText.body(
                  'Restoring your database from the backup. This may take a few moments.',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Restore the database
      final success = await _backupService.restoreBackup(filePath);

      if (success && mounted) {
        Navigator.pop(context); // Close loading dialog

        _showDialog(
          'App Restarting',
          'The app will restart in 3 seconds. Please wait...',
        );
        Future.delayed(const Duration(seconds: 3), () {
          Restart.restartApp();
        }).then(
          (value) => {}, // Show success message
          // showFossToast(
          //   context,
          //   FossToast(
          //     title: BrandText.title('Database Restored'),
          //     description: BrandText.body(
          //       'Database restored successfully. Please restart the app.',
          //     ),
          //     style: FossToastStyle(
          //       backgroundColor: context.fossTheme.colors.success,
          //       titleStyle: context.fossTheme.typography.base.copyWith(
          //         color: context.fossTheme.colors.foreground,
          //       ),
          //       descriptionStyle: context.fossTheme.typography.sm.copyWith(
          //         color: context.fossTheme.colors.foreground.withValues(
          //           alpha: 0.8,
          //         ),
          //       ),
          //     ),
          //     duration: Duration(seconds: 3),
          //   ),
          // ),
        );
      } else if (!success && mounted) {
        Navigator.pop(context); // Close loading dialog
        _showDialog(
          'Restore Failed',
          'The restore operation did not complete successfully. Please try again.',
        );
      } else if (mounted) {
        Navigator.pop(context); // Close loading dialog
        _showDialog(
          'Restore Failed',
          'The restore operation did not complete successfully. Please try again.',
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        _showDialog(
          'Restore Failed',
          'Could not restore database. Please ensure the backup file is valid.\n\nError: ${e.toString()}',
        );
      }
    }
  }

  void _showDialog(String title, String message) {
    showFossDialog(
      context: context,
      builder: (context) => FossAlertDialog(
        title: BrandText.title(title),
        content: BrandText.body(message),
        actions: [
          FossButton(
            variant: .ghost,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

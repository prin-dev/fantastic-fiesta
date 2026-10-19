import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:movo/app/dependencies/app_dependencies.dart';
import 'package:movo/core/components/app_scaffold.dart';
import 'package:movo/core/components/components.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/repositories/menu_repository.dart';
import 'package:movo/utils/navigator.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _initialized = false;
  late double bottomWidget;

  late final MenuRepository menuRepository;

  // Status filter state
  final ValueNotifier<String> _statusFilter = ValueNotifier<String>('all');

  Stream<List<MenuItemTableData>> _getSelectedStream(String status) {
    Stream<List<MenuItemTableData>> stream;
    switch (status) {
      case 'active':
        stream = menuRepository.watchActiveMenu();
      case 'inactive':
        stream = menuRepository.watchInactiveMenu();
      default:
        stream = menuRepository.watchAllMenu();
    }
    return stream;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      menuRepository = context.read<MenuRepository>();
      bottomWidget = MediaQuery.of(context).padding.bottom;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _statusFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return AppScaffold(
      appBar: BrandTopBar(title: 'Menu'),
      floatingActionButton: FossButton(
        size: .lg,
        semanticLabel: 'Add Menu Item',
        leading: HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          size: tokens.spacing.unit * 6,
          color: tokens.colors.primaryForeground,
        ),
        onPressed: () async {
          context.navigateToAddMenuItemScreen();
        },
        child: BrandText.title(
          'Add Menu Item',
          color: tokens.colors.primaryForeground,
        ),
      ),
      body: Column(
        crossAxisAlignment: .start,
        children: [
          // Status Filter Chips
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: tokens.spacing.unit * 2,
              horizontal: tokens.spacing.unit * 4,
            ),
            child: ValueListenableBuilder(
              valueListenable: _statusFilter,
              builder: (context, value, child) {
                return FossTabs(
                  onChanged: (selected) {
                    context.loggerService.info(
                      'Selected status filter: $value',
                    );
                    _statusFilter.value = selected;
                  },
                  value: value,
                  initialValue: value,
                  tabs: [
                    FossTab(value: 'all', label: 'All'),
                    FossTab(value: 'active', label: 'Active'),
                    FossTab(value: 'inactive', label: 'Inactive'),
                  ],
                );
              },
            ),
          ),

          // Orders List
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _statusFilter,
              builder: (context, status, _) {
                return StreamBuilder<List<MenuItemTableData>>(
                  stream: _getSelectedStream(status),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: FossSpinner());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading orders: ${snapshot.error}'),
                      );
                    }
                    final menuItems = snapshot.data ?? [];
                    if (menuItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: tokens.spacing.unit * 4,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedMenuSquare,
                              size: tokens.spacing.unit * 8,
                              color: tokens.colors.mutedForeground,
                            ),
                            BrandText.label(
                              'No menu items found.',
                              color: tokens.colors.mutedForeground,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(
                        left: tokens.spacing.unit * 4,
                        right: tokens.spacing.unit * 4,
                        bottom: tokens.spacing.unit * 18 + bottomWidget,
                      ),
                      itemCount: menuItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12.0),
                      itemBuilder: (context, index) {
                        return MenuItemCard.editable(
                          name: menuItems[index].name,
                          price: menuItems[index].prices.length == 1
                              ? '₹${menuItems[index].prices.first}'
                              : '₹${menuItems[index].prices.first}-₹${menuItems[index].prices.last}',
                          emoji: menuItems[index].icon,
                          active: menuItems[index].isActive,
                          onMenuStatusToggle: (p0) {
                            if (p0) {
                              menuRepository.activateMenuItem(
                                menuItems[index].id,
                              );
                            } else {
                              menuRepository.deactivateMenuItem(
                                menuItems[index].id,
                              );
                            }
                          },
                          onTap: () {
                            context.navigateToEditMenuItemScreen(
                              menuId: menuItems[index].id,
                              initialItemName: menuItems[index].name,
                              initialPrices: menuItems[index].prices,
                              initialIcon: menuItems[index].icon,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

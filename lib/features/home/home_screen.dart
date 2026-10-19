import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:movo/app/dependencies/app_dependencies.dart';
import 'package:movo/core/components/app_scaffold.dart';
import 'package:movo/core/components/components.dart';
import 'package:movo/core/theme/movo_theme.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/order_table.dart';
import 'package:movo/data/repositories/menu_repository.dart';
import 'package:movo/data/repositories/order_repository.dart';
import 'package:movo/features/cart/cart_controller.dart';
import 'package:movo/features/cart/cart_item.dart';
import 'package:movo/features/payment/widgets/payment_method_selection_sheet.dart';
import 'package:movo/features/widgets/confirmation_dialog.dart';
import 'package:movo/utils/constants.dart';
import 'package:movo/utils/formatter.dart';
import 'package:movo/utils/navigator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:badges/badges.dart' as badges;

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void openNavDialog(BuildContext context) {
    showFossDialog(
      context: context,
      presentation: .centered,
      builder: (BuildContext context) {
        return const GridNavDrawer();
      },
    );
  }

  Future<void> closeApp() async {
    await SystemNavigator.pop(); // Close the app
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    final spacingTokens = tokens.spacing;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, _) async {
        final confirmExit = await showConfirmationDialog(
          context: context,
          title: 'Exit App',
          message: 'Are you sure you want to exit the app?',
          isDangerous: true,
          confirmText: 'Exit',
          cancelText: 'Cancel',
        );
        if (confirmExit) {
          await closeApp();
        } else {
          if (kDebugMode) {
            print('Exit app cancelled by user.');
          }
          // return false; // Prevent the pop (exit)
        }
      },

      child: AppScaffold(
        floatingActionButton: Consumer<CartController>(
          builder: (context, cartController, child) {
            return (cartController.isCartEmpty)
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacingTokens.unit * 4,
                      vertical: spacingTokens.unit * 2,
                    ),
                    child: CartReviewButton(
                      itemCount: cartController.itemCount,
                      total: cartController.total,
                      onReview: () {
                        showFossDrawer<void>(
                          context: context,
                          barrierLabel: 'Cart Review',
                          builder: (BuildContext context) {
                            return PopScope(
                              canPop: false,
                              onPopInvokedWithResult: (didPop, result) {
                                if (didPop) return;

                                // Ensure only the drawer overlay itself gets closed safely
                                Navigator.of(context).pop();
                              },
                              child: CartReviewSheet(),
                            );
                          },
                        );
                        if (kDebugMode) {
                          print('Review cart tapped');
                          print(
                            'Cart items: ${cartController.cart.items.length}',
                          );
                          print(
                            'Cart items details: ${cartController.cart.items}',
                          );
                          print('Cart total: ${cartController.total}');
                        }
                      },
                    ),
                  );
          },
        ),
        appBar: BrandTopBar(
          title: 'Home',
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(tokens.radii.md),
            child: Image.asset(
              'assets/icon/icon.png',
              width: spacingTokens.unit * 12,
              height: spacingTokens.unit * 12,
            ),
          ),
          actions: [
            FossButton.icon(
              semanticLabel: "Open navigation menu",
              variant: .ghost,
              icon: SizedBox(
                width: tokens.spacing.unit * 12,
                height: tokens.spacing.unit * 12,
                child: Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedMenuSquare,
                    color: tokens.colors.primary,
                    size: tokens.spacing.unit * 7,
                  ),
                ),
              ),
              onPressed: () => openNavDialog(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: spacingTokens.unit * 4,
            vertical: spacingTokens.unit * 2,
          ).copyWith(bottom: spacingTokens.unit * 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: spacingTokens.unit * 2,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.colors.card,
                  borderRadius: BorderRadius.circular(tokens.radii.md),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacingTokens.unit * 2,
                    vertical: spacingTokens.unit * 2,
                  ),
                  child: Row(
                    spacing: spacingTokens.unit * 4,
                    children: [
                      ClipRRect(
                        borderRadius: .circular(tokens.radii.md),
                        child: Image.asset(
                          context.appAvatarService.getSelectedAvatarAssetPath(),
                          width: spacingTokens.unit * 14,
                          height: spacingTokens.unit * 14,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: spacingTokens.unit,
                          children: [
                            BrandText.title(
                              greetingUserMessages[Random().nextInt(
                                    greetingUserMessages.length,
                                  )]
                                  .replaceFirst(
                                    '{userName}',
                                    context.settingsService.getShopOwner(),
                                  ),
                              color: tokens.colors.foreground,
                            ),
                            BrandText.caption(
                              greetingMessages[Random().nextInt(
                                greetingMessages.length,
                              )],
                              // greetingMessages.last,
                              color: tokens.colors.foreground.withValues(
                                alpha: 0.6,
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      FossChip(
                        label: Column(
                          crossAxisAlignment: .start,
                          spacing: spacingTokens.unit * 0.5,
                          children: [
                            BrandText.label(
                              '${dayFromDateString(DateTime.now())},',
                              color: tokens.colors.accentLightForeground,
                            ),
                            Row(
                              children: [
                                BrandText.body(
                                  monthFromDateString(DateTime.now()),
                                  color: tokens.colors.accentLightForeground,
                                ),
                                BrandText.body(
                                  ' ${DateTime.now().day}',
                                  color: tokens.colors.accentLightForeground,
                                ),
                              ],
                            ),
                          ],
                        ),
                        style: FossChipStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            tokens.colors.accentLight,
                          ),
                          padding: spacingTokens.unit * 4,
                          minHeight: spacingTokens.unit * 14,
                        ),
                        // leading: HugeIcon(
                        //   icon: HugeIcons.strokeRoundedCalendar02,
                        //   size: tokens.spacing.unit * 6,
                        //   color: tokens.colors.foreground,
                        // ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BrandText.label('Pending Orders'),
                  FossButton(
                    semanticLabel: "View all pending orders",
                    trailing: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight02,
                      size: spacingTokens.unit * 6,
                    ),

                    onPressed: () {
                      context.navigateToOrder();
                    },
                    variant: .outline,
                    child: FossText.body('View All'),
                  ),
                ],
              ),
              const PedingOrdersList(),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  const BrandText.label('Menu Items'),
                  // Showing how many items are available in the menu, but this is commented out for now
                  // as the menu items are fetched asynchronously and we don't have the count here.
                  // FossText.caption(' • 20 Items'),
                  Opacity(
                    opacity: 0,
                    child: FossButton(
                      trailing: SizedBox(
                        width: tokens.spacing.unit * 6,
                        height: tokens.spacing.unit * 6,
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedFilterHorizontal,
                          ),
                        ),
                      ),
                      onPressed: () {},
                      semanticLabel: "Filter menu items",
                      variant: .ghost,
                      child: FossText.body('Filter'),
                    ),
                  ),
                ],
              ),
              const MenuCardGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class GridNavDrawer extends StatelessWidget {
  const GridNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return FossDialog(
      content: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.unit * 4,
          vertical: tokens.spacing.unit * 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: tokens.spacing.unit * 4,
          children: [
            const BrandText.subtitle('Navigations'),
            GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              shrinkWrap: true,
              children: [
                NavItem(
                  label: 'New Menu',
                  emoji: '🍔',
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
                  onTap: () {
                    context.navigateToMenu();
                  },
                ),
                NavItem(
                  label: 'Orders',
                  emoji: '🧾',
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedHistory),
                  onTap: () {
                    context.navigateToOrder();
                  },
                ),
                NavItem(
                  label: 'Settings',
                  emoji: '⚙️',
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedSettings01),
                  onTap: () {
                    context.navigateToSettings();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.label,
    required this.emoji,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final HugeIcon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    Color backgroundColor = tokens.colors.background;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Close the dialog before navigating
        onTap();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: tokens.colors.border),
          borderRadius: BorderRadius.circular(tokens.radii.md),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.unit * 4),
          child: Column(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .start,
            children: [
              BrandText.display(emoji, size: tokens.spacing.unit * 8),
              Row(spacing: 8.0, children: [icon, BrandText.body(label)]),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceSelectionCard extends StatefulWidget {
  const PriceSelectionCard({
    super.key,
    required this.price,
    required this.menuItemId,
    required this.onPriceSelected,
  });

  final int price;
  final String menuItemId;
  final Function(int price, int quantity, String menuItemId) onPriceSelected;
  @override
  State<PriceSelectionCard> createState() => _PriceSelectionCardState();
}

class _PriceSelectionCardState extends State<PriceSelectionCard> {
  late final ValueNotifier<int> _selectedCount;
  late final CartController cartController;
  bool _isInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    cartController = context.read<CartController>();
    final count = cartController.getCartItemCountById(
      '${widget.menuItemId}-${widget.price}',
    );

    if (kDebugMode) {
      print(
        'PriceSelectionCard for menuItemId: ${widget.menuItemId}, price: ${widget.price}, initial count in cart: $count',
      );
    }
    _selectedCount = ValueNotifier<int>(count ?? 0);
    _isInitialized = true;
  }

  @override
  void dispose() {
    super.dispose();
    _selectedCount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return GestureDetector(
      onTap: () {
        _selectedCount.value = (_selectedCount.value + 1).clamp(0, 99);
        widget.onPriceSelected(
          widget.price,
          _selectedCount.value,
          widget.menuItemId,
        );
      },
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedCount,
        builder: (context, count, child) {
          return badges.Badge(
            badgeContent: BrandText.body(
              count.toString(),
              color: tokens.colors.primaryForeground,
            ),
            showBadge: count > 0,
            child: SizedBox.square(
              dimension: 150,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: count > 0
                      ? tokens.colors.accent.withValues(alpha: 0.1)
                      : tokens.colors.card,
                  borderRadius: BorderRadius.circular(tokens.radii.md),
                  border: Border.all(
                    color: count > 0
                        ? tokens.colors.accent.withValues(alpha: 0.5)
                        : tokens.colors.border,
                    width: count > 0 ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(tokens.spacing.unit * 2),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (count > 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: FossButton.icon(
                            style: FossButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                tokens.colors.destructiveLight,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                tokens.colors.destructiveLightForeground,
                              ),
                            ),
                            semanticLabel:
                                "Decrease quantity of item with price ₹${widget.price}",
                            variant: .secondary,
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedRemove01,
                              size: tokens.spacing.unit * 2,
                            ),
                            onPressed: () {
                              _selectedCount.value = (_selectedCount.value - 1)
                                  .clamp(0, 99);

                              cartController.decreaseItemQuantity(
                                '${widget.menuItemId}-${widget.price}',
                              );
                            },
                          ),
                        ),
                      BrandText.display('₹${widget.price}'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuCardGrid extends StatelessWidget {
  const MenuCardGrid({super.key});
  void openPriceSelectionSheet(
    BuildContext context,
    MenuItemTableData menuItem,
    Function(int price, int quantity, String menuItemId) onPriceSelected,
  ) {
    showFossDrawer<void>(
      context: context,
      builder: (BuildContext context) {
        final tokens = context.fossTheme;
        return FossDrawer(
          title: BrandText.title('Select Price for ${menuItem.name}'),
          actions: [
            FossButton(
              style: FossButtonStyle(
                padding: EdgeInsets.symmetric(
                  vertical: tokens.spacing.unit * 2,
                  horizontal: tokens.spacing.unit * 18,
                ),
              ),
              semanticLabel: "Close price selection sheet",
              size: .lg,
              leading: SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: HugeIcon(
                    strokeWidth: tokens.spacing.unit / 2,
                    icon: HugeIcons.strokeRoundedPanelBottomClose,
                    size: 24,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: BrandText.label(
                'Close',
                color: context.fossTheme.colors.primaryForeground,
              ),
            ),
          ],
          showHandle: true,
          content: SizedBox(
            width: double.maxFinite,
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                for (int price in menuItem.prices)
                  PriceSelectionCard(
                    price: price,
                    onPriceSelected: onPriceSelected,
                    menuItemId: menuItem.id,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.read<CartController>();
    final menuRepository = context.read<MenuRepository>();

    final tokens = context.fossTheme;

    return StreamBuilder(
      stream: menuRepository.watchActiveMenu(),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: FossSpinner());
          case ConnectionState.done:
          case ConnectionState.active:
            if (asyncSnapshot.hasError) {
              return Center(
                child: BrandText.body(
                  'Error: ${asyncSnapshot.error}',
                  color: tokens.colors.destructiveForeground,
                ),
              );
            }
            final menuItems = asyncSnapshot.data ?? [];
            if (menuItems.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: tokens.spacing.unit * 4,
                  children: [
                    const BrandText.body('No menu items available.'),
                    FossButton(
                      leading: HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
                      size: .lg,
                      onPressed: () {
                        context.navigateToMenu();
                      },
                      child: BrandText.body(
                        'Add Menu Items',
                        color: tokens.colors.primaryForeground,
                      ),
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final menuItem = menuItems[index];
                return Selector<CartController, int>(
                  selector: (context, cartController) {
                    return cartController.getCartItemCountByMenuId(
                          menuItem.id,
                        ) ??
                        0;
                  },
                  builder: (context, quantity, child) {
                    if (kDebugMode) {
                      print(
                        'MenuItem: ${menuItem.name}, Quantity in Cart: $quantity',
                      );
                    }
                    return MenuItemCard.standard(
                      name: menuItem.name,
                      emoji: menuItem.icon,
                      quantity: quantity,
                      selected: quantity > 0,
                      price: menuItem.prices.length == 1
                          ? '₹${menuItem.prices.first}'
                          : '₹${menuItem.prices.first}-₹${menuItem.prices.last}', // Assuming first price is used
                      onTap: () {
                        openPriceSelectionSheet(context, menuItem, (
                          selectedPrice,
                          selectedQuantity,
                          menuItemId,
                        ) {
                          final item = CartItem(
                            id: '${menuItem.id}-$selectedPrice',
                            itemName: menuItem.name,
                            emoji: menuItem.icon,
                            menuItemId: menuItem.id,
                            quantity: selectedQuantity,
                            price: selectedPrice,
                          );
                          cartController.addItemToCart(item);
                        });
                      },
                    );
                  },
                );
              },
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class PedingOrdersList extends StatelessWidget {
  const PedingOrdersList({super.key});

  void _markPaid(BuildContext context, OrderTableData order) async {
    final paymentMethod = await showFossDrawer<PaymentMethod>(
      context: context,
      builder: (BuildContext context) {
        return PaymentMethodSelectionSheet(
          // orderId: order.id,
        );
      },
    );

    if (paymentMethod != null) {
      final ordersRepository = context.read<OrdersRepository>();
      ordersRepository
          .markOrderPaid(orderId: order.id, paymentMethod: paymentMethod)
          .then((_) {
            if (kDebugMode) {
              print('Order ${order.id} marked as paid.');
            }
            showFossToast(
              context,
              FossToast(
                style: FossToastStyle(
                  backgroundColor: context.fossTheme.colors.successLight,
                  borderColor: context.fossTheme.colors.successLightForeground,
                  borderRadius: context.fossTheme.radii.md,
                ),
                title: BrandText.label(
                  'Payment done with ${paymentMethod.name} for ${order.customerAlias}.',
                  color: context.fossTheme.colors.successLightForeground,
                ),
                variant: .success,
              ),
            );
          })
          .catchError((error) {
            if (kDebugMode) {
              print('Error marking order ${order.id} as paid: $error');
            }
            showFossToast(
              context,
              FossToast(
                title: BrandText.body(
                  'Error marking order ${order.id} as paid.',
                  color: context.fossTheme.colors.destructiveForeground,
                ),
                variant: .error,
              ),
            );
          });
    } else {
      showSimpleNotification(
        FossAlert(
          title: BrandText.body(
            'Payment method selection cancelled.',
            color: context.fossTheme.colors.mutedForeground,
          ),
          style: FossAlertStyle(
            backgroundColor: context.fossTheme.colors.infoLight,
            borderColor: context.fossTheme.colors.infoLightForeground,
            borderRadius: context.fossTheme.radii.md,
            iconColor: context.fossTheme.colors.infoLightForeground,
          ),
          variant: .info,
        ),
        autoDismiss: true,
        background: Color(
          0x00000000,
        ), // Transparent background to let the toast's own style show
        elevation: 0,
        position: .top,
        slideDismissDirection: .horizontal,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersRepository = context.read<OrdersRepository>();
    return SizedBox(
      height: 200,
      child: StreamBuilder(
        stream: ordersRepository.watchPendingOrders(),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: FossSpinner());
            case ConnectionState.done:
            case ConnectionState.active:
              if (asyncSnapshot.hasError) {
                return Center(
                  child: BrandText.body(
                    'Error: ${asyncSnapshot.error}',
                    // color: context.colorScheme.onError,
                  ),
                );
              }
              final orders = asyncSnapshot.data ?? [];
              if (orders.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedHistory),
                      FossText.body('No pending orders.'),
                    ],
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                scrollDirection: .horizontal,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return MinimalOrderStatusCard(
                    amount: order.total.toString(),
                    customer: order.customerAlias ?? 'Unknown Customer',
                    itemCount: order.itemCount,
                    onViewDetails: () async {
                      final orderItems = await ordersRepository
                          .getOrderItemsByOrderId(order.id);
                      showFossDrawer<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return OrderPreviewSheet(
                            order: order,
                            orderItems: orderItems,
                          );
                        },
                      );
                      if (kDebugMode) {
                        print('View details for order ${order.id}');
                      }
                    },
                    onSettle: () {
                      _markPaid(context, order);
                    },
                    status: .pending,
                  );
                },
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class CartReviewSheet extends StatelessWidget {
  const CartReviewSheet({super.key});

  void showAlert(BuildContext context, String message) {
    final tokens = context.fossTheme;
    final alert = FossAlert(
      style: FossAlertStyle(
        backgroundColor: tokens.colors.destructiveLight,
        borderColor: tokens.colors.destructiveLightForeground,
        borderRadius: tokens.radii.md,
        iconColor: tokens.colors.destructiveLightForeground,
        descriptionStyle: tokens.typography.sm.copyWith(
          color: tokens.colors.destructiveLightForeground,
        ),
      ),
      title: BrandText.body(
        message,
        color: tokens.colors.destructiveLightForeground,
      ),
      variant: .error,
    );

    // showFossToast(context, toast);
    showSimpleNotification(
      alert,
      context: context,
      elevation: 0,
      background: Color(
        0x00000000,
      ), // Transparent background to let the toast's own style show
      autoDismiss: true,
      slideDismissDirection: DismissDirection.horizontal,
      position: NotificationPosition.top,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersRepository = context.read<OrdersRepository>();
    final tokens = context.fossTheme;
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        return FossDrawer(
          footerVariant: .filled,
          title: Row(
            spacing: tokens.spacing.unit * 2,
            crossAxisAlignment: .center,
            children: [
              const HugeIcon(icon: HugeIcons.strokeRoundedShoppingBasketAdd01),
              const FossText.title('Cart Review'),
              FossChip(label: Text('${cartController.itemCount} items')),
            ],
          ),
          showHandle: true,
          content: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .end,
            children: [
              FossSeparator(decorative: true),
              BrandCustomerHeaderBanner(
                name: cartController.cart.customerAlias,
                onNameChanged: cartController.editCustomerName,
                placeholder: 'Customer name',
                sourceLabel: 'i.e. Table 1, John, Blue Shirt, etc.',
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ColoredBox(
                  color: tokens.colors.secondary.withValues(alpha: 0.5),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: cartController.cart.items.length,
                    physics: cartController.cart.items.length > 3
                        ? const BouncingScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final cartItem = cartController.cart.items.values
                          .elementAt(index); // Accessing the values of the map

                      return OrderReviewItem(
                        name: cartItem.itemName,
                        emoji: cartItem.emoji,
                        quantity: cartItem.quantity,
                        price: cartItem.price,
                        onIncrement: (newQuantity) {
                          cartController.increaseItemQuantity(
                            '${cartItem.menuItemId}-${cartItem.price}',
                          );
                          if (kDebugMode) {
                            print(
                              'Quantity change for ${cartItem.itemName}: $newQuantity',
                            );
                          }
                        },
                        onDecrement: (newQuantity) {
                          cartController.decreaseItemQuantity(
                            '${cartItem.menuItemId}-${cartItem.price}',
                          );
                          if (kDebugMode) {
                            print(
                              'Quantity change for ${cartItem.itemName}: $newQuantity',
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              FossSeparator(decorative: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FossText.title('Total Payable'.toUpperCase()),
                      FossText.caption('All taxes & platform fees included'),
                    ],
                  ),
                  BrandText.title('₹${cartController.total}'),
                ],
              ),

              FossSeparator(decorative: true),
              ConfirmationButton(
                onTap: () {
                  try {
                    cartController.placeOrder(ordersRepository);
                    Navigator.pop(
                      context,
                    ); // Close the bottom sheet after placing the order
                  } catch (e) {
                    if (e is FlutterError) {
                      showAlert(context, e.message);
                    } else {
                      showAlert(context, 'An unexpected error occurred.');
                    }
                    if (kDebugMode) {
                      print('Error placing order: $e');
                    }
                  }
                  if (kDebugMode) {
                    print('Place Order button tapped');
                    print(
                      'Placing order with ${cartController.itemCount} items, total: ${cartController.total}',
                    );
                  }
                },
              ),
              FossButton(
                variant: .ghost,
                size: .lg,
                leading: const HugeIcon(icon: HugeIcons.strokeRoundedDelete02),
                style: FossButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    tokens.colors.destructiveLight,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    tokens.colors.destructiveLightForeground,
                  ),
                  side: BorderSide(color: tokens.colors.border),
                  padding: EdgeInsets.symmetric(
                    vertical: tokens.spacing.unit * 2,
                    horizontal: tokens.spacing.unit * 10,
                  ),
                ),
                onPressed: () async {
                  final confirmClear = await showConfirmationDialog(
                    context: context,
                    title: 'Clear Order',
                    message:
                        'Are you sure you want to clear the current order?',
                    confirmText: 'Clear Order',
                    cancelText: 'Keep Order',
                    isDangerous: true,
                  );
                  if (!confirmClear) {
                    if (kDebugMode) {
                      print('Clear order action cancelled by user.');
                    }
                    return;
                  }
                  cartController.clearCart();
                  if (kDebugMode) {
                    print('Clear Order button tapped');
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: BrandText.label(
                  'Clear Order',
                  color: tokens.colors.destructiveLightForeground,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ConfirmationButton extends StatelessWidget {
  const ConfirmationButton({
    super.key,
    required this.onTap,
    this.text = 'Place Order',
    this.label = 'Save to Pending Payments',
  });

  final VoidCallback onTap;
  final String text;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.colors.success,
          border: Border.all(color: tokens.colors.border),
          borderRadius: BorderRadius.circular(tokens.radii.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            spacing: tokens.spacing.unit * 2,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  FossText.title(
                    text,
                    style: tokens.typography.xl2.copyWith(
                      color: tokens.colors.successForeground,
                    ),
                  ),
                  FossText.caption(
                    label,
                    style: tokens.typography.sm.copyWith(
                      color: tokens.colors.successForeground.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                color: tokens.colors.successForeground,
                size: tokens.spacing.unit * 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderReviewItem extends StatelessWidget {
  const OrderReviewItem({
    super.key,
    required this.name,
    required this.emoji,
    required this.quantity,
    required this.price,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String name;
  final String emoji;
  final int quantity;
  final int price;
  final Function(int) onIncrement;
  final Function(int) onDecrement;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.colors.card,
        border: Border.all(color: tokens.colors.border),
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: tokens.spacing.unit * 2,
          children: [
            BrandText.title(emoji),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FossText.body(name),
                FossText.caption('$quantity x ₹$price'),
              ],
            ),
            Spacer(),
            QuantityStepper(
              onChanged: (newQuantity) {
                if (newQuantity > quantity) {
                  onIncrement(newQuantity);
                } else if (newQuantity < quantity) {
                  onDecrement(newQuantity);
                }
              },
              value: quantity,
              min: 1,
            ),
            Spacer(),
            BrandText.title('₹${quantity * price}'),
          ],
        ),
      ),
    );
  }
}

class OrderedItemTile extends StatelessWidget {
  const OrderedItemTile({
    super.key,
    required this.name,
    required this.emoji,
    required this.quantity,
    required this.price,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final String name;
  final String emoji;
  final int quantity;
  final int price;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.colors.card,
        border: Border.all(color: tokens.colors.border),
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: tokens.spacing.unit * 2,
          children: [
            BrandText.title(emoji),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandText.body(name),
                BrandText.caption('$quantity x ₹$price'),
              ],
            ),
            Spacer(),
            BrandText.title('₹${quantity * price}'),
          ],
        ),
      ),
    );
  }
}

class OrderPreviewSheet extends StatelessWidget {
  const OrderPreviewSheet({
    super.key,
    required this.order,
    required this.orderItems,
  });

  final OrderTableData order;
  final List<OrderItemsTableData> orderItems;

  void _markPaid(BuildContext context) async {
    final paymentMethod = await showFossDrawer<PaymentMethod>(
      context: context,
      builder: (BuildContext context) {
        return PaymentMethodSelectionSheet(
          // orderId: order.id,
        );
      },
    );

    if (paymentMethod != null) {
      final ordersRepository = context.read<OrdersRepository>();
      ordersRepository
          .markOrderPaid(orderId: order.id, paymentMethod: paymentMethod)
          .then((_) {
            if (kDebugMode) {
              print('Order ${order.id} marked as paid.');
            }
            showFossToast(
              context,
              FossToast(
                style: FossToastStyle(
                  backgroundColor: context.fossTheme.colors.successLight,
                  borderColor: context.fossTheme.colors.successLightForeground,
                  borderRadius: context.fossTheme.radii.md,
                ),
                title: BrandText.label(
                  'Payment done with ${paymentMethod.name} for ${order.customerAlias}.',
                  color: context.fossTheme.colors.successLightForeground,
                ),
                variant: .success,
              ),
            );
            Navigator.pop(context); // Close the bottom sheet
          })
          .catchError((error) {
            if (kDebugMode) {
              print('Error marking order ${order.id} as paid: $error');
            }
            showFossToast(
              context,
              FossToast(
                title: BrandText.body(
                  'Error marking order ${order.id} as paid.',
                  color: context.fossTheme.colors.destructiveForeground,
                ),
                variant: .error,
              ),
            );
          });
    } else {
      showSimpleNotification(
        FossAlert(
          title: BrandText.body(
            'Payment method selection cancelled.',
            color: context.fossTheme.colors.mutedForeground,
          ),
          style: FossAlertStyle(
            backgroundColor: context.fossTheme.colors.infoLight,
            borderColor: context.fossTheme.colors.infoLightForeground,
            borderRadius: context.fossTheme.radii.md,
            iconColor: context.fossTheme.colors.infoLightForeground,
          ),
          variant: .info,
        ),
        autoDismiss: true,
        background: Color(
          0x00000000,
        ), // Transparent background to let the toast's own style show
        elevation: 0,
        position: .top,
        slideDismissDirection: .horizontal,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersRepository = context.read<OrdersRepository>();
    final tokens = context.fossTheme;
    return FossDrawer(
      showHandle: true,
      title: Row(
        spacing: tokens.spacing.unit * 2,
        crossAxisAlignment: .center,
        children: [
          const HugeIcon(icon: HugeIcons.strokeRoundedShoppingBasket01),
          const BrandText.subtitle('Order Review'),
          FossChip(label: Text('${order.itemCount} items')),
        ],
      ),
      content: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: .end,
        children: [
          BrandCustomerHeaderBanner(
            name: order.customerAlias ?? 'Walk-in Customer',
            updatedLabel: timeAgoString(order.createdAt),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ColoredBox(
                color: tokens.colors.secondary.withValues(alpha: 0.5),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: orderItems.length,
                  physics: orderItems.length > 3
                      ? const BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // Accessing the values of the map
                    return OrderedItemTile(
                      name: orderItems[index].itemName,
                      emoji: orderItems[index]
                          .emoji, // Default emoji if not available
                      quantity: orderItems[index].quantity,
                      price: orderItems[index].price,
                      onIncrement: (newQuantity) {},
                      onDecrement: (newQuantity) {},
                      onRemove: () {},
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandText.subtitle('Total Payable'.toUpperCase()),
                  BrandText.caption(
                    'All taxes & platform fees included',
                    color: tokens.colors.mutedForeground,
                  ),
                ],
              ),
              BrandText.title('₹${order.total}'),
            ],
          ),
          ConfirmationButton(
            onTap: () => _markPaid(context),
            text: 'Mark as Paid',
            label: 'Save to Completed Payments',
          ),
          FossButton(
            variant: .ghost,
            size: .lg,
            leading: const HugeIcon(icon: HugeIcons.strokeRoundedDelete02),
            style: FossButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                tokens.colors.destructive.withValues(alpha: 0.1),
              ),
              foregroundColor: WidgetStatePropertyAll(
                tokens.colors.destructiveForeground,
              ),
              side: BorderSide(color: tokens.colors.destructive),
            ),
            onPressed: () async {
              if (kDebugMode) {
                print('Cancel Order button tapped');
              }
              final cancel = await showConfirmationDialog(
                context: context,
                title: 'Cancel Order',
                message: 'Are you sure you want to cancel this order?',
                confirmText: 'Cancel Order',
                cancelText: 'Keep Order',
                isDangerous: true,
              );

              if (kDebugMode) {
                print('Cancel confirmation result: $cancel');
              }
              if (cancel) {
                ordersRepository
                    .deleteOrder(order.id)
                    .then((_) {
                      if (kDebugMode) {
                        print('Order ${order.id} deleted successfully.');
                      }
                      Navigator.pop(context); // Close the bottom sheet
                    })
                    .catchError((error) {
                      if (kDebugMode) {
                        print('Error deleting order ${order.id}: $error');
                      }
                    });
                if (kDebugMode) {
                  print('Order ${order.id} cancelled.');
                }
              } else {
                if (kDebugMode) {
                  print('Order ${order.id} not cancelled.');
                }
              }
            },
            child: Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}

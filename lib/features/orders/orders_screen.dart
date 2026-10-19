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
import 'package:movo/data/repositories/order_repository.dart';
import 'package:movo/features/payment/widgets/payment_method_selection_sheet.dart';
import 'package:movo/utils/formatter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

enum OrderDateFilter { today, yesterday, sevenDays, custom }

class _OrderScreenState extends State<OrderScreen> {
  late OrdersRepository ordersRepository;
  bool _initialized = false;
  late double bottomWidget;

  // Status filter state
  final ValueNotifier<String> _statusFilter = ValueNotifier<String>('pending');
  final ValueNotifier<OrderDateFilter> _dateFilter =
      ValueNotifier<OrderDateFilter>(OrderDateFilter.today);
  FossDateRange? _customDateRange;

  ({DateTime start, DateTime end}) _getDateRange(OrderDateFilter filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (filter) {
      case OrderDateFilter.today:
        return (start: today, end: today.add(const Duration(days: 1)));
      case OrderDateFilter.yesterday:
        return (start: today.subtract(const Duration(days: 1)), end: today);
      case OrderDateFilter.sevenDays:
        return (
          start: today.subtract(const Duration(days: 6)),
          end: today.add(const Duration(days: 1)),
        );
      case OrderDateFilter.custom:
        final customRange = _customDateRange;
        return customRange == null
            ? (start: today, end: today.add(const Duration(days: 1)))
            : (
                start: customRange.start,
                end: DateTime(
                  customRange.end.year,
                  customRange.end.month,
                  customRange.end.day + 1,
                ),
              );
    }
  }

  Future<List<OrderTableData>> _getSelectedStream(
    String status,
    OrderDateFilter dateFilter,
  ) {
    final dateRange = _getDateRange(dateFilter);
    Future<List<OrderTableData>> future;
    switch (status) {
      case 'pending':
        future = ordersRepository.getPendingOrdersByDateRange(
          startDate: dateRange.start,
          endDate: dateRange.end,
        );
        break;
      case 'paid':
        future = ordersRepository.getCompletedOrdersByDateRange(
          startDate: dateRange.start,
          endDate: dateRange.end,
        );
        break;
      default:
        future = ordersRepository.getAllOrdersByDateRange(
          startDate: dateRange.start,
          endDate: dateRange.end,
        );
    }
    return future;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      ordersRepository = context.read<OrdersRepository>();
      bottomWidget = MediaQuery.of(context).padding.bottom;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _statusFilter.dispose();
    _dateFilter.dispose();
    super.dispose();
  }

  Future<void> _showOrderDetailsDialog(
    BuildContext context,
    OrderTableData order,
  ) async {
    final tokens = context.fossTheme;
    await showFossDialog(
      context: context,
      builder: (BuildContext context) {
        return FossDrawer(
          showHandle: true,
          title: BrandText.title('Order Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DetailRowWidget(
                  label: 'Customer',
                  value: order.customerAlias ?? 'Guest',
                  tokens: tokens,
                ),
                DetailRowWidget(
                  label: 'Status',
                  value: _getStatusLabel(order),
                  tokens: tokens,
                ),
                DetailRowWidget(
                  label: 'Created',
                  value: orderDateTimeString(order.createdAt),
                  tokens: tokens,
                ),
                if (order.paidAt != null)
                  DetailRowWidget(
                    label: 'Paid At',
                    value: orderDateTimeString(order.paidAt ?? DateTime.now()),
                    tokens: tokens,
                  ),
                if (order.paymentMethod != null)
                  DetailRowWidget(
                    label: 'Payment Method',
                    value: _getPaymentLabel(order.paymentMethod ?? 'Unknown'),
                    tokens: tokens,
                  ),
                const SizedBox(height: 12),
                const FossSeparator(),
                const SizedBox(height: 12),
                Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<OrderItemsTableData>>(
                  future: ordersRepository.getOrderItemsByOrderId(order.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FossSpinner(),
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];
                    return Column(
                      children: items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: BrandText.body(
                                      '${item.itemName} x${item.quantity}',
                                      color: tokens.colors.foreground,
                                    ),
                                  ),
                                  BrandText.body(
                                    '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                                    color: tokens.colors.foreground,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const FossSeparator(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    BrandText.body(
                      '₹${order.total.toStringAsFixed(0)}',
                      color: tokens.colors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            FossButton(
              onPressed: () => Navigator.of(context).pop(),
              child: BrandText.title(
                'Close',
                color: tokens.colors.primaryForeground,
              ),
            ),
          ],
        );
      },
    );
  }

  String _getStatusLabel(OrderTableData? order) {
    switch (order?.status) {
      case 'pending':
        return 'Active';
      case 'paid':
        return 'Paid';
      case 'cancelled':
        return 'Cancelled';
      default:
        return order?.status ?? 'Unknown';
    }
  }

  String _getPaymentLabel(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'upi':
        return 'UPI';
      case 'card':
        return 'Card';
      default:
        return paymentMethod;
    }
  }

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
    final tokens = context.fossTheme;
    return AppScaffold(
      appBar: BrandTopBar(title: 'Orders'),
      bottomAppBar: PreferredSize(
        preferredSize: Size.fromHeight(56 + bottomWidget),
        child: ValueListenableBuilder(
          valueListenable: _statusFilter,
          builder: (context, value, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: _getStatusBackgroundColor(value, tokens.colors),
              ),
              child: SizedBox(
                height: 56 + bottomWidget,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: ValueListenableBuilder<OrderDateFilter>(
                    valueListenable: _dateFilter,
                    builder: (context, dateFilter, child) {
                      return FutureBuilder<List<OrderTableData>>(
                        future: _getSelectedStream(value, dateFilter),
                        builder: (context, snapshot) {
                          final orders = snapshot.data ?? [];
                          final totalSales = orders.fold<double>(
                            0.0,
                            (sum, order) => sum + order.total,
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Orders: ${orders.length}',
                                style: tokens.typography.lg.copyWith(
                                  color: _getStatusColor(value, tokens.colors),
                                ),
                              ),
                              Text(
                                '${_getStatusText(value)} Amount: ₹${totalSales.toStringAsFixed(2)}',
                                style: tokens.typography.lg.copyWith(
                                  color: _getStatusColor(value, tokens.colors),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
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
                        FossTab(value: 'pending', label: 'Pending'),
                        FossTab(value: 'paid', label: 'Paid'),
                        FossTab(value: 'all', label: 'All'),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacing.unit * 4,
                ),
                child: ValueListenableBuilder<OrderDateFilter>(
                  valueListenable: _dateFilter,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FossSelect<OrderDateFilter>(
                          value: value,
                          items: const [
                            FossSelectItem(
                              value: OrderDateFilter.today,
                              label: 'Today',
                            ),
                            FossSelectItem(
                              value: OrderDateFilter.yesterday,
                              label: 'Yesterday',
                            ),
                            FossSelectItem(
                              value: OrderDateFilter.sevenDays,
                              label: '7 days',
                            ),
                            FossSelectItem(
                              value: OrderDateFilter.custom,
                              label: 'Custom',
                            ),
                          ],
                          onChanged: (selected) {
                            if (selected == OrderDateFilter.custom) {
                              _dateFilter.value = selected;
                            } else {
                              _dateFilter.value = selected;
                            }
                          },
                        ),
                        if (value == OrderDateFilter.custom)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: FossDatePicker.range(
                              selected: _customDateRange,
                              placeholder: 'Choose date range',
                              minDate: DateTime(2000),
                              maxDate: DateTime.now(),
                              onSelected: (range) {
                                setState(() {
                                  _customDateRange = range;
                                });
                              },
                              format: (range) =>
                                  '${dayMonthDateString(range.start)} - '
                                  '${dayMonthDateString(range.end)}',
                              style: const FossDatePickerStyle(gap: 8),
                            ),
                          ),
                        if (value == OrderDateFilter.custom &&
                            _customDateRange != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${dayMonthDateString(_customDateRange!.start)} - '
                              '${dayMonthDateString(_customDateRange!.end)}',
                              style: tokens.typography.sm.copyWith(
                                color: tokens.colors.mutedForeground,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),

              // Orders List
              Expanded(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_statusFilter, _dateFilter]),
                  builder: (context, _) {
                    final status = _statusFilter.value;
                    final dateFilter = _dateFilter.value;
                    return FutureBuilder<List<OrderTableData>>(
                      future: _getSelectedStream(status, dateFilter),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: FossSpinner());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: BrandText.body(
                              'Error loading orders: ${snapshot.error}',
                            ),
                          );
                        }
                        final orders = snapshot.data ?? [];
                        if (orders.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedReceiptText,
                                  size: 64,
                                  color: tokens.colors.background.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No orders found',
                                  style: tokens.typography.lg.copyWith(
                                    color: tokens.colors.foreground.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.only(
                            left: tokens.spacing.unit * 4,
                            right: tokens.spacing.unit * 4,
                            top: tokens.spacing.unit * 2,
                            bottom: tokens.spacing.unit * 4,
                          ),
                          itemCount: orders.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12.0),
                          itemBuilder: (context, index) {
                            final orderedItems = ordersRepository
                                .getOrderItemsByOrderId(orders[index].id);
                            return GestureDetector(
                              onTap: () {
                                _showOrderDetailsDialog(context, orders[index]);
                              },
                              child: OrderStatusCard(
                                amount: '${orders[index].total}',
                                createdAt: orders[index].createdAt,
                                orderItemsFuture: orderedItems,
                                customer:
                                    orders[index].customerAlias ?? 'Unknown',
                                itemCount: orders[index].itemCount,
                                status: _getOrderStatus(
                                  orders[index].status,
                                  tokens.colors,
                                ),
                                paymentMethod: orders[index].paymentMethod,
                                onSettle: () {
                                  _markPaid(context, orders[index]);
                                },
                              ),
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
        ],
      ),
    );
  }

  OrderStatus _getOrderStatus(String status, FossColors colors) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'paid':
        return OrderStatus.paid;
      default:
        return OrderStatus.pending;
    }
  }

  Color _getStatusColor(String status, FossColors colors) {
    switch (status) {
      case 'pending':
        return colors.warningLightForeground;
      case 'paid':
        return colors.successLightForeground;
      default:
        return colors.primaryLightForeground;
    }
  }

  Color _getStatusBackgroundColor(String status, FossColors colors) {
    switch (status) {
      case 'pending':
        return colors.warningLight;
      case 'paid':
        return colors.successLight;
      default:
        return colors.primaryLight;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'paid':
        return 'Paid';
      default:
        return 'Total';
    }
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String currentFilter,
    FossThemeData tokens,
  ) {
    final isSelected = currentFilter == value;
    return GestureDetector(
      onTap: () => _statusFilter.value = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? tokens.colors.primary : tokens.colors.background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? tokens.colors.primaryForeground
                : tokens.colors.background.withValues(alpha: 0.3),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class DetailRowWidget extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.value,
    required this.tokens,
  });

  final String label;
  final String value;
  final FossThemeData tokens;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: BrandText.label(
              '$label:',
              color: tokens.colors.mutedForeground,
            ),
          ),
          Expanded(
            child: BrandText.body(value, color: tokens.colors.foreground),
          ),
        ],
      ),
    );
  }
}

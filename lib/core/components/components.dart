import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:movo/app/dependencies/app_dependencies.dart';
import 'package:movo/core/components/app_bar.dart';
import 'package:movo/core/theme/movo_theme.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/order_table.dart';
import 'package:movo/utils/formatter.dart';
import 'package:hugeicons/hugeicons.dart';

class BrandCustomerHeaderBanner extends StatefulWidget {
  const BrandCustomerHeaderBanner({
    super.key,
    required this.name,
    this.placeholder,
    this.updatedLabel,
    this.sourceLabel,
    this.onNameChanged,
  });

  final String name;
  final String? placeholder;
  final String? updatedLabel;
  final String? sourceLabel;
  final ValueChanged<String>? onNameChanged;

  @override
  State<BrandCustomerHeaderBanner> createState() =>
      _BrandCustomerHeaderBannerState();
}

class _BrandCustomerHeaderBannerState extends State<BrandCustomerHeaderBanner> {
  late final TextEditingController _nameController;
  bool _isEditing = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  void didUpdateWidget(BrandCustomerHeaderBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.name != widget.name) {
      _nameController.text = widget.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _focusNode.requestFocus();
      _nameController
        ..text = widget.name
        ..selection = TextSelection.collapsed(offset: widget.name.length);
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _focusNode.unfocus();
      _nameController.text = widget.name;
    });
  }

  void _saveEditing() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _cancelEditing();
      return;
    }
    widget.onNameChanged?.call(name);
    setState(() {
      _isEditing = false;
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.fossTheme.colors.background,
        border: Border.all(color: context.fossTheme.colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: .center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.fossTheme.colors.card,
                    border: Border.all(color: context.fossTheme.colors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUserSquare,
                    size: tokens.spacing.unit * 8,
                    color: context.fossTheme.colors.foreground,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .max,
                    spacing: tokens.spacing.unit,
                    children: [
                      if (_isEditing)
                        Row(
                          children: [
                            Expanded(
                              child: FossTextField(
                                focusNode: _focusNode,
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                onSubmitted: (_) => _saveEditing(),
                                hintText:
                                    widget.placeholder ?? 'Walk-in Customer',
                              ),
                            ),
                            if (widget.onNameChanged != null) ...[
                              FossButton.icon(
                                semanticLabel: 'Save Customer Name',
                                variant: .ghost,
                                onPressed: _saveEditing,
                                style: FossButtonStyle(
                                  foregroundColor: WidgetStateProperty.all(
                                    context
                                        .fossTheme
                                        .colors
                                        .primaryLightForeground,
                                  ),
                                ),
                                icon: HugeIcon(
                                  icon:
                                      HugeIcons.strokeRoundedCheckmarkCircle01,
                                ),
                              ),
                              FossButton.icon(
                                semanticLabel: 'Cancel Editing Customer Name',
                                variant: .ghost,
                                style: FossButtonStyle(
                                  foregroundColor: WidgetStateProperty.all(
                                    context
                                        .fossTheme
                                        .colors
                                        .destructiveLightForeground,
                                  ),
                                ),

                                onPressed: _cancelEditing,
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedCancelCircle,
                                ),
                              ),
                            ],
                          ],
                        )
                      else
                        GestureDetector(
                          onTap: widget.onNameChanged != null
                              ? _startEditing
                              : null,
                          child: BrandText.body(
                            widget.name.isEmpty
                                ? (widget.placeholder ?? 'Walk-in Customer')
                                : widget.name,
                            size: tokens.spacing.unit * 5,
                            color: widget.name.isEmpty
                                ? context.fossTheme.colors.mutedForeground
                                : context.fossTheme.colors.foreground,
                          ),
                        ),
                      if (widget.name.isEmpty &&
                          (widget.updatedLabel != null ||
                              widget.sourceLabel != null))
                        BrandText.caption(
                          widget.updatedLabel ?? widget.sourceLabel ?? '',
                          color: context.fossTheme.colors.ring,
                          // '${widget.updatedLabel} | ${widget.sourceLabel}',
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (_isEditing)
            const SizedBox.shrink()
          else if (widget.onNameChanged != null)
            FossButton(
              variant: .secondary,
              onPressed: _startEditing,
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
}

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.onRemove,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback? onRemove;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.colors.background,
        border: Border.all(color: tokens.colors.border),
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Row(
        spacing: tokens.spacing.unit * 2,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value == min)
            _stepButton(
              icon: HugeIcons.strokeRoundedDelete02,
              buttonStyle: FossButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  tokens.colors.background,
                ),
                foregroundColor: WidgetStateProperty.all(
                  tokens.colors.destructive,
                ),
                side: BorderSide(color: tokens.colors.border),
                borderRadius: tokens.radii.md,
              ),
              enabled: true,
              callback: () {
                onChanged(value - 1);
              },
              color: tokens.colors.destructive,
            )
          else
            _stepButton(
              icon: HugeIcons.strokeRoundedRemove01,
              buttonStyle: FossButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  tokens.colors.background,
                ),
                foregroundColor: WidgetStateProperty.all(tokens.colors.primary),
                side: BorderSide(color: tokens.colors.border),
                borderRadius: tokens.radii.md,
              ),
              enabled: value > min,

              callback: () {
                onChanged(value - 1);
              },
            ),
          SizedBox(
            width: 24,
            child: Center(child: FossText.title(value.toString())),
          ),
          _stepButton(
            icon: HugeIcons.strokeRoundedAdd01,
            buttonStyle: FossButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                tokens.colors.background,
              ),
              foregroundColor: WidgetStateProperty.all(tokens.colors.primary),
              side: BorderSide(color: tokens.colors.border),
              borderRadius: tokens.radii.md,
            ),
            enabled: value < max,
            callback: () {
              onChanged(value + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _stepButton({
    required List<List<dynamic>> icon,
    required FossButtonStyle buttonStyle,
    required bool enabled,
    required VoidCallback callback,
    Color? color,
  }) {
    return SizedBox(
      height: 40,
      width: 40,
      child: FossButton.icon(
        onPressed: enabled ? callback : null,
        icon: HugeIcon(icon: icon, color: color, size: 4),
        size: .sm,
        semanticLabel: 'Quantity Stepper Button',
        style: buttonStyle.merge(
          FossButtonStyle(padding: const EdgeInsets.all(8)),
        ),
      ),
    );
  }
}

enum MenuItemCardVariant { standard, editable }

class MenuItemCard extends StatefulWidget {
  const MenuItemCard.standard({
    super.key,
    required this.name,
    required this.price,
    required this.onTap,
    this.emoji = '☕',
    this.quantity = 0,
    this.selected = false,
  }) : variant = MenuItemCardVariant.standard,
       active = true,
       onMenuStatusToggle = null;

  const MenuItemCard.editable({
    super.key,
    required this.name,
    required this.price,
    required this.onTap,
    required this.active,
    this.onMenuStatusToggle,
    this.emoji = '☕',
  }) : variant = MenuItemCardVariant.editable,
       quantity = 0,
       selected = false;

  final String name;
  final String price;
  final String emoji;
  final int quantity;
  final bool selected;
  final VoidCallback onTap;
  final bool active;
  final MenuItemCardVariant variant;
  final Function(bool)? onMenuStatusToggle;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    switch (widget.variant) {
      case MenuItemCardVariant.standard:
        return GestureDetector(
          onTap: widget.onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 140),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.selected
                    ? tokens.colors.accent.withValues(alpha: 0.1)
                    : tokens.colors.card,
                borderRadius: BorderRadius.circular(tokens.radii.md),
                border: Border.all(
                  color: widget.selected
                      ? tokens.colors.accent.withValues(alpha: 0.5)
                      : tokens.colors.border,
                  width: widget.selected ? 2 : 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(tokens.spacing.unit * 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .start,
                      children: [
                        FossText(
                          widget.emoji,
                          style: tokens.typography.xl2.copyWith(
                            fontSize: tokens.spacing.unit * 8,
                          ),
                        ),

                        (widget.selected
                            ? FossAvatar(
                                fallback: BrandText.body(
                                  widget.quantity.toString(),
                                ),
                                style: FossAvatarStyle(
                                  backgroundColor: tokens.colors.accent,
                                ),
                                semanticLabel: 'Quantity: ${widget.quantity}',
                              )
                            : SizedBox.shrink()),
                        // : HugeIcon(
                        //     icon: HugeIcons.strokeRoundedAdd01,
                        //     size: tokens.spacing.unit * 8,
                        //   )),
                      ],
                    ),
                    const Spacer(),
                    FossText.body(widget.name),
                    const SizedBox(height: 2),
                    FossText.title(widget.price),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedAdd01,
                          size: tokens.spacing.unit * 4,
                          color: tokens.colors.mutedForeground,
                        ),
                        SizedBox(width: 4),
                        FossText.caption(
                          'Tap to Add',
                          style: tokens.typography.xs.copyWith(
                            color: tokens.colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case MenuItemCardVariant.editable:
        return GestureDetector(
          onTap: widget.onTap,
          child: FossCard(
            title: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .start,
              children: [
                Text(
                  widget.emoji,
                  style: TextStyle(fontSize: tokens.spacing.unit * 10),
                ),
                FossChip(
                  style: FossChipStyle(
                    backgroundColor: WidgetStateProperty.all(
                      widget.active
                          ? tokens.colors.successLight
                          : tokens.colors.warningLight,
                    ),
                    side: BorderSide(
                      color: widget.active
                          ? tokens.colors.success
                          : tokens.colors.warning,
                    ),
                  ),
                  leading: SizedBox(
                    width: 8,
                    height: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.active
                            ? tokens.colors.success
                            : tokens.colors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  label: BrandText.body(
                    widget.active ? 'Active' : 'Inactive',
                    color: widget.active
                        ? tokens.colors.successLightForeground
                        : tokens.colors.warningLightForeground,
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FossText.body(widget.name),
                const SizedBox(height: 2),
                FossText.heading(widget.price),
                const SizedBox(height: 8),
                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedEdit01,
                      size: tokens.spacing.unit * 4,
                    ),
                    SizedBox(width: 4),
                    BrandText.caption('Tap to Edit'),
                    const Spacer(),
                    FossSwitch(
                      value: widget.active,
                      onChanged: widget.onMenuStatusToggle,
                      semanticLabel: widget.active
                          ? 'Menu Item Active'
                          : 'Menu Item Inactive',
                      style: FossSwitchStyle(
                        activeTrackColor: tokens.colors.primary,
                        inactiveTrackColor: tokens.colors.border,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
    this.emoji = '🍔',
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final String name;
  final String price;
  final int quantity;
  final String emoji;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: EdgeInsets.all(tokens.spacing.unit),
      decoration: BoxDecoration(
        color: tokens.colors.background,
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: tokens.typography.base.copyWith(
                    color: tokens.colors.foreground,
                  ),
                ),
                Text(
                  '$quantity x $price',
                  style: tokens.typography.base.copyWith(
                    color: tokens.colors.secondaryForeground,
                  ),
                ),
              ],
            ),
          ),
          QuantityStepper(
            value: quantity,
            onChanged: onQuantityChanged,
            onRemove: onRemove,
          ),
          const SizedBox(width: 12),
          Text(
            price,
            style: tokens.typography.base.copyWith(
              color: tokens.colors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    super.key,
    required this.customer,
    required this.amount,
    required this.orderItemsFuture,
    this.itemCount = 0,
    this.status = OrderStatus.pending,
    this.onSettle,
    this.createdAt,
    this.paymentMethod,
  });

  final String customer;
  final String amount;
  final int itemCount;
  final OrderStatus status;
  final VoidCallback? onSettle;
  final DateTime? createdAt;
  final String? paymentMethod;
  final Future<List<OrderItemsTableData>> orderItemsFuture;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    final pending = status == OrderStatus.pending;
    return FossCard(
      description: Text('$itemCount items'),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: tokens.spacing.unit * 2,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: pending
                  ? tokens.colors.warningLight
                  : tokens.colors.successLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: context.fossTheme.colors.border),
            ),
            child: Padding(
              padding: EdgeInsets.all(tokens.spacing.unit * 2),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedUserSquare,
                size: tokens.spacing.unit * 6,
                color: pending
                    ? tokens.colors.warningLightForeground
                    : tokens.colors.successLightForeground,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: .start,
            children: [
              BrandText.title(customer),
              BrandText.caption(
                timeAgoString(createdAt ?? DateTime.now()),
                color: tokens.colors.secondaryForeground,
              ),
            ],
          ),
          Spacer(),
          if (pending)
            FossChip(
              style: FossChipStyle(
                backgroundColor: WidgetStateProperty.all(
                  tokens.colors.warningLight,
                ),
                side: BorderSide(color: tokens.colors.warning),
              ),
              label: BrandText.label(
                'Pending',
                color: tokens.colors.warningLightForeground,
              ),
            ),
        ],
      ),
      content: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .end,
        spacing: tokens.spacing.unit * 4,
        children: [
          Expanded(
            child: FutureBuilder<List<OrderItemsTableData>>(
              future: orderItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BrandText.caption(
                    '',
                    color: tokens.colors.secondaryForeground,
                  );
                } else if (snapshot.hasError) {
                  return BrandText.caption(
                    'Error loading items',
                    color: tokens.colors.secondaryForeground,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return BrandText.caption(
                    'No items',
                    color: tokens.colors.secondaryForeground,
                  );
                } else {
                  final items = snapshot.data ?? [];
                  return Wrap(
                    spacing: tokens.spacing.unit * 2,
                    runSpacing: tokens.spacing.unit * 2,
                    children: [
                      ...items.map(
                        (item) => FossChip(
                          style: FossChipStyle(
                            backgroundColor: WidgetStateProperty.all(
                              tokens.colors.accentLight,
                            ),
                            side: BorderSide(color: tokens.colors.accent),
                          ),
                          label: BrandText.caption(
                            '₹${item.price}x${item.quantity} • ${item.itemName}',
                            color: tokens.colors.accentLightForeground,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandText.caption(
                'AMOUNT',
                color: tokens.colors.secondaryForeground,
              ),
              BrandText.subtitle('₹$amount', color: tokens.colors.foreground),
            ],
          ),
        ],
      ),
      footer: Row(
        mainAxisAlignment: .end,
        mainAxisSize: .max,
        children: [
          pending
              ? FossButton(
                  semanticLabel: 'Mark Order as Paid',
                  size: .lg,
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                    size: tokens.spacing.unit * 6,
                  ),
                  onPressed: onSettle,
                  child: Text(
                    'Mark as Paid',
                    style: tokens.typography.base.copyWith(
                      color: tokens.colors.background,
                    ),
                  ),
                )
              : FossChip(
                  style: FossChipStyle(
                    backgroundColor: WidgetStateProperty.all(
                      tokens.colors.success,
                    ),
                    side: BorderSide(color: tokens.colors.success),
                  ),
                  label: BrandText.label(
                    'Paid via ${paymentMethod?.toUpperCase() ?? 'Unknown'}',
                    color: tokens.colors.successForeground,
                  ),
                ),
        ],
      ),
    );
    // return DecoratedBox(
    //   decoration: BoxDecoration(
    //     color: tokens.colors.background,
    //     border: Border.all(color: tokens.colors.border),
    //     borderRadius: BorderRadius.circular(tokens.radii.md),
    //   ),
    //   child: Padding(
    //     padding: EdgeInsets.all(tokens.spacing.unit * 2),
    //     child: ConstrainedBox(
    //       constraints: const BoxConstraints(minHeight: 140),
    //       child: Column(
    //         mainAxisAlignment: .spaceBetween,
    //         crossAxisAlignment: .end,
    //         spacing: tokens.spacing.unit * 4,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             spacing: tokens.spacing.unit * 2,
    //             children: [
    //               DecoratedBox(
    //                 decoration: BoxDecoration(
    //                   color: pending
    //                       ? tokens.colors.warning
    //                       : tokens.colors.success,
    //                   borderRadius: BorderRadius.circular(6),
    //                 ),
    //                 child: Padding(
    //                   padding: EdgeInsets.all(tokens.spacing.unit * 2),
    //                   child: HugeIcon(
    //                     icon: HugeIcons.strokeRoundedUserSquare,
    //                     size: tokens.spacing.unit * 6,
    //                     color: pending
    //                         ? tokens.colors.warningForeground
    //                         : tokens.colors.successForeground,
    //                   ),
    //                 ),
    //               ),
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: .start,
    //                 children: [
    //                   BrandText.title(customer),
    //                   BrandText.caption(
    //                     timeAgoString(createdAt ?? DateTime.now()),
    //                     color: tokens.colors.secondaryForeground,
    //                   ),
    //                 ],
    //               ),
    //               Spacer(),
    //               FossChip(
    //                 style: FossChipStyle(
    //                   backgroundColor: WidgetStateProperty.all(
    //                     pending
    //                         ? tokens.colors.warningLight
    //                         : tokens.colors.successLight,
    //                   ),
    //                   side: BorderSide(
    //                     color: pending
    //                         ? tokens.colors.warning
    //                         : tokens.colors.success,
    //                   ),
    //                 ),
    //                 label: FossText.label(pending ? 'Pending' : 'Paid'),
    //               ),
    //             ],
    //           ),
    //           FossSeparator(),
    //           Row(
    //             mainAxisAlignment: .spaceBetween,
    //             crossAxisAlignment: .start,
    //             children: [
    //               FutureBuilder<List<OrderItemsTableData>>(
    //                 future: orderItemsFuture,
    //                 builder: (context, snapshot) {
    //                   if (snapshot.connectionState == ConnectionState.waiting) {
    //                     return BrandText.caption(
    //                       '',
    //                       color: tokens.colors.secondaryForeground,
    //                     );
    //                   } else if (snapshot.hasError) {
    //                     return BrandText.caption(
    //                       'Error loading items',
    //                       color: tokens.colors.secondaryForeground,
    //                     );
    //                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //                     return BrandText.caption(
    //                       'No items',
    //                       color: tokens.colors.secondaryForeground,
    //                     );
    //                   } else {
    //                     final items = snapshot.data ?? [];
    //                     return Column(
    //                       mainAxisAlignment: .start,
    //                       crossAxisAlignment: .start,
    //                       children: [
    //                         BrandText.caption(
    //                           'ITEMS',
    //                           color: tokens.colors.secondaryForeground,
    //                         ),
    //                         Wrap(
    //                           crossAxisAlignment: .end,
    //                           children: [
    //                             ...items.map(
    //                               (item) => BrandText.caption(
    //                                 '${item.quantity} x ${item.itemName}, ',
    //                                 color: tokens.colors.foreground,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     );
    //                   }
    //                 },
    //               ),

    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   BrandText.caption(
    //                     'AMOUNT',
    //                     color: tokens.colors.secondaryForeground,
    //                   ),
    //                   BrandText.subtitle(
    //                     '₹$amount',
    //                     color: tokens.colors.foreground,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),

    //           if (pending)
    //             FossButton(
    //               semanticLabel: 'Mark Order as Paid',
    //               size: .lg,
    //               leading: HugeIcon(
    //                 icon: HugeIcons.strokeRoundedCheckmarkCircle01,
    //                 size: tokens.spacing.unit,
    //               ),
    //               onPressed: onSettle,
    //               child: Text(
    //                 'Mark as Paid',
    //                 style: tokens.typography.base.copyWith(
    //                   color: tokens.colors.background,
    //                 ),
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class MinimalOrderStatusCard extends StatelessWidget {
  const MinimalOrderStatusCard({
    super.key,
    required this.customer,
    required this.amount,
    this.itemCount = 0,
    this.status = OrderStatus.pending,
    this.onSettle,
    this.onViewDetails,
  });

  final String customer;
  final String amount;
  final int itemCount;
  final OrderStatus status;
  final VoidCallback? onSettle;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    final pending = (status == OrderStatus.pending);
    return GestureDetector(
      onTap: onViewDetails,
      child: SizedBox(
        width: 240,
        height: 160,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.colors.card,
            border: Border.all(color: tokens.colors.border),
            borderRadius: BorderRadius.circular(tokens.radii.md),
          ),
          child: Padding(
            padding: EdgeInsets.all(tokens.spacing.unit * 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BrandText.title(
                              customer,
                              color: tokens.colors.foreground,
                            ),
                            BrandText.caption(
                              '$itemCount items',
                              color: tokens.colors.mutedForeground,
                            ),
                          ],
                        ),
                      ),
                      FossChip(
                        style: FossChipStyle(
                          backgroundColor: WidgetStateProperty.all(
                            pending
                                ? tokens.colors.warningLight
                                : tokens.colors.successLight,
                          ),
                          side: BorderSide(
                            color: pending
                                ? tokens.colors.warning
                                : tokens.colors.success,
                          ),
                        ),
                        label: BrandText.caption(
                          pending ? 'Pending' : 'Paid',
                          color: pending
                              ? tokens.colors.warningLightForeground
                              : tokens.colors.successLightForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BrandText.caption(
                          'AMOUNT',
                          color: tokens.colors.mutedForeground,
                        ),
                        BrandText.title(
                          '₹$amount',
                          color: tokens.colors.foreground,
                        ),
                      ],
                    ),
                    if (pending)
                      FossButton(
                        size: .lg,
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                          size: tokens.spacing.unit * 6,
                          color: tokens.colors.primaryForeground,
                        ),
                        onPressed: onSettle,
                        child: BrandText.title(
                          'Paid',
                          color: tokens.colors.primaryForeground,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartReviewButton extends StatelessWidget {
  const CartReviewButton({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onReview,
  });

  final int itemCount;
  final int total;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tokens = context.fossTheme;
    return GestureDetector(
      onTap: onReview,
      child: SizedBox(
        height: tokens.spacing.unit * 18,
        width: width - (tokens.spacing.unit * 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.colors.card,
            border: Border.all(color: tokens.colors.border),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: tokens.colors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FossText.label('$itemCount items'),
                    const SizedBox(width: 8),
                    FossText.body('•', color: .mutedForeground),
                    const SizedBox(width: 8),
                    FossText.title('₹$total', color: .foreground),
                  ],
                ),
                FossButton(
                  onPressed: onReview,
                  size: .lg,
                  semanticLabel: 'Review Cart',
                  style: FossButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      tokens.colors.success,
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      tokens.colors.successForeground,
                    ),
                    side: BorderSide(color: tokens.colors.success),
                    borderRadius: 999,
                  ),
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight02,
                    size: tokens.spacing.unit * 6,
                  ),
                  child: FossText.label(
                    'Review',
                    style: tokens.typography.base.copyWith(
                      color: tokens.colors.successForeground,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.total,
    this.tax,
    this.onCheckout,
  });

  final String subtotal;
  final String total;
  final String? tax;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return Container(
      padding: EdgeInsets.all(tokens.spacing.unit),
      decoration: BoxDecoration(
        color: tokens.colors.background,
        border: Border.all(color: tokens.colors.muted),
        borderRadius: BorderRadius.circular(tokens.radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _line(tokens, 'Subtotal', subtotal),
          if (tax != null) ...[
            const SizedBox(height: 8),
            _line(tokens, 'Tax', tax!),
          ],
          const SizedBox(height: 16),
          FossSeparator(decorative: true),
          const SizedBox(height: 12),
          _line(tokens, 'Total', total, strong: true),
          if (onCheckout != null) ...[
            const SizedBox(height: 16),
            FossButton(onPressed: onCheckout, child: const Text('Checkout')),
          ],
        ],
      ),
    );
  }

  Widget _line(
    FossThemeData tokens,
    String label,
    String value, {
    bool strong = false,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: tokens.typography.base.copyWith(
          height: strong ? 24 : 20,
          color: tokens.colors.foreground,
        ),
      ),
      Text(
        value,
        style: tokens.typography.base.copyWith(
          height: strong ? 24 : 20,
          color: tokens.colors.foreground,
        ),
      ),
    ],
  );
}

class BrandTopBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandTopBar({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final currentRouteName = ModalRoute.of(context)?.settings.name;
    context.loggerService.info('Current route name: $currentRouteName');
    final tokens = context.fossTheme;
    return WidgetAppBar(
      actionsPadding: EdgeInsets.symmetric(horizontal: tokens.spacing.unit),
      foregroundColor: tokens.colors.foreground,
      shape: Border(bottom: BorderSide(color: tokens.colors.border)),
      title: FossText.title(title, color: .primary),
      leading: leading,
      actions: [...actions],
      backgroundColor: tokens.colors.background,
    );
  }
}

enum BrandTextVariant {
  display,
  heading,
  title,
  subtitle,
  body,
  label,
  caption,
}

class BrandText extends StatelessWidget {
  const BrandText.display(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.maxLines = 4,
  }) : variant = BrandTextVariant.display;
  const BrandText.heading(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.maxLines = 4,
  }) : variant = BrandTextVariant.heading;
  const BrandText.title(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.maxLines = 4,
  }) : variant = BrandTextVariant.title;
  const BrandText.subtitle(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.maxLines = 4,
  }) : variant = BrandTextVariant.subtitle;
  const BrandText.body(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.maxLines = 4,
  }) : variant = BrandTextVariant.body;
  const BrandText.label(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.maxLines = 4,
  }) : variant = BrandTextVariant.label;
  const BrandText.caption(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.maxLines = 4,
  }) : variant = BrandTextVariant.caption;

  final String text;
  final Color? color;
  final double? size;
  final BrandTextVariant variant;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme.typography;
    final colors = context.fossTheme.colors;
    return Text(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text,
      style: switch (variant) {
        BrandTextVariant.display => tokens.xl2.copyWith(
          color: color ?? colors.foreground,
          fontSize: size,
          height: 1.2,
          fontWeight: FossTextWeight.bold.value,
        ),
        BrandTextVariant.heading => tokens.xl.copyWith(
          color: color ?? colors.foreground,
          fontSize: size,
          height: 1.2,
          fontWeight: FossTextWeight.semibold.value,
        ),
        BrandTextVariant.title => tokens.lg.copyWith(
          color: color ?? colors.foreground,
          fontSize: size,
          height: 1.2,
          fontWeight: FossTextWeight.semibold.value,
        ),
        BrandTextVariant.subtitle => tokens.lg.copyWith(
          color: color,
          fontSize: size,
          height: 1.2,
          fontWeight: FossTextWeight.medium.value,
        ),
        BrandTextVariant.label => tokens.base.copyWith(
          color: color ?? colors.foreground,
          fontSize: size,
          height: 1.2,
          fontWeight: FossTextWeight.medium.value,
        ),
        BrandTextVariant.body => tokens.sm.copyWith(
          color: color ?? colors.foreground,
          fontSize: size,
          height: 1.2,
          fontWeight: FossTextWeight.regular.value,
        ),
        BrandTextVariant.caption => tokens.xs.copyWith(
          color: color ?? colors.foreground,
          fontSize: size,
          height: 1.2,
          fontWeight: FossTextWeight.regular.value,
        ),
      },
    );
  }
}

enum BrandTypographyVariant {
  display,
  heading,
  title,
  subtitle,
  body,
  small,
  label,
}

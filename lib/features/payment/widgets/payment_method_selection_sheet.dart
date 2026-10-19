import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:movo/core/components/components.dart';
import 'package:movo/data/database/tables/order_table.dart';

class PaymentMethodSelectionSheet extends StatelessWidget {
  const PaymentMethodSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.fossTheme;
    return FossDrawer(
      showHandle: true,
      title: const BrandText.subtitle('Select Payment Method'),
      content: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          ...PaymentMethod.values.map(
            (method) => GestureDetector(
              onTap: () {
                Navigator.pop(context, method);
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.colors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(tokens.spacing.unit * 8),
                  child: Column(
                    mainAxisSize: .min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: _iconFor(method),
                        color: tokens.colors.foreground,
                        size: tokens.spacing.unit * 6,
                      ),
                      const SizedBox(height: 4),
                      BrandText.subtitle(_labelFor(method)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<List<dynamic>> _iconFor(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => HugeIcons.strokeRoundedCash01,
      PaymentMethod.upi => HugeIcons.strokeRoundedQrCode,
      PaymentMethod.card => HugeIcons.strokeRoundedCreditCard,
    };
  }

  String _labelFor(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'Cash',
      PaymentMethod.upi => 'UPI',
      PaymentMethod.card => 'Card',
    };
  }
}

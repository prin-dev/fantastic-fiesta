import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/export/native_download.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/utils/formatter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelExportService {
  ExcelExportService({required this.loggerService});

  final NumberFormat _currencyFormat = NumberFormat('#,##0.00');
  final LoggerService loggerService;

  /// Exports paid orders to CSV format
  /// Returns the path to the created CSV file
  Future<String> exportPaidOrders(
    List<OrderTableData> orders,
    Map<String, List<OrderItemsTableData>> orderItemsMap,
  ) async {
    try {
      // Prepare CSV data
      List<List<dynamic>> rows = [];

      // Add header row
      rows.add([
        'Datetime',
        'Customer',
        'Items',
        'Quantity',
        'Total',
        'Payment Method',
      ]);

      // Add data rows - separate row for each item
      for (final order in orders) {
        final items = orderItemsMap[order.id] ?? [];

        loggerService.info(
          'Processing order ${order.id} with ${items.length} items',
        );

        rows.add([
          timeDateString(order.paidAt ?? order.createdAt),
          order.customerAlias ?? 'Guest',
          items.map((item) => '${item.itemName}x${item.quantity}').join(', '),
          items.fold<int>(0, (sum, item) => sum + item.quantity),
          _currencyFormat.format(
            items.fold<double>(0, (sum, item) => sum + item.subtotal),
          ),
          _formatPaymentMethod(order.paymentMethod),
        ]);
      }

      // Add footer row with total orders and total amount
      final totalOrders = orders.length;
      final totalAmount = orders.fold<double>(
        0.0,
        (sum, order) => sum + (order.total),
      );
      rows.add([]);

      rows.add([
        '',
        '',
        '',
        'Total Orders: $totalOrders',
        'Grand Total: ${_currencyFormat.format(totalAmount)}',
        '',
      ]);

      loggerService.info('Rows to be exported: $rows');

      // Convert to CSV string
      String csv = const CsvEncoder(fieldDelimiter: ',').convert(rows);
      // final String excelCsv = excel.encode(rows);

      // Save to file
      final downloadsDir = await getExternalStorageDirectory();

      if (downloadsDir == null) {
        throw FlutterError('Unable to access downloads directory');
      }

      loggerService.info('Downloads directory: ${downloadsDir.path}');

      final directory = downloadsDir;

      final currentDateTime = DateTime.now();

      final filename =
          'movo_transactions_${currentDateTime.year}-${currentDateTime.month}-${currentDateTime.day}_${timeString(currentDateTime).replaceFirst(':', '-')}.csv';
      final filePath = p.join(directory.path, filename);

      // Use the built-in excel codec
      final file = File(filePath);

      // print('Exporting to file: $filePath');
      final savedFile = await file.writeAsString(csv);

      final success = await NativeDownloader.saveFile(
        bytes: savedFile.readAsBytesSync(),
        fileName: filename,
        mimeType: "text/csv",
      );

      loggerService.info(
        'File saved successfully to public Downloads! $success',
      );
      loggerService.info(
        'Exported ${orders.length} orders to $filePath as file #${file.path}',
      );

      return filePath;
    } catch (e) {
      throw Exception('Failed to export orders: $e');
    }
  }

  /// Shares the export file using the device's share functionality
  Future<void> shareExport(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Export file not found');
      }

      final xFile = XFile(filePath);
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          subject: 'Movo Transactions Export',
          text:
              'Transaction export created on ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
        ),
      );
    } catch (e) {
      throw Exception('Failed to share export: $e');
    }
  }

  /// Formats payment method for display
  String _formatPaymentMethod(String? method) {
    if (method == null || method.isEmpty) return 'N/A';
    return method.toUpperCase();
  }
}

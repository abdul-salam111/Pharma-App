import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/routes/app_pages.dart';
import '../controllers/orders_summary_controller.dart';

class OrdersSummaryView extends GetView<OrdersSummaryController> {
  const OrdersSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders Summary'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildOrderTable(context),
      ),
    );
  }

  Widget _buildOrderTable(BuildContext context) {
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(color: Colors.grey, width: 0.5),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5), // Date
        1: FlexColumnWidth(1), // Synced
        2: FlexColumnWidth(1), // Orders
        3: FlexColumnWidth(1), // Amount
      },
      children: [_buildTableHeader(context), ..._buildTableRows(context)],
    );
  }

  TableRow _buildTableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[200]),
      children: [
        _buildHeaderCell("Date",leftPadding: 12, context: context),
        _buildHeaderCell("Synced", context: context),
        _buildHeaderCell("Orders", context: context),
        _buildHeaderCell("Amount", context: context),
      ],
    );
  }

  Widget _buildHeaderCell(
    String text, {
    double leftPadding = 0,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8, left: leftPadding),
      child: text != "Date"
          ? Center(
              child: Text(
                text,
                style: context.bodySmallStyle!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Text(
              text,
              style: context.bodySmallStyle!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  List<TableRow> _buildTableRows(BuildContext context) {
    return List.generate(3, (index) {
      return TableRow(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.white : Colors.grey[50],
        ),
        children: [
          _buildClickableCell("04 Aug 2015", index, context),
          _buildClickableCell("No", index, context),
          _buildClickableCell("15", index, context),
          _buildClickableCell("12600", index, context),
        ],
      );
    });
  }

  Widget _buildClickableCell(String text, int rowIndex, BuildContext context) {
    return InkWell(
      onTap: () => _handleRowTap(rowIndex),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            text,
            style: context.bodySmallStyle!.copyWith(
              color: AppColors.greyTextColor,
            ),
          ),
        ),
      ),
    );
  }

  void _handleRowTap(int index) {
    Get.toNamed(Routes.ORDERS_ON_DATE);
    // You can pass data like:
    // Get.toNamed(Routes.ORDERS_ON_DATE, arguments: {'rowIndex': index});
  }
}

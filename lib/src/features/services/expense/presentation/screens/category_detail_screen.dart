import 'package:flutter/material.dart';

import '../../../../../core/config/theme/app_color/color_palette.dart';
import '../../../../../core/config/theme/styles/styles.dart';
import '../../../../../core/view/component/base/custom_app_bar.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

class CategoryDetailScreen extends StatefulWidget {
  final ExpenseCategory initialCategory;
  final List<ExpenseEntity> allExpenses;
  final Map<ExpenseCategory, double> expensesByCategory;

  const CategoryDetailScreen({
    super.key,
    required this.initialCategory,
    required this.allExpenses,
    required this.expensesByCategory,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late ExpenseCategory _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// Only categories that have expenses
  late final List<ExpenseCategory> _activeCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _activeCategories = ExpenseCategory.values
        .where((c) => (widget.expensesByCategory[c] ?? 0) > 0)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExpenseEntity> get _filteredExpenses {
    var expenses = widget.allExpenses
        .where((e) => e.category == _selectedCategory)
        .toList();

    if (_searchQuery.isNotEmpty) {
      expenses = expenses
          .where(
            (e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Sort by date descending
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.white,
      appBar: const CustomAppBar(
        title: 'Expenses Details',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Category Tabs
          _buildCategoryTabs(),
          const SizedBox(height: 16),

          // Search Bar
          _buildSearchBar(context),
          const SizedBox(height: 8),

          // Expense List
          Expanded(child: _buildExpenseList(context)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _activeCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _activeCategories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _searchController.clear();
                _searchQuery = '';
              });
            },
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorPalette.primary.withValues(alpha: 0.06)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? ColorPalette.primary
                      : ColorPalette.gray10,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category.icon,
                    color: isSelected
                        ? ColorPalette.primary
                        : ColorPalette.gray50,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.name,
                    style: TextStyles.f12(context).copyWith(
                      color: isSelected
                          ? ColorPalette.primary
                          : ColorPalette.gray50,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorPalette.gray10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.search, color: ColorPalette.gray50, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search for ${_selectedCategory.name.toLowerCase()}',
                  hintStyle: TextStyles.f14(context).copyWith(
                    color: ColorPalette.gray50,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                style: TextStyles.f14(context),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.tune_rounded,
                color: ColorPalette.primary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList(BuildContext context) {
    final expenses = _filteredExpenses;

    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: ColorPalette.gray50.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No results found'
                  : 'No expenses in this category',
              style: TextStyles.f16(context).copyWith(
                color: ColorPalette.gray50,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: expenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _ExpenseDetailItem(
          expense: expenses[index],
          category: _selectedCategory,
        );
      },
    );
  }
}

class _ExpenseDetailItem extends StatelessWidget {
  final ExpenseEntity expense;
  final ExpenseCategory category;

  const _ExpenseDetailItem({
    required this.expense,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorPalette.gray10),
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(category.icon, color: category.color, size: 22),
          ),
          const SizedBox(width: 12),

          // Name & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.name,
                  style: TextStyles.f16(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(expense.date),
                  style: TextStyles.f12(context).copyWith(
                    color: ColorPalette.gray50,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: TextStyles.f16(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}

/// API Endpoints for the Finance Assistant app
class ApiEndpoints {
  ApiEndpoints._();

  // Expense endpoints
  static const String expensesOverview = '/expenses/overview';
  static const String expensesCategoriesBreakdown =
      '/expenses/categories/breakdown';
  static const String expensesDonutChart = '/expenses/charts/donut';
  static const String expenses = '/expenses';

  // Category endpoints
  static const String categories = '/categories';

  // Bill endpoints
  static const String bills = '/bills';
  static const String billsSmartParse = '/bills/smart-parse';

  static const String budgets = '/budgets';
  static const String chartData = '/ai/suggest-budget';
  static const String suggestBudget = '/ai/suggest-budget';
}

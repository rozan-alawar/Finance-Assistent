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

  // Budget & AI endpoints
  static const String budgets = '/budgets';
  static const String budgetSummary = '/budgets/summary';
  static const String suggestBudget = '/ai/suggest-budget';
  static const String aiChat = '/ai/chat';

  // Debts & Income endpoints
  static const String debtsSummary = '/debts/summary';
}

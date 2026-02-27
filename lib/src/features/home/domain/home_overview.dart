import 'package:equatable/equatable.dart';

class HomeOverview extends Equatable {
  final OverviewUser user;
  final OverviewCurrency currency;
  final OverviewBalance balance;
  final OverviewExpenseDue expenseDue;
  final List<dynamic> attentionNeeded;

  const HomeOverview({
    required this.user,
    required this.currency,
    required this.balance,
    required this.expenseDue,
    required this.attentionNeeded,
  });

  factory HomeOverview.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? map;
    return HomeOverview(
      user: OverviewUser.fromMap(data['user'] as Map<String, dynamic>),
      currency: OverviewCurrency.fromMap(data['currency'] as Map<String, dynamic>),
      balance: OverviewBalance.fromMap(data['balance'] as Map<String, dynamic>),
      expenseDue: OverviewExpenseDue.fromMap(data['expenseDue'] as Map<String, dynamic>),
      attentionNeeded: (data['attentionNeeded'] as List<dynamic>? ?? const []),
    );
  }

  @override
  List<Object?> get props => [user, currency, balance, expenseDue, attentionNeeded];
}

class OverviewUser extends Equatable {
  final String id;
  final String fullName;
  final String? avatarUrl;

  const OverviewUser({required this.id, required this.fullName, this.avatarUrl});

  factory OverviewUser.fromMap(Map<String, dynamic> map) {
    return OverviewUser(
      id: map['id']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      avatarUrl: map['avatarUrl']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, fullName, avatarUrl];
}

class OverviewCurrency extends Equatable {
  final String id;
  final String code;
  final String symbol;
  final String name;

  const OverviewCurrency({
    required this.id,
    required this.code,
    required this.symbol,
    required this.name,
  });

  factory OverviewCurrency.fromMap(Map<String, dynamic> map) {
    return OverviewCurrency(
      id: map['id']?.toString() ?? '',
      code: map['code']?.toString() ?? '',
      symbol: map['symbol']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, code, symbol, name];
}

class OverviewBalance extends Equatable {
  final String current;

  const OverviewBalance({required this.current});

  factory OverviewBalance.fromMap(Map<String, dynamic> map) {
    return OverviewBalance(current: map['current']?.toString() ?? '0');
  }

  @override
  List<Object?> get props => [current];
}

class OverviewExpenseDue extends Equatable {
  final String amount;
  final String periodLabel;
  final String startDate;
  final String endDate;

  const OverviewExpenseDue({
    required this.amount,
    required this.periodLabel,
    required this.startDate,
    required this.endDate,
  });

  factory OverviewExpenseDue.fromMap(Map<String, dynamic> map) {
    return OverviewExpenseDue(
      amount: map['amount']?.toString() ?? '0',
      periodLabel: map['periodLabel']?.toString() ?? '',
      startDate: map['startDate']?.toString() ?? '',
      endDate: map['endDate']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [amount, periodLabel, startDate, endDate];
}

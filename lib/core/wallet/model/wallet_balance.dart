import 'package:isar/isar.dart';

part 'wallet_balance.g.dart';

/// Wallet balance model for storing Lightning Network balance
@collection
class WalletBalance {
  Id id = Isar.autoIncrement;

  /// Total balance in satoshis
  int totalBalance;

  /// Confirmed balance in satoshis
  int confirmedBalance;

  /// Unconfirmed balance in satoshis
  int unconfirmedBalance;

  /// Reserved balance in satoshis (for pending transactions)
  int reservedBalance;

  /// Last updated timestamp
  int lastUpdated;

  /// Wallet identifier
  String walletId;

  WalletBalance({
    this.totalBalance = 0,
    this.confirmedBalance = 0,
    this.unconfirmedBalance = 0,
    this.reservedBalance = 0,
    this.lastUpdated = 0,
    this.walletId = '',
  });

  /// Create from JSON map
  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      totalBalance: json['total_balance'] ?? 0,
      confirmedBalance: json['confirmed_balance'] ?? 0,
      unconfirmedBalance: json['unconfirmed_balance'] ?? 0,
      reservedBalance: json['reserved_balance'] ?? 0,
      lastUpdated: json['last_updated'] ?? 0,
      walletId: json['wallet_id'] ?? '',
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'total_balance': totalBalance,
      'confirmed_balance': confirmedBalance,
      'unconfirmed_balance': unconfirmedBalance,
      'reserved_balance': reservedBalance,
      'last_updated': lastUpdated,
      'wallet_id': walletId,
    };
  }

  /// Get balance in BTC (satoshi / 100,000,000)
  double get totalBalanceBTC => totalBalance / 100000000;
  double get confirmedBalanceBTC => confirmedBalance / 100000000;
  double get unconfirmedBalanceBTC => unconfirmedBalance / 100000000;
  double get reservedBalanceBTC => reservedBalance / 100000000;

  /// Check if balance is zero
  bool get isEmpty => totalBalance == 0;

  /// Update balance with new values
  void updateBalance({
    int? totalBalance,
    int? confirmedBalance,
    int? unconfirmedBalance,
    int? reservedBalance,
  }) {
    this.totalBalance = totalBalance ?? this.totalBalance;
    this.confirmedBalance = confirmedBalance ?? this.confirmedBalance;
    this.unconfirmedBalance = unconfirmedBalance ?? this.unconfirmedBalance;
    this.reservedBalance = reservedBalance ?? this.reservedBalance;
    lastUpdated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// Copy with new values
  WalletBalance copyWith({
    int? totalBalance,
    int? confirmedBalance,
    int? unconfirmedBalance,
    int? reservedBalance,
    int? lastUpdated,
    String? walletId,
  }) {
    return WalletBalance(
      totalBalance: totalBalance ?? this.totalBalance,
      confirmedBalance: confirmedBalance ?? this.confirmedBalance,
      unconfirmedBalance: unconfirmedBalance ?? this.unconfirmedBalance,
      reservedBalance: reservedBalance ?? this.reservedBalance,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      walletId: walletId ?? this.walletId,
    );
  }

  @override
  String toString() {
    return 'WalletBalance(totalBalance: $totalBalance, confirmedBalance: $confirmedBalance, unconfirmedBalance: $unconfirmedBalance, reservedBalance: $reservedBalance, lastUpdated: $lastUpdated, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletBalance &&
        other.totalBalance == totalBalance &&
        other.confirmedBalance == confirmedBalance &&
        other.unconfirmedBalance == unconfirmedBalance &&
        other.reservedBalance == reservedBalance &&
        other.lastUpdated == lastUpdated &&
        other.walletId == walletId;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalBalance,
      confirmedBalance,
      unconfirmedBalance,
      reservedBalance,
      lastUpdated,
      walletId,
    );
  }
}

import 'package:isar/isar.dart';

part 'wallet_info.g.dart';

/// Wallet info model for storing Lightning Network wallet information
@collection
class WalletInfo {
  Id id = Isar.autoIncrement;
  /// Wallet identifier
  @Index(unique: true, replace: true)
  String walletId;

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

  /// Nostr public key
  String pubkey;

  /// LNbits server URL
  String lnbitsUrl;

  /// LNbits admin API key
  String adminKey;

  /// LNbits invoice API key
  String invoiceKey;

  /// LNbits read API key
  String readKey;

  /// User ID in LNbits
  String lnbitsUserId;

  /// Username in LNbits
  String lnbitsUsername;

  WalletInfo({
    this.totalBalance = 0,
    this.confirmedBalance = 0,
    this.unconfirmedBalance = 0,
    this.reservedBalance = 0,
    this.lastUpdated = 0,
    this.walletId = '',
    this.pubkey = '',
    this.lnbitsUrl = '',
    this.adminKey = '',
    this.invoiceKey = '',
    this.readKey = '',
    this.lnbitsUserId = '',
    this.lnbitsUsername = '',
  });

  /// Create from JSON map
  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      totalBalance: json['total_balance'] ?? 0,
      confirmedBalance: json['confirmed_balance'] ?? 0,
      unconfirmedBalance: json['unconfirmed_balance'] ?? 0,
      reservedBalance: json['reserved_balance'] ?? 0,
      lastUpdated: json['last_updated'] ?? 0,
      walletId: json['wallet_id'] ?? '',
      pubkey: json['pubkey'] ?? '',
      lnbitsUrl: json['lnbits_url'] ?? '',
      adminKey: json['admin_key'] ?? '',
      invoiceKey: json['invoice_key'] ?? '',
      readKey: json['read_key'] ?? '',
      lnbitsUserId: json['lnbits_user_id'] ?? '',
      lnbitsUsername: json['lnbits_username'] ?? '',
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
      'pubkey': pubkey,
      'lnbits_url': lnbitsUrl,
      'admin_key': adminKey,
      'invoice_key': invoiceKey,
      'read_key': readKey,
      'lnbits_user_id': lnbitsUserId,
      'lnbits_username': lnbitsUsername,
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

  /// Update wallet info with new values
  void updateInfo({
    String? pubkey,
    String? lnbitsUrl,
    String? adminKey,
    String? invoiceKey,
    String? readKey,
    String? lnbitsUserId,
    String? lnbitsUsername,
  }) {
    this.pubkey = pubkey ?? this.pubkey;
    this.lnbitsUrl = lnbitsUrl ?? this.lnbitsUrl;
    this.adminKey = adminKey ?? this.adminKey;
    this.invoiceKey = invoiceKey ?? this.invoiceKey;
    this.readKey = readKey ?? this.readKey;
    this.lnbitsUserId = lnbitsUserId ?? this.lnbitsUserId;
    this.lnbitsUsername = lnbitsUsername ?? this.lnbitsUsername;
    lastUpdated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// Copy with new values
  WalletInfo copyWith({
    int? totalBalance,
    int? confirmedBalance,
    int? unconfirmedBalance,
    int? reservedBalance,
    int? lastUpdated,
    String? walletId,
    String? pubkey,
    String? lnbitsUrl,
    String? adminKey,
    String? invoiceKey,
    String? readKey,
    String? lnbitsUserId,
    String? lnbitsUsername,
  }) {
    return WalletInfo(
      totalBalance: totalBalance ?? this.totalBalance,
      confirmedBalance: confirmedBalance ?? this.confirmedBalance,
      unconfirmedBalance: unconfirmedBalance ?? this.unconfirmedBalance,
      reservedBalance: reservedBalance ?? this.reservedBalance,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      walletId: walletId ?? this.walletId,
      pubkey: pubkey ?? this.pubkey,
      lnbitsUrl: lnbitsUrl ?? this.lnbitsUrl,
      adminKey: adminKey ?? this.adminKey,
      invoiceKey: invoiceKey ?? this.invoiceKey,
      readKey: readKey ?? this.readKey,
      lnbitsUserId: lnbitsUserId ?? this.lnbitsUserId,
      lnbitsUsername: lnbitsUsername ?? this.lnbitsUsername,
    );
  }

  @override
  String toString() {
    return 'WalletInfo(totalBalance: $totalBalance, confirmedBalance: $confirmedBalance, unconfirmedBalance: $unconfirmedBalance, reservedBalance: $reservedBalance, lastUpdated: $lastUpdated, walletId: $walletId, pubkey: $pubkey, lnbitsUrl: $lnbitsUrl, adminKey: $adminKey, invoiceKey: $invoiceKey, readKey: $readKey, lnbitsUserId: $lnbitsUserId, lnbitsUsername: $lnbitsUsername)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletInfo &&
        other.totalBalance == totalBalance &&
        other.confirmedBalance == confirmedBalance &&
        other.unconfirmedBalance == unconfirmedBalance &&
        other.reservedBalance == reservedBalance &&
        other.lastUpdated == lastUpdated &&
        other.walletId == walletId &&
        other.pubkey == pubkey &&
        other.lnbitsUrl == lnbitsUrl &&
        other.adminKey == adminKey &&
        other.invoiceKey == invoiceKey &&
        other.readKey == readKey &&
        other.lnbitsUserId == lnbitsUserId &&
        other.lnbitsUsername == lnbitsUsername;
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
      pubkey,
      lnbitsUrl,
      adminKey,
      invoiceKey,
      readKey,
      lnbitsUserId,
      lnbitsUsername,
    );
  }
}

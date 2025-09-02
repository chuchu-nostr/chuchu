import 'package:isar/isar.dart';

part 'wallet_info.g.dart';

/// Wallet info model for storing Lightning Network wallet information
@collection
class WalletInfo {
  Id id = Isar.autoIncrement;
  /// Wallet identifier
  @Index(unique: true, replace: false)
  String walletId;

  /// Nostr Wallet Connect URI
  @Index(unique: true, replace: true)
  String nwcUri;

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

  /// Secret key for authentication
  String secret;

  /// Relay URL for Nostr connection
  String relay;

  WalletInfo({
    this.totalBalance = 0,
    this.confirmedBalance = 0,
    this.unconfirmedBalance = 0,
    this.reservedBalance = 0,
    this.lastUpdated = 0,
    this.walletId = '',
    this.pubkey = '',
    this.nwcUri = '',
    this.secret = '',
    this.relay = '',
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
      nwcUri: json['nwc_uri'] ?? '',
      secret: json['secret'] ?? '',
      relay: json['relay'] ?? '',
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
      'nwc_uri': nwcUri,
      'secret': secret,
      'relay': relay,
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
    String? nwcUri,
    String? secret,
    String? relay,
  }) {
    this.pubkey = pubkey ?? this.pubkey;
    this.nwcUri = nwcUri ?? this.nwcUri;
    this.secret = secret ?? this.secret;
    this.relay = relay ?? this.relay;
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
    String? nwcUri,
    String? secret,
    String? relay,
  }) {
    return WalletInfo(
      totalBalance: totalBalance ?? this.totalBalance,
      confirmedBalance: confirmedBalance ?? this.confirmedBalance,
      unconfirmedBalance: unconfirmedBalance ?? this.unconfirmedBalance,
      reservedBalance: reservedBalance ?? this.reservedBalance,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      walletId: walletId ?? this.walletId,
      pubkey: pubkey ?? this.pubkey,
      nwcUri: nwcUri ?? this.nwcUri,
      secret: secret ?? this.secret,
      relay: relay ?? this.relay,
    );
  }

  @override
  String toString() {
    return 'WalletInfo(totalBalance: $totalBalance, confirmedBalance: $confirmedBalance, unconfirmedBalance: $unconfirmedBalance, reservedBalance: $reservedBalance, lastUpdated: $lastUpdated, walletId: $walletId, pubkey: $pubkey, nwcUri: $nwcUri, secret: $secret, relay: $relay)';
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
        other.nwcUri == nwcUri &&
        other.secret == secret &&
        other.relay == relay;
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
      nwcUri,
      secret,
      relay,
    );
  }
}

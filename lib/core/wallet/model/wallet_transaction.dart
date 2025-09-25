import 'package:isar/isar.dart';

part 'wallet_transaction.g.dart';

/// Transaction status enum
enum TransactionStatus {
  pending,
  confirmed,
  failed,
  expired,
}

/// Transaction type enum
enum TransactionType {
  incoming,
  outgoing,
}

/// Wallet transaction model for storing Lightning Network transactions
@collection
class WalletTransaction {
  Id id = Isar.autoIncrement;

  /// Transaction hash/ID
  @Index(unique: true, replace: true)
  String transactionId;

  /// Transaction type (incoming/outgoing)
  @enumerated
  TransactionType type;

  /// Transaction status
  @enumerated
  TransactionStatus status;

  /// Amount in satoshis
  int amount;

  /// Fee paid in satoshis
  int fee;

  /// Transaction description/memo
  String? description;

  /// Invoice (for incoming payments)
  String? invoice;

  /// Payment hash
  String? paymentHash;

  /// Preimage (for outgoing payments)
  String? preimage;

  /// Timestamp when transaction was created
  int createdAt;

  /// Timestamp when transaction was confirmed
  int? confirmedAt;

  /// Wallet identifier
  String walletId;

  /// Related user pubkey (if applicable)
  String? relatedPubkey;

  WalletTransaction({
    required this.transactionId,
    required this.type,
    required this.status,
    required this.amount,
    this.fee = 0,
    this.description,
    this.invoice,
    this.paymentHash,
    this.preimage,
    required this.createdAt,
    this.confirmedAt,
    required this.walletId,
    this.relatedPubkey,
  });

  /// Create from JSON map
  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    final amount = _parseInt(json['amount']) ?? 0;
    
    return WalletTransaction(
      transactionId: json['transaction_id'] ?? '',
      type: _parseTransactionType(json['type']),
      status: _parseTransactionStatus(json['status']),
      amount: amount,
      fee: _parseInt(json['fee']) ?? 0,
      description: json['description'],
      invoice: json['invoice'],
      paymentHash: json['payment_hash'],
      preimage: json['preimage'],
      createdAt: _parseInt(json['created_at']) ?? 0,
      confirmedAt: _parseInt(json['confirmed_at']),
      walletId: json['wallet_id'] ?? '',
      relatedPubkey: json['related_pubkey'],
    );
  }

  /// Parse integer from dynamic value (handles both int and string)
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'type': type.name,
      'status': status.name,
      'amount': amount,
      'fee': fee,
      'description': description,
      'invoice': invoice,
      'payment_hash': paymentHash,
      'preimage': preimage,
      'created_at': createdAt,
      'confirmed_at': confirmedAt,
      'wallet_id': walletId,
      'related_pubkey': relatedPubkey,
    };
  }

  /// Parse transaction type from string
  static TransactionType _parseTransactionType(String? type) {
    switch (type?.toLowerCase()) {
      case 'incoming':
        return TransactionType.incoming;
      case 'outgoing':
        return TransactionType.outgoing;
      default:
        // For pending transactions without explicit type, 
        // we'll determine type based on amount sign in the UI
        return TransactionType.incoming; // Default to incoming for pending payments
    }
  }

  /// Parse transaction status from string
  static TransactionStatus _parseTransactionStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'confirmed':
        return TransactionStatus.confirmed;
      case 'failed':
        return TransactionStatus.failed;
      case 'expired':
        return TransactionStatus.expired;
      default:
        return TransactionStatus.pending;
    }
  }

  /// Get amount in BTC
  double get amountBTC => amount / 100000000;
  double get feeBTC => fee / 100000000;

  /// Get net amount (amount - fee for outgoing, amount for incoming)
  int get netAmount => type == TransactionType.outgoing ? amount - fee : amount;
  double get netAmountBTC => netAmount / 100000000;

  /// Check if transaction is confirmed
  bool get isConfirmed => status == TransactionStatus.confirmed;

  /// Check if transaction is pending
  bool get isPending => status == TransactionStatus.pending;

  /// Check if transaction failed
  bool get isFailed => status == TransactionStatus.failed;

  /// Check if transaction is expired
  bool get isExpired => status == TransactionStatus.expired;

  /// Check if transaction is incoming
  bool get isIncoming => type == TransactionType.incoming;

  /// Check if transaction is outgoing
  bool get isOutgoing => type == TransactionType.outgoing;

  /// Update transaction status
  void updateStatus(TransactionStatus newStatus) {
    status = newStatus;
    if (newStatus == TransactionStatus.confirmed && confirmedAt == null) {
      confirmedAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
  }

  /// Copy with new values
  WalletTransaction copyWith({
    String? transactionId,
    TransactionType? type,
    TransactionStatus? status,
    int? amount,
    int? fee,
    String? description,
    String? invoice,
    String? paymentHash,
    String? preimage,
    int? createdAt,
    int? confirmedAt,
    String? walletId,
    String? relatedPubkey,
  }) {
    return WalletTransaction(
      transactionId: transactionId ?? this.transactionId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      description: description ?? this.description,
      invoice: invoice ?? this.invoice,
      paymentHash: paymentHash ?? this.paymentHash,
      preimage: preimage ?? this.preimage,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      walletId: walletId ?? this.walletId,
      relatedPubkey: relatedPubkey ?? this.relatedPubkey,
    );
  }

  @override
  String toString() {
    return 'WalletTransaction(transactionId: $transactionId, type: $type, status: $status, amount: $amount, fee: $fee, description: $description, createdAt: $createdAt, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletTransaction &&
        other.transactionId == transactionId &&
        other.type == type &&
        other.status == status &&
        other.amount == amount &&
        other.fee == fee &&
        other.description == description &&
        other.invoice == invoice &&
        other.paymentHash == paymentHash &&
        other.preimage == preimage &&
        other.createdAt == createdAt &&
        other.confirmedAt == confirmedAt &&
        other.walletId == walletId &&
        other.relatedPubkey == relatedPubkey;
  }

  @override
  int get hashCode {
    return Object.hash(
      transactionId,
      type,
      status,
      amount,
      fee,
      description,
      invoice,
      paymentHash,
      preimage,
      createdAt,
      confirmedAt,
      walletId,
      relatedPubkey,
    );
  }
}

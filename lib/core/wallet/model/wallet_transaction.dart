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
  @Id()
  int id = 0;

  /// Transaction hash/ID
  @Index(unique: true)
  String transactionId;

  /// Transaction type (incoming/outgoing)
  TransactionType type;

  /// Transaction status
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
    // LNbits API returns amount in msats (millisatoshis)
    // Need to convert to sats by dividing by 1000
    final amountMsats = _parseInt(json['amount']) ?? 0;
    final amountSats = (amountMsats.abs() ~/ 1000); // Convert msats to sats and make positive
    
    // LNbits API returns ISO 8601 datetime strings, need to parse them
    // Try multiple possible field names for timestamp
    final createdAtValue = _parseTimestamp(json['created_at']) ?? 
                           _parseTimestamp(json['time']) ?? 
                           _parseTimestamp(json['timestamp']) ??
                           _parseTimestamp(json['created']);
    
    // If still no timestamp found, use current time instead of 0
    final createdAt = createdAtValue ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    // Determine transaction type: LNbits returns positive amount for incoming, negative for outgoing
    // If amountMsats is negative, it's outgoing; if positive, it's incoming
    final TransactionType transactionType = _parseTransactionType(json['type'], amountMsats: amountMsats);
    
    // Determine transaction status from LNbits status field
    // LNbits returns 'success' for completed payments, 'pending' for pending, etc.
    final TransactionStatus transactionStatus = _parseTransactionStatus(json['status']);
    
    return WalletTransaction(
      transactionId: json['transaction_id'] ?? json['payment_hash'] ?? json['checking_id'] ?? '',
      type: transactionType,
      status: transactionStatus,
      amount: amountSats,
      fee: (_parseInt(json['fee']) ?? 0) ~/ 1000, // Fee is also in msats, convert to sats
      description: json['description'] ?? json['memo'],
      invoice: json['invoice'] ?? json['bolt11'], // LNbits returns 'bolt11' field
      paymentHash: json['payment_hash'], // LNbits returns 'payment_hash' field
      preimage: json['preimage'],
      createdAt: createdAt,
      confirmedAt: _parseTimestamp(json['confirmed_at']) ?? _parseTimestamp(json['paid_at']),
      walletId: json['wallet_id'] ?? '',
      relatedPubkey: json['related_pubkey'],
    );
  }

  /// Parse integer from dynamic value (handles both int and string)
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      // Try parsing as integer first
      final intValue = int.tryParse(value);
      if (intValue != null) return intValue;
      
      // If not an integer, try parsing as ISO 8601 datetime string
      try {
        final dateTime = DateTime.parse(value);
        return dateTime.millisecondsSinceEpoch ~/ 1000;
      } catch (e) {
        // Not a valid datetime string either
        return null;
      }
    }
    return null;
  }
  
  /// Parse timestamp from various formats (int, string int, ISO 8601 datetime)
  static int? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      // Try parsing as integer first (Unix timestamp)
      final intValue = int.tryParse(value);
      if (intValue != null && intValue > 0) return intValue;
      
      // If not an integer, try parsing as ISO 8601 datetime string
      try {
        final dateTime = DateTime.parse(value);
        return dateTime.millisecondsSinceEpoch ~/ 1000;
      } catch (e) {
        // Not a valid datetime string
        return null;
      }
    }
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

  /// Parse transaction type from string or amount sign
  static TransactionType _parseTransactionType(String? type, {int? amountMsats}) {
    // If amount is provided, use it to determine type
    if (amountMsats != null) {
      return amountMsats < 0 ? TransactionType.outgoing : TransactionType.incoming;
    }
    
    // Otherwise try to parse from type string
    switch (type?.toLowerCase()) {
      case 'incoming':
        return TransactionType.incoming;
      case 'outgoing':
        return TransactionType.outgoing;
      default:
        // Default to incoming for pending payments
        return TransactionType.incoming;
    }
  }

  /// Parse transaction status from string
  static TransactionStatus _parseTransactionStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'confirmed':
      case 'success': // LNbits returns 'success' for completed payments
      case 'complete':
        return TransactionStatus.confirmed;
      case 'failed':
        return TransactionStatus.failed;
      case 'expired':
        return TransactionStatus.expired;
      default:
        // Default to confirmed if status is not recognized (likely means it's done)
        return TransactionStatus.confirmed;
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

import 'package:isar/isar.dart';

part 'wallet_invoice.g.dart';

/// Invoice status enum
enum InvoiceStatus {
  pending,
  paid,
  expired,
  cancelled,
}

/// Wallet invoice model for storing Lightning Network invoices
@collection
class WalletInvoice {
  @Id()
  int id = 0;

  /// Invoice ID
  @Index(unique: true)
  String invoiceId;

  /// Bolt11 invoice string
  String bolt11;

  /// Payment hash
  String paymentHash;

  /// Amount in satoshis
  int amount;

  /// Invoice description/memo
  String? description;

  /// Invoice status
  InvoiceStatus status;

  /// Timestamp when invoice was created
  int createdAt;

  /// Timestamp when invoice expires
  int expiresAt;

  /// Timestamp when invoice was paid
  int? paidAt;

  /// Wallet identifier
  String walletId;

  /// Related user pubkey (if applicable)
  String? relatedPubkey;

  /// Preimage (when paid)
  String? preimage;

  WalletInvoice({
    required this.invoiceId,
    required this.bolt11,
    required this.paymentHash,
    required this.amount,
    this.description,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.paidAt,
    required this.walletId,
    this.relatedPubkey,
    this.preimage,
  });

  /// Create from JSON map
  factory WalletInvoice.fromJson(Map<String, dynamic> json) {
    return WalletInvoice(
      invoiceId: json['invoice_id'] ?? '',
      bolt11: json['bolt11'] ?? '',
      paymentHash: json['payment_hash'] ?? '',
      amount: json['amount'] ?? 0,
      description: json['description'],
      status: _parseInvoiceStatus(json['status']),
      createdAt: json['created_at'] ?? 0,
      expiresAt: json['expires_at'] ?? 0,
      paidAt: json['paid_at'],
      walletId: json['wallet_id'] ?? '',
      relatedPubkey: json['related_pubkey'],
      preimage: json['preimage'],
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'bolt11': bolt11,
      'payment_hash': paymentHash,
      'amount': amount,
      'description': description,
      'status': status.name,
      'created_at': createdAt,
      'expires_at': expiresAt,
      'paid_at': paidAt,
      'wallet_id': walletId,
      'related_pubkey': relatedPubkey,
      'preimage': preimage,
    };
  }

  /// Parse invoice status from string
  static InvoiceStatus _parseInvoiceStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return InvoiceStatus.pending;
      case 'paid':
        return InvoiceStatus.paid;
      case 'expired':
        return InvoiceStatus.expired;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      default:
        return InvoiceStatus.pending;
    }
  }

  /// Get amount in BTC
  double get amountBTC => amount / 100000000;

  /// Check if invoice is paid
  bool get isPaid => status == InvoiceStatus.paid;

  /// Check if invoice is pending
  bool get isPending => status == InvoiceStatus.pending;

  /// Check if invoice is expired
  bool get isExpired => status == InvoiceStatus.expired || 
      DateTime.now().millisecondsSinceEpoch ~/ 1000 > expiresAt;

  /// Check if invoice is cancelled
  bool get isCancelled => status == InvoiceStatus.cancelled;

  /// Get time until expiration in seconds
  int get timeUntilExpiration {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiresAt - now;
  }

  /// Check if invoice is about to expire (within 1 hour)
  bool get isExpiringSoon => timeUntilExpiration < 3600 && timeUntilExpiration > 0;

  /// Update invoice status
  void updateStatus(InvoiceStatus newStatus) {
    status = newStatus;
    if (newStatus == InvoiceStatus.paid && paidAt == null) {
      paidAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
  }

  /// Mark invoice as paid
  void markAsPaid({String? preimage}) {
    status = InvoiceStatus.paid;
    paidAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (preimage != null) {
      this.preimage = preimage;
    }
  }

  /// Copy with new values
  WalletInvoice copyWith({
    String? invoiceId,
    String? bolt11,
    String? paymentHash,
    int? amount,
    String? description,
    InvoiceStatus? status,
    int? createdAt,
    int? expiresAt,
    int? paidAt,
    String? walletId,
    String? relatedPubkey,
    String? preimage,
  }) {
    return WalletInvoice(
      invoiceId: invoiceId ?? this.invoiceId,
      bolt11: bolt11 ?? this.bolt11,
      paymentHash: paymentHash ?? this.paymentHash,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      paidAt: paidAt ?? this.paidAt,
      walletId: walletId ?? this.walletId,
      relatedPubkey: relatedPubkey ?? this.relatedPubkey,
      preimage: preimage ?? this.preimage,
    );
  }

  @override
  String toString() {
    return 'WalletInvoice(invoiceId: $invoiceId, amount: $amount, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletInvoice &&
        other.invoiceId == invoiceId &&
        other.bolt11 == bolt11 &&
        other.paymentHash == paymentHash &&
        other.amount == amount &&
        other.description == description &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.paidAt == paidAt &&
        other.walletId == walletId &&
        other.relatedPubkey == relatedPubkey &&
        other.preimage == preimage;
  }

  @override
  int get hashCode {
    return Object.hash(
      invoiceId,
      bolt11,
      paymentHash,
      amount,
      description,
      status,
      createdAt,
      expiresAt,
      paidAt,
      walletId,
      relatedPubkey,
      preimage,
    );
  }
}

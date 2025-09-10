import 'dart:convert';

import '../event.dart';
import '../keychain.dart';
import 'nip_004.dart';

/// Nostr Wallet Connect
/// https://github.com/nostr-protocol/nips/blob/master/47.md
class Nip47 {
  // Request methods
  static Future<Event> payInvoice(
      String invoice, String receiver, String privkey) async {
    return _createRequest('pay_invoice', {'invoice': invoice}, receiver, privkey);
  }

  static Future<Event> makeInvoice({
    required int amount, // value in msats
    String? description, // invoice's description, optional
    String? descriptionHash, // invoice's description hash, optional
    int? expiry, // expiry in seconds from time invoice is created, optional
    required String receiver,
    required String privkey,
  }) async {
    Map<String, dynamic> params = {
      'amount': amount,
    };
    if (description != null) params['description'] = description;
    if (descriptionHash != null) params['description_hash'] = descriptionHash;
    if (expiry != null) params['expiry'] = expiry;
    
    return _createRequest('make_invoice', params, receiver, privkey);
  }

  static Future<Event> lookupInvoice({
    String? paymentHash, // payment hash of the invoice
    String? invoice, // invoice to lookup
    required String receiver,
    required String privkey,
  }) async {
    Map<String, dynamic> params = {};
    if (paymentHash != null) params['payment_hash'] = paymentHash;
    if (invoice != null) params['invoice'] = invoice;
    
    // At least one of payment_hash or invoice is required
    if (params.isEmpty) {
      throw ArgumentError('Either paymentHash or invoice must be provided');
    }
    
    return _createRequest('lookup_invoice', params, receiver, privkey);
  }

  static Future<Event> listTransactions({
    int? from, // starting timestamp in seconds since epoch (inclusive)
    int? until, // ending timestamp in seconds since epoch (inclusive)
    int? limit, // maximum number of invoices to return
    int? offset, // offset of the first invoice to return
    bool? unpaid, // include unpaid invoices, default false
    String? type, // "incoming" for invoices, "outgoing" for payments, null for both
    required String receiver,
    required String privkey,
  }) async {
    Map<String, dynamic> params = {};
    if (from != null) params['from'] = from;
    if (until != null) params['until'] = until;
    if (limit != null) params['limit'] = limit;
    if (offset != null) params['offset'] = offset;
    if (unpaid != null) params['unpaid'] = unpaid;
    if (type != null) params['type'] = type;
    return _createRequest('list_transactions', params, receiver, privkey);
  }

  static Future<Event> getBalance(String receiver, String privkey) async {
    return _createRequest('get_balance', {}, receiver, privkey);
  }

  static Future<Event> getInfo(String receiver, String privkey) async {
    return _createRequest('get_info', {}, receiver, privkey);
  }

  static Future<Event> makeSubscriptionInvoice(
      String groupid, int month, String receiver, String privkey) async {
    return _createSubscriptionRequest('make_subscription_invoice', {
      'groupid': groupid,
      'month': month,
    }, receiver, privkey);
  }

  static Future<Event> lookupSubscriptionInvoice(
      String paymentHash, String receiver, String privkey) async {
    return _createSubscriptionRequest('lookup_subscription_invoice', {
      'payment_hash': paymentHash,
    }, receiver, privkey);
  }

  static Future<Event> getNwcUri(String receiver, String privkey) async {
    return _createRequest('get_nwc_uri', {}, receiver, privkey);
  }

  // Helper method to create requests
  static Future<Event> _createRequest(
      String method, Map<String, dynamic> params, String receiver, String privkey) async {
    String sender = Keychain.getPublicKey(privkey);
    Map request = {
      'method': method,
      'params': params
    };
    String content = jsonEncode(request);
    String enContent =
        await Nip4.encryptContent(content, receiver, sender, privkey);
    return await Event.from( 
        kind: 23194,
        tags: [
          ['p', receiver]
        ],
        content: enContent,
        pubkey: sender,
        privkey: privkey);
  }

  // Helper method to create subscription requests (uses 23196)
  static Future<Event> _createSubscriptionRequest(
      String method, Map<String, dynamic> params, String receiver, String privkey) async {
    String sender = Keychain.getPublicKey(privkey);
    Map request = {
      'method': method,
      'params': params
    };
    String content = jsonEncode(request);
    String enContent =
        await Nip4.encryptContent(content, receiver, sender, privkey);
    return await Event.from( 
        kind: 23196,
        tags: [
          ['p', receiver]
        ],
        content: enContent,
        pubkey: sender,
        privkey: privkey);
  }

  static Future<NwcResponse?> response(
      Event event, String sender, String receiver, String privkey) async {
    if (event.kind == 23195 || event.kind == 23197) {
      String? requestId, p;
      for (var tag in event.tags) {
        if (tag[0] == "p") p = tag[1];
        if (tag[0] == "e") requestId = tag[1];
      }
      if (requestId == null || p != receiver) return null;
      String content =
          await Nip4.decryptContent(event.content, sender, receiver, privkey);
      Map map = jsonDecode(content);
      
      // Check for error
      if (map['error'] != null) {
        String? code = map['error']?['code'];
        String? message = map['error']?['message'];
        return NwcResponse.error(requestId, code, message);
      }
      
      // Check for result
      if (map['result'] != null) {
        return NwcResponse.success(requestId, map['result']);
      }
      
      return null;
    }
    return null;
  }
}

class NwcResponse {
  String requestId;
  bool isSuccess;
  Map<String, dynamic>? result;
  String? errorCode;
  String? errorMessage;

  NwcResponse._(this.requestId, this.isSuccess, this.result, this.errorCode, this.errorMessage);

  factory NwcResponse.success(String requestId, Map<String, dynamic> result) {
    return NwcResponse._(requestId, true, result, null, null);
  }

  factory NwcResponse.error(String requestId, String? code, String? message) {
    return NwcResponse._(requestId, false, null, code, message);
  }

  // Convenience getters for specific result types
  String? get preimage => result?['preimage'];
  String? get invoice => result?['invoice'];
  int? get balance => result?['balance'];
  Map<String, dynamic>? get info => result?['info'];
  List<dynamic>? get transactions => result?['transactions'];
  String? get nwcUri => result?['nwc_uri'];
  
  // Get transactions as typed objects
  List<Transaction>? get typedTransactions {
    final transactions = result?['transactions'] as List<dynamic>?;
    if (transactions == null) return null;
    return transactions.map((t) => Transaction.fromMap(t)).toList();
  }
  
  // Get single transaction for lookup_invoice response
  Transaction? get typedTransaction {
    if (result == null) return null;
    return Transaction.fromMap(result!);
  }
}

/// Transaction object for list_transactions response
class Transaction {
  final String type; // "incoming" for invoices, "outgoing" for payments
  final String state; // "pending", "settled", "expired" (for invoices) or "failed" (for payments)
  final String? invoice; // encoded invoice, optional
  final String? description; // invoice's description, optional
  final String? descriptionHash; // invoice's description hash, optional
  final String? preimage; // payment's preimage, optional if unpaid
  final String paymentHash; // Payment hash for the payment
  final int amount; // value in msats
  final int? feesPaid; // value in msats
  final int createdAt; // invoice/payment creation time
  final int? expiresAt; // invoice expiration time, optional if not applicable
  final int? settledAt; // invoice/payment settlement time, optional if unpaid
  final Map<String, dynamic>? metadata; // generic metadata

  Transaction({
    required this.type,
    required this.state,
    this.invoice,
    this.description,
    this.descriptionHash,
    this.preimage,
    required this.paymentHash,
    required this.amount,
    this.feesPaid,
    required this.createdAt,
    this.expiresAt,
    this.settledAt,
    this.metadata,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      type: map['type'] as String,
      state: map['state'] as String,
      invoice: map['invoice'] as String?,
      description: map['description'] as String?,
      descriptionHash: map['description_hash'] as String?,
      preimage: map['preimage'] as String?,
      paymentHash: map['payment_hash'] as String,
      amount: map['amount'] as int,
      feesPaid: map['fees_paid'] as int?,
      createdAt: map['created_at'] as int,
      expiresAt: map['expires_at'] as int?,
      settledAt: map['settled_at'] as int?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'state': state,
      if (invoice != null) 'invoice': invoice,
      if (description != null) 'description': description,
      if (descriptionHash != null) 'description_hash': descriptionHash,
      if (preimage != null) 'preimage': preimage,
      'payment_hash': paymentHash,
      'amount': amount,
      if (feesPaid != null) 'fees_paid': feesPaid,
      'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (settledAt != null) 'settled_at': settledAt,
      if (metadata != null) 'metadata': metadata,
    };
  }

  // Convenience getters
  bool get isIncoming => type == 'incoming';
  bool get isOutgoing => type == 'outgoing';
  bool get isPending => state == 'pending';
  bool get isSettled => state == 'settled';
  bool get isExpired => state == 'expired';
  bool get isFailed => state == 'failed';
  bool get isPaid => isSettled;
  bool get isUnpaid => !isPaid;
}

// Keep the old class for backward compatibility
class PayInvoiceResult {
  String requestId;
  bool result;
  String? preimage;
  String? code;
  String? message;

  PayInvoiceResult(
      this.requestId, this.result, this.preimage, this.code, this.message);

  factory PayInvoiceResult.fromNwcResponse(NwcResponse response) {
    return PayInvoiceResult(
      response.requestId,
      response.isSuccess,
      response.preimage,
      response.errorCode,
      response.errorMessage,
    );
  }
}

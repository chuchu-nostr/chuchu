import 'dart:convert';
import 'package:chuchu/core/nostr_dart/src/utils.dart';
import 'package:http/http.dart' as http;
import 'package:chuchu/core/utils/log_utils.dart';

/// LNbits API service for HTTP requests
class LnbitsApiService {
  static const String _defaultLnbitsUrl = 'http://54.186.137.75:5000';
  
  final String baseUrl;
  
  LnbitsApiService({String? lnbitsUrl}) : baseUrl = lnbitsUrl ?? _defaultLnbitsUrl;
  
  /// Create a new wallet with random name
  Future<Map<String, dynamic>> createWallet({
    String? walletName,
  }) async {
    try {
      // Generate random wallet name if not provided
      final targetName = walletName ?? generate64RandomHexChars();
      
      LogUtils.d(() => 'Creating wallet with name: $targetName');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/account'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': targetName,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final walletData = jsonDecode(response.body);
        LogUtils.d(() => 'Successfully created wallet: ${walletData['id']}');
        return {
          'id': walletData['id'],
          'admin': walletData['adminkey'],
          'invoice': walletData['inkey'],
          'read': walletData['inkey'], // LNbits uses inkey for read operations
          'name': targetName,
        };
      } else if (response.statusCode == 409) {
        // Wallet name already exists, try with a different random name
        LogUtils.d(() => 'Wallet name exists, trying with different name');
        final newName = 'chuchu_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
        return await createWallet(walletName: newName);
      } else {
        throw Exception('Failed to create wallet: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error creating wallet: $e');
      rethrow;
    }
  }
  

  
  /// Get wallet information
  Future<Map<String, dynamic>> getWalletInfo({
    required String apiKey,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/wallet'),
        headers: {
          'X-Api-Key': apiKey,
        },
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get wallet info: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error getting wallet info: $e');
      rethrow;
    }
  }
  
  /// Create an invoice
  Future<Map<String, dynamic>> createInvoice({
    required String apiKey,
    required int amount, // in sats
    String? memo,
    int? expiry,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/payments'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': apiKey,
        },
        body: jsonEncode({
          'out': false,
          'amount': amount,
          'memo': memo ?? '',
          'expiry': expiry ?? 3600,
          'unit': 'sat',
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create invoice: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error creating invoice: $e');
      rethrow;
    }
  }
  
  /// Pay an invoice
  Future<Map<String, dynamic>> payInvoice({
    required String adminKey,
    required String bolt11,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/payments'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': adminKey,
        },
        body: jsonEncode({
          'out': true,
          'bolt11': bolt11,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to pay invoice: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error paying invoice: $e');
      rethrow;
    }
  }
  
  /// Get payment by hash
  Future<Map<String, dynamic>> getPayment({
    required String apiKey,
    required String paymentHash,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/payments/$paymentHash'),
        headers: {
          'X-Api-Key': apiKey,
        },
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get payment: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error getting payment: $e');
      rethrow;
    }
  }
  
  /// Get payments list
  Future<List<Map<String, dynamic>>> getPayments({
    required String apiKey,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      
      final uri = Uri.parse('$baseUrl/api/v1/payments').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(
        uri,
        headers: {
          'X-Api-Key': apiKey,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> payments = jsonDecode(response.body);
        return payments.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get payments: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error getting payments: $e');
      rethrow;
    }
  }

  /// Get BTC to USD exchange rate using LNbits built-in API
  Future<double> getBtcToUsdRate() async {
    try {
      // Use LNbits built-in exchange rate API
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/rate/usd'),
        headers: {
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // LNbits returns: {"rate": sats_per_usd, "price": btc_price_in_usd}
        final btcPrice = data['price'] as double;
        LogUtils.d(() => 'BTC to USD rate from LNbits: $btcPrice');
        return btcPrice;
      } else {
        LogUtils.e(() => 'Failed to get BTC rate from LNbits: ${response.statusCode}');
        return 50000.0; // Fallback rate
      }
    } catch (e) {
      LogUtils.e(() => 'Error getting BTC rate from LNbits: $e');
      return 50000.0; // Fallback rate
    }
  }

  /// Decode BOLT11 invoice to extract amount and description
  Future<Map<String, dynamic>?> decodeInvoice(String bolt11) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/payments/decode'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'data': bolt11,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        LogUtils.d(() => 'Invoice decoded successfully: $data');
        return data;
      } else {
        LogUtils.e(() => 'Failed to decode invoice: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      LogUtils.e(() => 'Error decoding invoice: $e');
      return null;
    }
  }
}

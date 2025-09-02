import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chuchu/core/utils/log_utils.dart';

/// LNbits API service for HTTP requests
class LnbitsApiService {
  static const String _defaultLnbitsUrl = 'https://demo.lnbits.com';
  
  final String baseUrl;
  
  LnbitsApiService({String? lnbitsUrl}) : baseUrl = lnbitsUrl ?? _defaultLnbitsUrl;
  
  /// Create a new user in LNbits or get existing user info
  Future<Map<String, dynamic>> createUser({
    required String username,
    String? password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 409) {
        // User already exists, try to get user info
        LogUtils.d(() => 'User already exists, attempting to get user info');
        return await _getUserInfo(username, password);
      } else {
        throw Exception('Failed to create user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error creating user: $e');
      rethrow;
    }
  }

  /// Get existing user info (internal method)
  Future<Map<String, dynamic>> _getUserInfo(String username, String? password) async {
    try {
      // Try to authenticate and get user info
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to authenticate user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error getting user info: $e');
      rethrow;
    }
  }
  
  /// Create a new wallet for a user or get existing wallet
  Future<Map<String, dynamic>> createWallet({
    required String adminKey,
    String? walletName,
  }) async {
    try {
      // First, check if user already has wallets
      final existingWallets = await _getUserWallets(adminKey);
      final targetName = walletName ?? 'ChuChu Wallet';
      
      // Check if a wallet with the same name already exists
      for (final wallet in existingWallets) {
        if (wallet['name'] == targetName) {
          LogUtils.d(() => 'Wallet with name "$targetName" already exists, using existing wallet');
          return wallet;
        }
      }
      
      // No existing wallet found, create a new one
      LogUtils.d(() => 'Creating new wallet with name: $targetName');
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/wallet'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': adminKey,
        },
        body: jsonEncode({
          'name': targetName,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create wallet: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LogUtils.e(() => 'Error creating wallet: $e');
      rethrow;
    }
  }

  /// Get all wallets for a user (internal method)
  Future<List<Map<String, dynamic>>> _getUserWallets(String adminKey) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/wallets'),
        headers: {
          'X-Api-Key': adminKey,
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        LogUtils.w(() => 'Failed to get user wallets: ${response.statusCode} - ${response.body}');
        return []; // Return empty list if failed
      }
    } catch (e) {
      LogUtils.e(() => 'Error getting user wallets: $e');
      return []; // Return empty list if failed
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
}

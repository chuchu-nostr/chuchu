import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/wallet/wallet.dart';
import '../../core/wallet/model/wallet_transaction.dart';
import '../../core/utils/ui_refresh_mixin.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_image.dart';
import 'transaction_detail_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with ChuChuUIRefreshMixin {
  final Wallet _wallet = Wallet();
  List<WalletTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _wallet.getAllTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load transactions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshTransactions() async {
    await _wallet.refreshTransactions();
    await _loadTransactions();
  }

  void _showTransactionDetail(WalletTransaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailPage(transaction: transaction),
      ),
    );
  }

  // Group transactions by time period
  Map<String, List<WalletTransaction>> _groupTransactionsByTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final weekStart = today.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    Map<String, List<WalletTransaction>> grouped = {
      'TODAY': [],
      'YESTERDAY': [],
      'THIS WEEK': [],
      'LAST MONTH': [],
    };

    for (var tx in _transactions) {
      final txDate = DateTime.fromMillisecondsSinceEpoch(tx.createdAt * 1000);
      final txDay = DateTime(txDate.year, txDate.month, txDate.day);

      if (txDay == today) {
        grouped['TODAY']!.add(tx);
      } else if (txDay == yesterday) {
        grouped['YESTERDAY']!.add(tx);
      } else if (txDate.isAfter(weekStart) && txDate.isBefore(today)) {
        grouped['THIS WEEK']!.add(tx);
      } else if (txDate.isAfter(monthStart.subtract(Duration(days: 30))) &&
          txDate.isBefore(weekStart)) {
        grouped['LAST MONTH']!.add(tx);
      } else {
        grouped['LAST MONTH']!.add(tx); // Fallback for older transactions
      }
    }

    return grouped;
  }

  Widget _buildGroupedTransactions() {
    final grouped = _groupTransactionsByTime();
    final List<Widget> widgets = [];
    final theme = Theme.of(context);
    
    // Build sections in order: TODAY, YESTERDAY, THIS WEEK, LAST MONTH
    final sections = ['TODAY', 'YESTERDAY', 'THIS WEEK', 'LAST MONTH'];
    
    for (var section in sections) {
      final transactions = grouped[section]!;
      if (transactions.isNotEmpty) {
        // Sort by time (newest first)
        transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        widgets.add(_buildSectionHeader(section));
        
        // Wrap transactions in a container similar to wallet_page.dart
        widgets.add(
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final tx = entry.value;
                final isLast = index == transactions.length - 1;
                return Column(
                  children: [
                    _buildTransactionItem(tx),
                    if (!isLast)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: theme.colorScheme.outline.withAlpha(10),
                        indent: 80, // Start after icon and spacing
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
        
        widgets.add(SizedBox(height: 16));
      }
    }
    
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      children: widgets,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(WalletTransaction tx) {
    String formatTimeAgo(int timestamp) {
      final now = DateTime.now();
      final txTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      final diff = now.difference(txTime);

      if (diff.inDays >= 2) {
        return '${diff.inDays} days ago';
      } else if (diff.inDays >= 1) {
        return 'Yesterday';
      } else if (diff.inHours >= 1) {
        return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
      } else if (diff.inMinutes >= 1) {
        return '${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    }

    String formatAmount(int amount) {
      return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }

    // Determine icon based on description
    IconData getTransactionIcon() {
      final desc = tx.description?.toLowerCase() ?? '';
      if (desc.contains('zap')) {
        return Icons.bolt_rounded;
      } else if (desc.contains('coffee') || desc.contains('star')) {
        return Icons.local_cafe_rounded;
      } else if (desc.contains('subscription') || desc.contains('pro')) {
        return Icons.shopping_cart_rounded;
      }
      return tx.isIncoming
          ? Icons.arrow_downward_rounded
          : Icons.arrow_upward_rounded;
    }

    Color getIconColor() {
      final desc = tx.description?.toLowerCase() ?? '';
      if (desc.contains('zap')) {
        return Colors.amber[700]!;
      } else if (desc.contains('coffee') || desc.contains('star')) {
        return Colors.grey[700]!;
      } else if (desc.contains('subscription') || desc.contains('pro')) {
        return Color(0xFFE91E63);
      }
      return tx.isIncoming ? Colors.green[600]! : Colors.grey[700]!;
    }

    Color getIconBackgroundColor() {
      final desc = tx.description?.toLowerCase() ?? '';
      if (desc.contains('zap')) {
        return Colors.amber[100]!;
      } else if (desc.contains('coffee') || desc.contains('star')) {
        return Colors.grey[200]!;
      } else if (desc.contains('subscription') || desc.contains('pro')) {
        return Color(0xFFFCE4EC);
      }
      return tx.isIncoming ? Colors.green[100]! : Colors.grey[200]!;
    }

    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showTransactionDetail(tx),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Transaction icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  getTransactionIcon(),
                  color: getIconColor(),
                  size: 24,
                ),
              ),
              SizedBox(width: 16),

              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.description?.isNotEmpty == true
                          ? tx.description!
                          : 'Transaction',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatTimeAgo(tx.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount - vertical layout
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${tx.isIncoming ? '+' : '-'}${formatAmount(tx.amount)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tx.isIncoming ? Colors.green[600] : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'sats',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImage(iconName: 'wallet_history_icon.png', width: 150),
          SizedBox(height: 24),
          Text(
            'No transactions yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your transaction history will appear here once you start using your wallet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Icon(Icons.arrow_back, color: Colors.black87, size: 24),
          ),
        ),
        title: Text(
          'Transaction History',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: kBgLight,
        elevation: 0,
        foregroundColor: Colors.black87,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: kPrimary))
              : _transactions.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                onRefresh: _refreshTransactions,
                color: kPrimary,
                child: _buildGroupedTransactions(),
              ),
    );
  }
}

import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';

/// Widget for displaying unsubscribed user interface
/// Includes subscription options, bundles, and locked content
class UnsubscribedUIWidget extends StatelessWidget {
  final VoidCallback onSubscribe;
  final VoidCallback onBundle3Months;
  final VoidCallback onBundle6Months;
  final VoidCallback onBundle12Months;
  final VoidCallback onSubscribeToSeeContent;

  const UnsubscribedUIWidget({
    super.key,
    required this.onSubscribe,
    required this.onBundle3Months,
    required this.onBundle6Months,
    required this.onBundle12Months,
    required this.onSubscribeToSeeContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSubscriptionSection(context),
        const SizedBox(height: 20),
        _buildLockedContentSection(context),
      ],
    );
  }

  /// Build subscription section with main subscribe button and bundles
  Widget _buildSubscriptionSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subscription header
          const Text(
            'SUBSCRIPTION',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subscribe button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSubscribe,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SUBSCRIBE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      child: Text(
                        '\$9.99 per month',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Renewal info
          Row(
            children: [
              Text(
                'Renews for \$9.99 / month',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                _getNextMonthDate(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Subscription bundles header
          Row(
            children: [
              const Text(
                'SUBSCRIPTION BUNDLES',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_up,
                color: Colors.grey[600],
                size: 24,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 3 months bundle
          _buildBundleButton(
            title: '3 MONTHS (5% off)',
            price: '\$28.98 total',
            onTap: onBundle3Months,
          ),
          
          const SizedBox(height: 12),
          
          // 6 months bundle
          _buildBundleButton(
            title: '6 MONTHS (10% off)',
            price: '\$53.98 total',
            onTap: onBundle6Months,
          ),
          
          const SizedBox(height: 12),
          
          // 12 months bundle
          _buildBundleButton(
            title: '12 MONTHS (50% off)',
            price: '\$53.98 total',
            onTap: onBundle12Months,
          ),
        ],
      ),
    );
  }

  /// Build subscription bundle button
  Widget _buildBundleButton({
    required String title,
    required String price,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build locked content section
  Widget _buildLockedContentSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          // Content tabs
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
                child: const Text(
                  '335 POSTS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Text(
                '1212 MEDIA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Lock icon
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          
          const SizedBox(height: 24),
          
          // Stats under lock
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLockedStatItem(icon: Icons.landscape, value: '1.4K'),
              const SizedBox(width: 32),
              _buildLockedStatItem(icon: Icons.videocam, value: '334'),
              const SizedBox(width: 32),
              _buildLockedStatItem(icon: Icons.favorite, value: '621K'),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Subscribe to see content button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSubscribeToSeeContent,
                borderRadius: BorderRadius.circular(8),
                child: const Center(
                  child: Text(
                    'SUBSCRIBE TO SEE USER\'S POSTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Build locked stat item
  Widget _buildLockedStatItem({required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Get next month date in format 'MMM d, yyyy'
  String _getNextMonthDate() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, now.day);
    
    // Handle year rollover
    final adjustedNextMonth = DateTime(
      nextMonth.year + (nextMonth.month > 12 ? 1 : 0),
      nextMonth.month > 12 ? nextMonth.month - 12 : nextMonth.month,
      nextMonth.day,
    );
    
    // Format the date
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[adjustedNextMonth.month - 1]} ${adjustedNextMonth.day}, ${adjustedNextMonth.year}';
  }
}

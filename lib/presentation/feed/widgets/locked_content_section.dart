import 'package:flutter/material.dart';

class LockedContentSection extends StatefulWidget {
  final VoidCallback? onSubscribeToSeeContent;

  const LockedContentSection({super.key, this.onSubscribeToSeeContent});

  @override
  State<LockedContentSection> createState() => _LockedContentSectionState();
}

class _LockedContentSectionState extends State<LockedContentSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          // Content tabs
          // Row(
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.only(bottom: 8),
          //       decoration: const BoxDecoration(
          //         border: Border(
          //           bottom: BorderSide(color: Colors.blue, width: 2),
          //         ),
          //       ),
          //       child: const Text(
          //         '335 POSTS',
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //           color: Colors.blue,
          //         ),
          //       ),
          //     ),
          //     // const SizedBox(width: 24),
          //     // Text(
          //     //   '1212 MEDIA',
          //     //   style: TextStyle(
          //     //     fontSize: 16,
          //     //     fontWeight: FontWeight.w500,
          //     //     color: Colors.grey[600],
          //     //   ),
          //     // ),
          //   ],
          // ),

          const SizedBox(height: 40),

          Icon(Icons.lock_outline, size: 80, color: Colors.grey[400]),

          const SizedBox(height: 24),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildLockedStatItem(icon: Icons.landscape, value: '1.4K'),
          //     const SizedBox(width: 32),
          //     _buildLockedStatItem(icon: Icons.videocam, value: '334'),
          //     const SizedBox(width: 32),
          //     _buildLockedStatItem(icon: Icons.favorite, value: '621K'),
          //   ],
          // ),

          const SizedBox(height: 40),

          // Container(
          //   width: double.infinity,
          //   height: 56,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.primary,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Material(
          //     color: Colors.transparent,
          //     child: InkWell(
          //       onTap: widget.onSubscribeToSeeContent,
          //       borderRadius: BorderRadius.circular(8),
          //       child: const Center(
          //         child: Text(
          //           'SUBSCRIBE TO SEE USER\'S POSTS',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLockedStatItem({required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
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
}


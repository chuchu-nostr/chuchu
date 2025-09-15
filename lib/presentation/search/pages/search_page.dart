import 'package:chuchu/core/relayGroups/model/relayGroupDB_isar.dart';
import 'package:chuchu/core/relayGroups/relayGroup+info.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/presentation/feed/pages/feed_personal_page.dart';

import '../../../core/nostr_dart/src/nips/nip_019.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // Search state
  bool _isSearching = false;
  List<RelayGroupDBISAR> _searchResults = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    // Auto focus on search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              // Search header
              _buildSearchHeader(),

              // Search content
              Expanded(
                child: _buildSearchContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
      child: Row(
        children: [
          // Search input field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              height: 40.px,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.px),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 25,
                    ),
                  ),
                  SizedBox(width: 8.px),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16.px,
                        ),
                        border: InputBorder.none,
                        // contentPadding: EdgeInsets.symmetric(vertical: 12.px),
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 16.px,
                        color: Colors.black87,
                      ),
                      onChanged: (value) {
                        // Handle search input changes
                        if (value.isEmpty) {
                          setState(() {
                            _hasSearched = false;
                            _searchResults.clear();
                          });
                        } else {
                          _performSearch(value);
                        }
                      },
                      onSubmitted: (value) {
                        // Handle search submission
                        if (value.isNotEmpty) {
                          _performSearch(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(width: 12.px),
          
          // Cancel button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.px,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    if (!_hasSearched) {
      // Show search icon placeholder
      return Column(
        children: [
          CommonImage(
            iconName: 'search_people_icon.png',
            size: 150.px,
          ),
          SizedBox(height: 24.px),
          Text(
            'Search for users',
            style: TextStyle(
              fontSize: 18.px,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ).setPaddingOnly(top: 50.0);
    }

    if (_isSearching) {
      // Show loading
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.px),
            Text(
              'Searching...',
              style: TextStyle(
                fontSize: 16.px,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      // Show no data icon
      return Column(
        children: [
          CommonImage(
            iconName: 'no_data_icon.png',
            size: 320.px,
          ),
          SizedBox(height: 24.px),
          Text(
            'No users found',
            style: TextStyle(
              fontSize: 18.px,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ).setPaddingOnly(top: 50.0);
    }

    // Show search results
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.px),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildSearchResultItem(_searchResults[index]);
      },
    );
  }

    Widget _buildSearchResultItem(RelayGroupDBISAR group) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FeedPersonalPage(
              relayGroupDB: group,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
        child: Row(
          children: [
            // Avatar
            GestureDetector(
              onTap: () {
                ChuChuNavigator.pushPage(
                  context,
                      (context) =>
                      FeedPersonalPage(relayGroupDB: group),
                );
              },
              child: FeedWidgetsUtils.clipImage(
                borderRadius: 48,
                imageSize: 48,
                child: ChuChuCachedNetworkImage(
                  imageUrl: group.picture ?? '',
                  fit: BoxFit.cover,
                  placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
                  errorWidget:
                      (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
                  width: 48,
                  height: 48,
                ),
              ),
            ),

            SizedBox(width: 12.px),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 16.px,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.px),
                  // Text(
                  //   '@${user.dns ?? user.pubKey.substring(0, 8)}',
                  //   style: TextStyle(
                  //     fontSize: 14.px,
                  //     color: Colors.grey.shade600,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  void _performSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _searchResults.clear();
    });

    try {
      String? pubkey;
      if (trimmedQuery.startsWith('npub')) {
        // Decode npub to get pubkey
        pubkey = UserDBISAR.decodePubkey(trimmedQuery);

      } else {
        // Assume it's already a pubkey
        pubkey = trimmedQuery;
      }




      if (pubkey == null || pubkey.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
        return;
      }

      // Get user info from Account
      RelayGroupDBISAR? relayGroup = await RelayGroup.sharedInstance.searchGroupsMetadataWithGroupID(pubkey,null);

      if (mounted) {
        setState(() {
          _isSearching = false;
          if (relayGroup != null) {
            _searchResults = [relayGroup];
          } else {
            _searchResults = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
      }
      debugPrint('Search failed: $e');
    }
  }
}

 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chuchu/core/relayGroups/model/relayGroupDB_isar.dart';
import 'package:chuchu/core/relayGroups/relayGroup+info.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/presentation/feed/pages/feed_personal_page.dart';

import '../../../core/account/relays.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/utils/navigator/navigator.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
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
        return _authorCard(_searchResults[index]);
      },
    );
  }


  Widget _authorCard(RelayGroupDBISAR relayGroup) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        ChuChuNavigator.pushPage(context, (context) => FeedPersonalPage(relayGroupDB: relayGroup,));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: Adapt.px(140),
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child:
                relayGroup.picture.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: relayGroup.picture,
                  fit: BoxFit.cover,
                )
                    : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primaryContainer,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Row(
                  children: [
                    _followsUserPicWidget(relayGroup),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          relayGroup.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          relayGroup.about,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _followsUserPicWidget(RelayGroupDBISAR relayGroup) {
    Widget picWidget;
    if (relayGroup.picture.isNotEmpty) {
      picWidget = CachedNetworkImage(
        imageUrl: relayGroup.picture,
        fit: BoxFit.contain,
        // placeholder: (context, url) => _badgePlaceholderImage,
        // errorWidget: (context, url, error) => _badgePlaceholderImage,
        width: Adapt.px(80),
        height: Adapt.px(80),
      );
    } else {
      picWidget = CommonImage(
        iconName: 'icon_user_default.png',
        width: Adapt.px(80),
        height: Adapt.px(80),
      );
    }

    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: Adapt.px(80),
        height: Adapt.px(80),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Adapt.px(40)),
          child: picWidget,
        ),
      ),
    );

    //
  }

  /// Validate npub1 format
  /// npub1 format: starts with 'npub1' followed by bech32 encoded data
  bool _isValidNpub1(String input) {
    if (!input.startsWith('npub1')) {
      return false;
    }
    
    // npub1 should be at least 63 characters long (npub1 + 58 chars of bech32 data)
    if (input.length < 63) {
      return false;
    }
    
    // Extract the bech32 part (after 'npub1')
    String bech32Part = input.substring(5);
    
    // Check if it contains only valid bech32 characters (qpzry9x8gf2tvdw0s3jn54khce6mua7l)
    RegExp bech32Regex = RegExp(r'^[qpzry9x8gf2tvdw0s3jn54khce6mua7l]+$');
    if (!bech32Regex.hasMatch(bech32Part)) {
      return false;
    }
    
    // Additional length check for npub1 (should be around 63 characters)
    if (input.length != 63) {
      return false;
    }
    
    return true;
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
      if (trimmedQuery.startsWith('npub1')) {
        // Validate npub1 format
        if (!_isValidNpub1(trimmedQuery)) {
          print('🔍Invalid npub1 format: $trimmedQuery');
          setState(() {
            _isSearching = false;
            _searchResults = [];
          });
          return;
        }
        // Decode npub to get pubkey
        pubkey = UserDBISAR.decodePubkey(trimmedQuery);
        print('🔍Valid npub1 format, decoded pubkey: $pubkey');
      } else {
        // Assume it's already a pubkey
        pubkey = trimmedQuery;
      }

      if (pubkey == null || pubkey.isEmpty) {
        print('🔍Failed to decode pubkey from: $trimmedQuery');
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
        return;
      }

      // Get user info from Account
      RelayGroupDBISAR? relayGroup = await RelayGroup.sharedInstance.searchGroupsMetadataWithGroupID(pubkey,Relays.sharedInstance.recommendGroupRelays.first);
      print('🔍npub: $trimmedQuery');
      print('🔍pubkey: $pubkey');
      print('🔍relayGroup: $relayGroup');
      print('🔍relayGroupId: ${relayGroup?.groupId}');
      print('🔍name: ${relayGroup?.name}');
      print('🔍subscriptionAmount: ${relayGroup?.subscriptionAmount}');
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

 
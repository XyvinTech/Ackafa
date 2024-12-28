import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/notifires/feed_approval_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/customModalsheets.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FeedApproval extends ConsumerStatefulWidget {
  const FeedApproval({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedApproval> createState() => _FeedApprovalState();
}

class _FeedApprovalState extends ConsumerState<FeedApproval> {
  int _selectedIndex = 0; // Track the selected container

  final ScrollController _scrollController = ScrollController();
  final ScrollController _rejectedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _rejectedScrollController.addListener(_onRejectedScroll);
    _fetchInitialFeeds();
    _fetchInitialRejectedFeeds();
  }

  Future<void> _fetchInitialFeeds() async {
    await ref.read(feedApprovalNotifierProvider.notifier).fetchMoreFeed();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(feedApprovalNotifierProvider.notifier).fetchMoreFeed();
    }
  }

  void _onRejectedScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(feedApprovalRejectedNotifierProvider.notifier).fetchMoreFeed();
    }
  }

  Future<void> _fetchInitialRejectedFeeds() async {
    await ref
        .read(feedApprovalRejectedNotifierProvider.notifier)
        .fetchMoreFeed();
  }

  List<Feed> filteredFeeds = [];
  @override
  Widget build(BuildContext context) {
    final unpublishedFeeds = ref.watch(feedApprovalNotifierProvider);
    final feeds = ref.watch(feedApprovalNotifierProvider);
    final rejectedFeeds = ref.watch(feedApprovalRejectedNotifierProvider);
    switch (_selectedIndex) {
      case 0:
        filteredFeeds = unpublishedFeeds;
        break;
      case 1:
        filteredFeeds = feeds;
        break;
      case 2:
        filteredFeeds = rejectedFeeds;
        break;
      default:
    }


    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Tappable Containers for filtering
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterContainer("Unpublished", 0),
              const SizedBox(width: 8),
              _buildFilterContainer("published", 1),
              const SizedBox(width: 8),
              _buildFilterContainer("Rejected", 2),
            ],
          ),
          const SizedBox(height: 16),
          // Filtered feed list
          Expanded(
            child: filteredFeeds.isEmpty
                ? Center(
                    child: Text(
                      "No ${_selectedIndex == 0 ? "Pending" : _selectedIndex == 1 ? "Approved" : "Rejected"} Feeds",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredFeeds.length,
                    itemBuilder: (context, index) {
                      final feed = filteredFeeds[index];
                      final date =
                          DateFormat('yyyy-MM-dd').format(feed.createdAt!);
                      return GestureDetector(
                        onTap: () => showFeedApprovalDetail(context, feed),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  feed.author?.image != null
                                      ? CircleAvatar(
                                          radius: 24,
                                          backgroundImage: NetworkImage(
                                              feed.author?.image ?? ''),
                                        )
                                      : Image.asset(
                                          'assets/icons/dummy_person_small.png'),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          feed.author?.fullName ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ),

                                  // Status
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(feed.status ?? "")
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color:
                                            _getStatusColor(feed.status ?? ""),
                                      ),
                                    ),
                                    child: Text(
                                      feed.status ?? "",
                                      style: TextStyle(
                                        color:
                                            _getStatusColor(feed.status ?? ""),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    feed.author?.memberId ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "$date",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Build a filter container
  Widget _buildFilterContainer(String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.red[50] : Colors.transparent,
          border: Border.all(
            color: _selectedIndex == index ? Colors.red : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.red : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

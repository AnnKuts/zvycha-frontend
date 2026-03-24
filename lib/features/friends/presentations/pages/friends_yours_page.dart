import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/friends_section.dart';
import '../widgets/invitation_section.dart';
import '../../../../core/widgets/search_field.dart';
import '../providers/friends_notifier.dart';

class FriendsYoursPage extends StatefulWidget {
  const FriendsYoursPage({super.key});

  @override
  State<FriendsYoursPage> createState() =>
      _FriendsYoursPageState();
}

class _FriendsYoursPageState extends State<FriendsYoursPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<FriendsNotifier>().fetchAllFriendsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsNotifier>(
      builder: (context, notifier, child) {
        final bool isLoading =
            notifier.isLoadingFriends ||
            notifier.isLoadingIncoming;
        final bool hasRequests =
            notifier.incomingRequests.isNotEmpty;
        final bool hasFriends = notifier.friends.isNotEmpty;

        return RefreshIndicator(
          onRefresh: () async {
            await notifier.fetchAllFriendsData();
          },
          child: Column(
            children: [
              AppSearchField(
                onSearch: (value) =>
                    notifier.fetchFriends(username: value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!hasRequests && !hasFriends) {
                      return const Center(
                        child: Text(
                          "You don't have any friends yet.",
                        ),
                      );
                    }

                    return Column(
                      children: [
                        if (hasRequests)
                          Flexible(
                            child: InvitationsSection(
                              notifier: notifier,
                            ),
                          ),
                        if (hasRequests && hasFriends)
                          const SizedBox(height: 16),
                        if (hasFriends)
                          Flexible(
                            child: FriendsSection(
                              notifier: notifier,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

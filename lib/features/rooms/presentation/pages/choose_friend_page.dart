import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../friends/presentations/providers/friends_notifier.dart';

class ChooseFriendPage extends StatelessWidget {
  const ChooseFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          child: Column(
            children: [
              const CustomHeader(title: 'Choose A Friend'),

              const SizedBox(height: 20),

              AppSearchField(
                onSearch: (value) => context
                    .read<FriendsNotifier>()
                    .fetchFriends(username: value),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Consumer<FriendsNotifier>(
                  builder: (context, friendsNotifier, child) {
                    if (friendsNotifier.isLoadingFriends) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (friendsNotifier.friends.isEmpty) {
                      return Center(
                        child: Text(
                          "You don't have any friends.",
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: friendsNotifier.friends.length,
                      itemBuilder: (context, index) {
                        final friend =
                            friendsNotifier.friends[index];
                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black
                                    .withValues(alpha: 0.25),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(friend.username),
                            trailing: const Icon(
                              Icons.add,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              context.pop({
                                'id': friend.id,
                                'username': friend.username,
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:zvycha_frontend/core/services/auth_storage.dart';

import './models/app_user.dart';
import './models/friend_request.dart';
import 'friends_api_service.dart';

class FriendsRepository {
  final FriendsApiService _apiService;

  FriendsRepository(this._apiService);

  // Отримати список друзів і пошук серед них за username
  Future<List<AppUser>> getFriends({String? username}) async {
    final data = username != null && username.isNotEmpty
        ? await _apiService.searchFriends(username)
        : await _apiService.fetchFriends();

    final List users = data['users'] ?? [];
    return users.map((json) => AppUser.fromJson(json)).toList();
  }

  // Пошук нових людей
  Future<List<AppUser>> findNewPeople(String username) async {
    if (username.isEmpty) return [];
    final data = await _apiService.searchAllPeople(username);
    final List users = data['users'] ?? [];
    return users.map((json) => AppUser.fromJson(json)).toList();
  }

  // Пошук користувача за id
  Future<AppUser> getUserInfo(String userId) async {
    final data = await _apiService.getUserById(userId);
    return AppUser.fromJson(data);
  }

  // Отримати вхідні запити
  Future<List<FriendRequest>> getIncomingRequests() async {
    final currentUserId = await AuthStorage.getUserId() ?? '';
    final data = await _apiService.fetchRequests();
    final List requestsJson = data['requests'] ?? [];

    return requestsJson
        .map((json) => FriendRequest.fromJson(json))
        .where(
          (req) =>
              req.userId == currentUserId &&
              req.creatorId != currentUserId,
        )
        .toList();
  }

  // Отримати вмхідні запити
  Future<List<FriendRequest>> getOutgoingRequests() async {
    final currentUserId = await AuthStorage.getUserId() ?? '';
    final data = await _apiService.fetchRequests();
    final List requestsJson = data['requests'] ?? [];

    return requestsJson
        .map((json) => FriendRequest.fromJson(json))
        .where((req) => req.creatorId == currentUserId)
        .toList();
  }

  // Дії з запитами на дружбу
  Future<void> sendFriendRequest(String userId) =>
      _apiService.sendRequest(userId);
  Future<void> acceptFriendRequest(String requestId) =>
      _apiService.acceptRequest(requestId);
  Future<void> declineFriendRequest(String requestId) =>
      _apiService.declineRequest(requestId);
}

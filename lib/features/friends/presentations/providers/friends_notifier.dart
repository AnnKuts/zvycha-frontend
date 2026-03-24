import 'package:flutter/material.dart';
import '../../data/friends_repository.dart';
import '../../data/models/app_user.dart';
import '../../data/models/friend_request.dart';

class FriendsNotifier extends ChangeNotifier {
  final FriendsRepository _repository;
  FriendsNotifier(this._repository);

  List<AppUser> _friends = [];
  List<FriendRequest> _incomingRequests = [];
  List<FriendRequest> _outgoingRequests = [];
  List<AppUser> _foundUsers = [];
  final Map<String, String> _userNamesCache = {};

  bool _isLoadingFriends = true;
  bool _isLoadingIncoming = true;
  bool _isLoadingOutgoing = false;
  bool _isLoadingSearch = false;
  bool _isActionInProgress = false;

  String? _errorMessage;

  List<AppUser> get friends => _friends;
  List<FriendRequest> get incomingRequests => _incomingRequests;
  List<FriendRequest> get outgoingRequests => _outgoingRequests;
  List<AppUser> get foundUsers => _foundUsers;
  Map<String, String> get userNamesCache => _userNamesCache;

  bool get isLoadingFriends => _isLoadingFriends;
  bool get isLoadingIncoming => _isLoadingIncoming;
  bool get isLoadingOutgoing => _isLoadingOutgoing;
  bool get isLoadingSearch => _isLoadingSearch;
  bool get isActionInProgress => _isActionInProgress;
  String? get errorMessage => _errorMessage;

  // Tab Yours
  Future<void> fetchAllFriendsData({String? username}) async {
    _errorMessage = null;
    _isLoadingFriends = true;
    _isLoadingIncoming = true;
    _isLoadingOutgoing = true;
    try {
      await Future.wait([
        _fetchFriendsSilent(username: username),
        _fetchIncomingRequestsSilent(),
        _fetchOutgoingRequestsSilent(),
      ]);

      final Set<String> idsToFetch = {
        ..._incomingRequests.map((e) => e.creatorId),
        ..._outgoingRequests.map((e) => e.userId),
      };
      if (idsToFetch.isNotEmpty) {
        await Future.wait(
          idsToFetch.map((id) => _fetchUsernameSilent(id)),
        );
      }
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoadingFriends = false;
      _isLoadingIncoming = false;
      _isLoadingOutgoing = false;
      notifyListeners();
    }
  }

  Future<void> _fetchUsernameSilent(String userId) async {
    if (_userNamesCache.containsKey(userId)) return;
    try {
      final user = await _repository.getUserInfo(userId);
      _userNamesCache[userId] = user.username;
    } catch (_) {
      _userNamesCache[userId] = "Unknown User";
    }
  }

  Future<void> _fetchFriendsSilent({String? username}) async {
    _friends = await _repository.getFriends(username: username);
  }

  Future<void> _fetchIncomingRequestsSilent() async {
    final allIncoming = await _repository.getIncomingRequests();

    _incomingRequests = allIncoming.where((req) {
      return req.status == RequestStatus.pending;
    }).toList();
  }

  Future<void> _fetchOutgoingRequestsSilent() async {
    final allOutgoing = await _repository.getOutgoingRequests();

    _outgoingRequests = allOutgoing.where((req) {
      return req.status == RequestStatus.pending;
    }).toList();
  }

  // Публічні методи
  Future<void> fetchFriends({String? username}) async {
    _isLoadingFriends = true;
    notifyListeners();
    try {
      await _fetchFriendsSilent(username: username);
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoadingFriends = false;
      notifyListeners();
    }
  }

  Future<void> fetchUsernamesByIds(List<String> userIds) async {
    final Set<String> idsToFetch = userIds
        .where(
          (id) =>
              id.isNotEmpty && !_userNamesCache.containsKey(id),
        )
        .toSet();

    if (idsToFetch.isEmpty) return;

    try {
      await Future.wait(
        idsToFetch.map((id) => _fetchUsernameSilent(id)),
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching usernames: $e");
    }
  }

  Future<void> searchNewPeople(String username) async {
    if (username.isEmpty) {
      _foundUsers = [];
      notifyListeners();
      return;
    }
    _isLoadingSearch = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _foundUsers = await _repository.findNewPeople(username);
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoadingSearch = false;
      notifyListeners();
    }
  }

  Future<void> fetchIncomingRequests() async {
    _isLoadingIncoming = true;
    notifyListeners();
    try {
      final allIncoming = await _repository
          .getIncomingRequests();

      _incomingRequests = allIncoming.where((req) {
        return req.status == RequestStatus.pending;
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingIncoming = false;

      notifyListeners();
    }
  }

  Future<void> fetchOutgoingRequests() async {
    _isLoadingOutgoing = true;
    notifyListeners();
    try {
      final allOutgoing = await _repository
          .getOutgoingRequests();

      _outgoingRequests = allOutgoing.where((req) {
        return req.status == RequestStatus.pending;
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingOutgoing = false;

      notifyListeners();
    }
  }

  // Прийняти запит
  Future<void> acceptRequest(String requestId) async {
    _incomingRequests.removeWhere((req) => req.id == requestId);
    notifyListeners();
    await _handleRequestAction(
      () => _repository.acceptFriendRequest(requestId),
    );
  }

  // Відхилити запит
  Future<void> declineRequest(String requestId) async {
    _incomingRequests.removeWhere((req) => req.id == requestId);
    notifyListeners();
    await _handleRequestAction(
      () => _repository.declineFriendRequest(requestId),
    );
  }

  Future<void> _handleRequestAction(
    Future<void> Function() action,
  ) async {
    _isActionInProgress = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();

      await Future.wait([fetchAllFriendsData()]);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  // Tab Find
  Future<void> sendInvitation(String userId) async {
    _isActionInProgress = true;
    notifyListeners();
    try {
      await _repository.sendFriendRequest(userId);
      await fetchOutgoingRequests();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  String _cleanError(dynamic e) =>
      e.toString().replaceFirst('Exception: ', '');

  void clearSearch() {
    _foundUsers = [];
    _errorMessage = null;
    notifyListeners();
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}

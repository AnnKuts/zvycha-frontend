import '../../../core/network/api_client.dart';

class FriendsApiService {
  final ApiClient _client;

  FriendsApiService(this._client);

  // Отримання списку друзів
  Future<Map<String, dynamic>> fetchFriends() async {
    return await _client.get('/users/user/me/friends');
  }

  // Пошук друзів по username
  Future<Map<String, dynamic>> searchFriends(
    String username,
  ) async {
    return await _client.get('/users/user/me/friends/$username');
  }

  // Пошук користувача за id
  Future<Map<String, dynamic>> getUserById(String userId) async {
    return await _client.get(
      '/users/user/me/check_person/$userId',
    );
  }

  // Пошук серед усіх users по username
  Future<Map<String, dynamic>> searchAllPeople(
    String username,
  ) async {
    return await _client.get(
      '/users/user/me/check_all_people/$username',
    );
  }

  // Отримання усіх запитів на дружбу
  Future<Map<String, dynamic>> fetchRequests() async {
    return await _client.get('/users/user/me/requests');
  }

  // Дії з запитами на дружбу
  Future<void> sendRequest(String userId) async {
    await _client.post('/users/user/me/send_request/$userId');
  }

  Future<void> acceptRequest(String requestId) async {
    await _client.patch(
      '/users/user/me/accept_request/$requestId',
    );
  }

  Future<void> declineRequest(String requestId) async {
    await _client.patch(
      '/users/user/me/decline_request/$requestId',
    );
  }
}

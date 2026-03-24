import '../../../core/network/api_client.dart';

class RoomsApiService {
  final ApiClient _client;

  RoomsApiService(this._client);

  Future<dynamic> getRooms() async {
    return await _client.get('/rooms/');
  }

  Future<dynamic> getPendingRooms() async {
    return await _client.get('/rooms/pending');
  }

  Future<dynamic> createRoomRequest(
    String userId,
    String name,
  ) async {
    return await _client.post(
      '/rooms/create/$userId',
      body: {'name': name},
    );
  }

  Future<void> acceptRoom(
    String roomId,
    Map<String, dynamic> data,
  ) async {
    return await _client.patch(
      '/rooms/accepted/$roomId',
      body: data,
    );
  }

  Future<void> declineRoom(String roomId) async {
    await _client.patch('/rooms/decline/$roomId');
  }

  Future<void> endRoom(String roomId, bool status) async =>
      await _client.patch(
        '/rooms/end_room/$roomId?new_room_status=$status',
      );

  Future<void> deleteRoom(String roomId) async {
    return await _client.delete('/rooms/delete/$roomId');
  }

  Future<dynamic> getPet(String roomId) async {
    return await _client.get('/rooms/pet/$roomId');
  }

  Future<dynamic> getHabits(String roomId) async {
    return await _client.get('/rooms/habbits/$roomId');
  }

  Future<void> checkHabit(String habitId) async {
    return await _client.post('/rooms/habbits/$habitId');
  }

  Future<dynamic> getPoints() async {
    return await _client.get('/points/');
  }

  Future<dynamic> getHabitProgress(String habitId) async {
    return await _client.get(
      '/rooms/progress/by_habbit/$habitId',
    );
  }
}

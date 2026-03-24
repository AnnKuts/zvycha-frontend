import 'package:zvycha_frontend/features/rooms/data/models/habit.dart';
import 'package:zvycha_frontend/features/rooms/data/models/pet.dart';
import 'package:zvycha_frontend/features/rooms/data/models/point_optoin.dart';
import 'package:zvycha_frontend/features/rooms/data/models/room.dart';

import 'models/habit_progress.dart';
import 'rooms_api_service.dart';

class RoomsRepository {
  final RoomsApiService _service;
  RoomsRepository(this._service);

  Future<List<Room>> fetchAllRooms() async {
    final data = await _service.getRooms();
    return (data['rooms'] as List)
        .map((e) => Room.fromJson(e))
        .toList();
  }

  Future<void> sendRoomInvitation(
    String userId,
    String name,
  ) async => await _service.createRoomRequest(userId, name);

  Future<void> finalizeAcceptance(
    String roomId,
    String petName,
    List<Map<String, String>> habits,
  ) async {
    await _service.acceptRoom(roomId, {
      "pet_data": {"name": petName},
      "habbits": habits,
    });
  }

  Future<void> rejectInvitation(String roomId) async {
    return await _service.declineRoom(roomId);
  }

  Future<void> changeRoomActiveStatus(
    String roomId,
    bool status,
  ) async {
    return await _service.endRoom(roomId, status);
  }

  Future<List<PointOption>> fetchPoints() async {
    final data = await _service.getPoints();
    return (data['points'] as List)
        .map((e) => PointOption.fromJson(e))
        .toList();
  }

  Future<Pet> fetchRoomPet(String roomId) async {
    return Pet.fromJson(await _service.getPet(roomId));
  }

  Future<List<Habit>> fetchRoomHabits(String roomId) async {
    final data = await _service.getHabits(roomId);
    return (data['habbits'] as List)
        .map((e) => Habit.fromJson(e))
        .toList();
  }

  Future<List<HabitProgress>> fetchHabitProgress(
    String habitId,
  ) async {
    final data = await _service.getHabitProgress(habitId);
    return (data['progresses'] as List)
        .map((e) => HabitProgress.fromJson(e))
        .toList();
  }

  Future<void> markHabitAsDone(String habitId) async {
    await _service.checkHabit(habitId);
  }

  Future<void> deleteRoom(String roomId) async {
    return await _service.deleteRoom(roomId);
  }
}

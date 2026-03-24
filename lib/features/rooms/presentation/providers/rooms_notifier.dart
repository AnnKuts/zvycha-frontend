import 'package:flutter/material.dart';
import 'package:zvycha_frontend/features/rooms/data/models/point_optoin.dart';
import 'package:zvycha_frontend/features/rooms/data/models/room.dart';
import 'package:zvycha_frontend/features/rooms/data/rooms_repository.dart';

import '../../../../core/services/auth_storage.dart';
import '../../data/models/habit.dart';
import '../../data/models/habit_progress.dart';
import '../../data/models/pet.dart';

class RoomsNotifier extends ChangeNotifier {
  final RoomsRepository _repository;
  RoomsNotifier(this._repository);

  List<Room> _rooms = [];
  List<PointOption> _pointOptions = [];
  bool _isLoading = false;
  String? _currentUserId;
  Pet? _currentPet;
  List<Habit> _currentHabits = [];
  Map<String, List<HabitProgress>> _habitsProgress = {};

  Map<String, List<HabitProgress>> get habitsProgress =>
      _habitsProgress;
  Pet? get currentPet => _currentPet;
  List<Habit> get currentHabits => _currentHabits;

  bool get isLoading => _isLoading;
  List<PointOption> get pointOptions => _pointOptions;

  List<Room> get incomingRequests => _rooms
      .where(
        (r) =>
            r.creationStatus == CreationStatus.pending &&
            r.creatorId != _currentUserId,
      )
      .toList();

  List<Room> get outgoingRequests => _rooms
      .where(
        (r) =>
            r.creationStatus == CreationStatus.pending &&
            r.creatorId == _currentUserId,
      )
      .toList();

  List<Room> get activeRooms => _rooms
      .where((r) => r.creationStatus == CreationStatus.accepted)
      .toList();

  Future<void> loadInitialData() async {
    _rooms = [];
    _isLoading = true;
    notifyListeners();
    _currentUserId = await AuthStorage.getUserId();

    try {
      final results = await Future.wait([
        _repository.fetchAllRooms(),
        _repository.fetchPoints(),
      ]);
      _rooms = results[0] as List<Room>;
      _rooms.removeWhere(
        (r) => r.creationStatus == CreationStatus.declined,
      );
      _pointOptions = results[1] as List<PointOption>;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRoom(String userId, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.sendRoomInvitation(userId, name);
      await loadInitialData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> declineRequest(String roomId) async {
    await _repository.rejectInvitation(roomId);
    _rooms.removeWhere((r) => r.id == roomId);
    notifyListeners();
  }

  Future<void> closeRoom(String roomId) async {
    await _repository.changeRoomActiveStatus(roomId, false);
    final index = _rooms.indexWhere((r) => r.id == roomId);
    if (index != -1) {
      await loadInitialData();
    }
  }

  Future<void> acceptRequest(
    String roomId,
    String petName,
    List<Map<String, String>> habits,
  ) async {
    await _repository.finalizeAcceptance(
      roomId,
      petName,
      habits,
    );
    await loadInitialData();
  }

  Future<void> loadRoomDetails(String roomId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.fetchRoomPet(roomId),
        _repository.fetchRoomHabits(roomId),
      ]);

      _currentPet = results[0] as Pet;
      _currentHabits = results[1] as List<Habit>;

      for (var habit in _currentHabits) {
        final progress = await _repository.fetchHabitProgress(
          habit.id,
        );
        _habitsProgress[habit.id] = progress;
      }
    } catch (e) {
      debugPrint("Error loading room details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int getPointsValue(String pointsId) {
    final option = _pointOptions.firstWhere(
      (p) => p.id == pointsId,
      orElse: () => PointOption(id: '', pointValue: 0),
    );
    return option.pointValue;
  }

  Future<void> checkHabit(String habitId, String roomId) async {
    try {
      await _repository.markHabitAsDone(habitId);
      await loadRoomDetails(roomId);
    } catch (e) {
      debugPrint("Error checking habit: $e");
    }
  }

  Future<void> deleteRoom(String roomId) async {
    await _repository.deleteRoom(roomId);
    _rooms.removeWhere((r) => r.id == roomId);
    notifyListeners();
  }
}

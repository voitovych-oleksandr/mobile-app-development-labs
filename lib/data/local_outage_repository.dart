import 'dart:convert';

import 'package:mobile_labs/domain/errors/domain_exception.dart';
import 'package:mobile_labs/domain/models/outage_slot.dart';
import 'package:mobile_labs/domain/repositories/outage_repository.dart';
import 'package:mobile_labs/domain/validators/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalOutageRepository implements OutageRepository {
  LocalOutageRepository(this._prefs);

  static const _key = 'outages.list';

  // Тимчасові початкові дані. Після підключення беремо їх із MockStation.
  static const _seed = <OutageSlot>[
    OutageSlot(id: 'seed-1', startHour: 8, endHour: 12),
    OutageSlot(id: 'seed-2', startHour: 16, endHour: 20),
  ];

  final SharedPreferences _prefs;

  @override
  Future<List<OutageSlot>> getAll() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return List.of(_seed);
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> add(OutageSlot slot) async {
    _validate(slot);
    final items = await getAll();
    await _save([...items, slot]);
  }

  @override
  Future<void> update(OutageSlot slot) async {
    _validate(slot);
    final items = await getAll();
    final index = items.indexWhere((s) => s.id == slot.id);
    if (index == -1) throw const DomainException('Відключення не знайдено');
    items[index] = slot;
    await _save(items);
  }

  @override
  Future<void> delete(String id) async {
    final items = await getAll();
    items.removeWhere((s) => s.id == id);
    await _save(items);
  }

  void _validate(OutageSlot slot) {
    final error = OutageValidator.range(slot.startHour, slot.endHour);
    if (error != null) throw DomainException(error);
  }

  Future<void> _save(List<OutageSlot> items) async {
    final encoded = jsonEncode(items.map(_toJson).toList());
    await _prefs.setString(_key, encoded);
  }

  Map<String, dynamic> _toJson(OutageSlot s) => {
    'id': s.id,
    'startHour': s.startHour,
    'endHour': s.endHour,
  };

  OutageSlot _fromJson(Map<String, dynamic> j) => OutageSlot(
    id: j['id'] as String,
    startHour: j['startHour'] as int,
    endHour: j['endHour'] as int,
  );
}

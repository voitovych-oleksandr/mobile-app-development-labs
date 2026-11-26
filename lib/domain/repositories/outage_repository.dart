import 'package:mobile_labs/domain/models/outage_slot.dart';

abstract interface class OutageRepository {
  Future<List<OutageSlot>> getAll();
  Future<void> add(OutageSlot slot);
  Future<void> update(OutageSlot slot);
  Future<void> delete(String id);
}

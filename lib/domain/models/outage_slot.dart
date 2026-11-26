class OutageSlot {
  const OutageSlot({
    required this.id,
    required this.startHour,
    required this.endHour,
  });

  final String id;
  final int startHour;
  final int endHour;

  OutageSlot copyWith({int? startHour, int? endHour}) {
    return OutageSlot(
      id: id,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
    );
  }
}

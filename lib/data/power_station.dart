import 'package:material_ui/material_ui.dart';

class OutputPort {
  const OutputPort({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.isOn,
  });

  final String name;
  final String subtitle;
  final IconData icon;
  final bool isOn;
}

class OutageSlot {
  const OutageSlot({required this.startHour, required this.endHour});

  final int startHour;
  final int endHour;
}

class PowerStation {
  const PowerStation({
    required this.name,
    required this.batteryPercent,
    required this.inputWatts,
    required this.outputWatts,
    required this.consumptionWatts,
    required this.outputs,
    required this.outages,
  });

  final String name;
  final int batteryPercent;
  final int inputWatts;
  final int outputWatts;
  final int consumptionWatts;
  final List<OutputPort> outputs;
  final List<OutageSlot> outages;
}

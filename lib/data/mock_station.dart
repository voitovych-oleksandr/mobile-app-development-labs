import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/data/power_station.dart';

abstract final class MockStation {
  static const PowerStation station = PowerStation(
    name: 'Станція PP-1000',
    batteryPercent: 72,
    inputWatts: 180,
    outputWatts: 120,
    consumptionWatts: 95,
    outputs: <OutputPort>[
      OutputPort(
        name: 'AC',
        subtitle: '220 В, до 1000 Вт',
        icon: Icons.power,
        isOn: true,
      ),
      OutputPort(
        name: 'USB',
        subtitle: '5 В, до 30 Вт',
        icon: Icons.usb,
        isOn: true,
      ),
      OutputPort(
        name: 'DC',
        subtitle: '12 В, до 120 Вт',
        icon: Icons.battery_charging_full,
        isOn: false,
      ),
    ],
  );
}

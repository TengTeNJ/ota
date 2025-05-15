// event_bus_manager.dart
import 'package:event_bus/event_bus.dart';

class EventBusManager {
  static EventBusManager? _instance;
  EventBus eventBus = EventBus();

  factory EventBusManager() => _getInstance();
  EventBusManager._internal();

  static EventBusManager _getInstance() {
    if (_instance == null) {
      _instance = EventBusManager._internal();
    }
    return _instance!;
  }
}

// events.dart
class DataUpdatedEvent {
  final String data;

  DataUpdatedEvent(this.data);
}



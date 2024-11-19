import '../../models/ChargerStation.dart';

abstract class ChargerState {}

class ChargerInitial extends ChargerState {}

class ChargerLoading extends ChargerState {}

class ChargerLoaded extends ChargerState {
  final List<ChargerStation> stations;

  ChargerLoaded(this.stations);
}

class ChargerError extends ChargerState {
  final String message;

  ChargerError(this.message);
}

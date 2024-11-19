import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../models/ChargerStation.dart';
import 'charger_event.dart';
import 'charger_state.dart';

class ChargerBloc extends Bloc<ChargerEvent, ChargerState> {
  ChargerBloc() : super(ChargerInitial());

  final Dio _dio = Dio();

  @override
  Stream<ChargerState> mapEventToState(ChargerEvent event) async* {
    if (event is FetchChargers) {
      yield ChargerLoading();
      try {
        final response = await _dio.get(
          'https://api.openchargemap.io/v3/poi/',
          queryParameters: {
            'output': 'json',
            'latitude': 28.6139,
            'longitude': 77.2090,
            'distance': 10,
            'maxresults': 50,
            'key': 'b6fc64fc-7fc4-42d0-9f75-bcc95637398e',
          },
        );

        final List data = response.data;
        final chargers = data.map((e) => ChargerStation.fromJson(e)).toList();

        yield ChargerLoaded(chargers);
      } catch (error) {
        yield ChargerError("Failed to fetch data: $error");
      }
    }
  }
}

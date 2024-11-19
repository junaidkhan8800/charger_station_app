import 'package:charging_station_app/models/ChargerStation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewModel/charger_bloc/charger_bloc.dart';
import '../viewModel/charger_bloc/charger_event.dart';
import '../viewModel/charger_bloc/charger_state.dart';
import 'chargerdetails.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChargerBloc()..add(FetchChargers()),
      child: const ChargerStationListScreen(),
    );
  }
}


class ChargerStationListScreen extends StatelessWidget {
  const ChargerStationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: screenWidth * 0.02),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for a charger point',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const Icon(Icons.mic, color: Colors.grey),
                  ],
                ),
              ),
            ),
            // Charger Station Cards
            Expanded(
              child: BlocBuilder<ChargerBloc, ChargerState>(
                builder: (context, state) {
                  if (state is ChargerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChargerLoaded) {
                    final stations = state.stations;
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      itemCount: stations.length,
                      itemBuilder: (context, index) {
                        final station = stations[index];
                        return GestureDetector(
                          onTap: () {
                            final stationData = {
                              'name': 'HP Station',
                              'address': '474 Sc Dhaka, Bangladesh',
                              'power': '50kw',
                              'cost': '\$50',
                              'chargingTime': '00:07:00',
                              'currentLevel': '25%',
                              'remainingTime': '00:33:00',
                              'approxCost': '\$150 - \$200',
                            };

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChargerDetails(stationData: stationData),
                              ),
                            );
                          },

                          child: Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                            child: ChargerStationCard(
                              screenWidth: screenWidth,
                              station: station,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ChargerError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("No data available."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChargerStationCard extends StatelessWidget {
  final double screenWidth;
  final ChargerStation station;

  const ChargerStationCard({
    super.key,
    required this.screenWidth,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Charger Image
              Container(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://via.placeholder.com/150',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              // Station Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      station.address,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${station.distance} km away',
                          style: const TextStyle(fontSize: 14, color: Colors.green),
                        ),
                      ],
                    ),
                    const ChargerDetailsRow()
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChargerInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const ChargerInfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, color: Colors.blue),
        ),
      ],
    );
  }
}

class ChargerDetailsRow extends StatelessWidget {
  const ChargerDetailsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ChargerInfoTile(label: 'Type 3', value: 'Connection'),
          Container(
            width: 1,
            height: 35,
            color: Colors.blue,
          ),
          const ChargerInfoTile(label: '\$0.7', value: 'Per kwh'),
          Container(
            width: 1,
            height: 35,
            color: Colors.blue,
          ),
          const ChargerInfoTile(label: '\$0.1', value: 'Parking Fee'),
        ],
      ),
    );
  }
}
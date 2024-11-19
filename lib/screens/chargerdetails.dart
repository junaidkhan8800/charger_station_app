import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChargerDetails extends StatefulWidget {
  final Map<String, String> stationData;

  const ChargerDetails({super.key, required this.stationData});

  @override
  State<ChargerDetails> createState() => _ChargerDetailsState();
}

class _ChargerDetailsState extends State<ChargerDetails> {
  @override
  Widget build(BuildContext context) {
    return ChargingScreen(stationData: widget.stationData);
  }
}


class ChargingScreen extends StatelessWidget {
  final Map<String, String> stationData;

  const ChargingScreen({super.key, required this.stationData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          stationData['name'] ?? 'Charging Station',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Details Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoTile('Total Used', stationData['power'] ?? 'N/A'),
                _buildInfoTile('Total Cost', stationData['cost'] ?? 'N/A'),
                _buildInfoTile(
                    'Charging Time', stationData['chargingTime'] ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 95),

            // Circular Percentage Indicator
            CircularPercentIndicator(
              radius: screenWidth * 0.40,
              lineWidth: 50,
              percent: double.parse(
                  stationData['currentLevel']?.replaceAll('%', '') ?? '0') /
                  100,
              reverse: true,
              linearGradient: const LinearGradient(
                  colors: [Colors.blue, Colors.green]),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.battery_charging_full,
                      size: 40, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    stationData['currentLevel'] ?? '0%',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Text('Current Level',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 95),

            // Cards Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusCard(
                  Icons.battery_charging_full,
                  'Battery Power',
                  stationData['power'] ?? 'N/A',
                  Colors.red.shade50,
                  Colors.red,
                ),
                _buildStatusCard(
                  Icons.currency_rupee_rounded,
                  'Approx. Cost',
                  stationData['approxCost'] ?? 'N/A',
                  Colors.blue.shade50,
                  Colors.blue,
                ),
                _buildStatusCard(
                  Icons.access_time_filled_rounded,
                  'Remain. Time',
                  stationData['remainingTime'] ?? 'N/A',
                  Colors.yellow.shade50,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stop Charging Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(screenWidth * 0.9, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Stop Charging',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatusCard(IconData icon, String title, String value,
      Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: textColor),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

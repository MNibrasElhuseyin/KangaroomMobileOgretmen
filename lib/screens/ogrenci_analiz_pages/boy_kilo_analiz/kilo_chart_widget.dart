import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KiloChart extends StatelessWidget {
  final List<double> kilolar;
  final List<String> tarihler;

  const KiloChart({super.key, required this.kilolar, required this.tarihler});

  @override
  Widget build(BuildContext context) {
    List<double> filteredKilolar = [];
    List<String> filteredTarihler = [];

    int total = kilolar.length;
    if (total <= 5) {
      filteredKilolar = kilolar;
      filteredTarihler = tarihler;
    } else {
      int step = (total - 1) ~/ 4;
      for (int i = 0; i < 5; i++) {
        int index = (i == 4) ? total - 1 : i * step;
        filteredKilolar.add(kilolar[index]);
        filteredTarihler.add(tarihler[index]);
      }
    }

    return BarChart(
      BarChartData(
        barGroups: List.generate(
          filteredKilolar.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: filteredKilolar[index],
                width: 16,
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int i = value.toInt();
                if (i >= 0 && i < filteredTarihler.length) {
                  return Transform.rotate(
                    angle: -0.6, // daha fazla eğim
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _kisaTarih(filteredTarihler[i]),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: _maxY(filteredKilolar),
      ),
    );
  }

  String _kisaTarih(String tamTarih) {
    final parts = tamTarih.split('.');
    if (parts.length >= 2) {
      return "${parts[0]}.${parts[1]}"; // Gün.Ay
    }
    return tamTarih;
  }

  double _maxY(List<double> values) {
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max + 10).ceilToDouble(); // grafiğin üstünde boşluk bırak
  }
}

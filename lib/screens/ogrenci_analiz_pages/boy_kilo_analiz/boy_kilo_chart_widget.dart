import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

class BoyChart extends StatelessWidget {
  final List<double> boylar;
  final List<String> tarihler;

  const BoyChart({super.key, required this.boylar, required this.tarihler});

  @override
  Widget build(BuildContext context) {
    List<double> filteredBoylar = [];
    List<String> filteredTarihler = [];

    int total = boylar.length;
    if (total <= 5) {
      filteredBoylar = boylar;
      filteredTarihler = tarihler;
    } else {
      int step = (total / 4).floor();
      for (int i = 0; i < 5; i++) {
        int index = (i == 4) ? total - 1 : i * step;
        filteredBoylar.add(boylar[index]);
        filteredTarihler.add(tarihler[index]);
      }
    }

    return BarChart(
      BarChartData(
        barGroups: List.generate(
          filteredBoylar.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: filteredBoylar[index],
                width: 20,
                color: AppConstants.accentColor,
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
                    angle: -0.5,
                    child: Text(
                      _kisaTarih(filteredTarihler[i]),
                      style: const TextStyle(fontSize: 10),
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
      ),
    );
  }

  String _kisaTarih(String tamTarih) {
    final parts = tamTarih.split('.');
    if (parts.length >= 2) {
      return "${parts[0]}.${parts[1]}";
    }
    return tamTarih;
  }
}

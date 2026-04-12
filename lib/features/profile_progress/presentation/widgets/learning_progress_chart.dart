import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LearningProgressChart extends StatelessWidget {
  final Map<DateTime, int> data; // Key là ngày, Value là số từ vựng

  const LearningProgressChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'Chưa có dữ liệu học tập.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        ),
      );
    }

    // Xử lý data để lấy ra danh sách ngày liên tục
    final sortedDates = data.keys.toList()..sort();

    List<FlSpot> spots = [];
    int maxWords = 0;
    
    // Giới hạn hiển thị khoảng 7 điểm cho biểu đồ đỡ rối, 
    // hoặc vẽ tất cả nhưng label trục X chia đều.
    // Ở đây ta cứ vẽ theo daysDiff
    int index = 0;
    for (var date in sortedDates) {
      final val = data[date]!;
      spots.add(FlSpot(index.toDouble(), val.toDouble()));
      if (val > maxWords) {
        maxWords = val;
      }
      index++;
    }

    // Đề phòng maxY
    final maxY = maxWords > 0 ? (maxWords * 1.5).toDouble() : 10.0;

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (spots.length - 1).toDouble() > 0 ? (spots.length - 1).toDouble() : 1.0,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: AppColors.primary,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withAlpha(30),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Chỉ hiển thị nhãn nếu là số nguyên
                  if (value % 1 != 0) return const SizedBox.shrink();
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                  );
                },
                reservedSize: 28,
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final int labelIndex = value.toInt();
                  if (labelIndex >= 0 && labelIndex < sortedDates.length) {
                    final date = sortedDates[labelIndex];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('dd/MM').format(date),
                        style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                interval: 1, // Hiển thị nhãn mỗi điểm dữ liệu
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxWords > 0 ? (maxY / 4) : 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: AppColors.surfaceBorder,
                strokeWidth: 1,
                dashArray: [4, 4], // Nét đứt
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toInt()} từ',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}

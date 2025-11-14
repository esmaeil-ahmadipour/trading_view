import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trading_view/data/candle.dart';
import 'package:trading_view/repository/candle_repository.dart';

// Separate widget for volume chart with preserved state
class VolumeChartWidget extends StatefulWidget {
  final CandleRepository repo;
  final bool running;

  const VolumeChartWidget({
    super.key,
    required this.repo,
    required this.running,
  });

  @override
  State<VolumeChartWidget> createState() => VolumeChartWidgetState();
}

class VolumeChartWidgetState extends State<VolumeChartWidget> {
  late List<Candle> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.repo.candles;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Candle>>(
      stream: widget.running ? widget.repo.candlesStream : null,
      builder: (context, snapshot) {
        // Only update data when we have new data
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _currentData = snapshot.data!;
        }

        return SfCartesianChart(
          key: ValueKey(_currentData.length), // Preserve chart state
          backgroundColor: Colors.black,
          plotAreaBackgroundColor: Colors.black,
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.minutes,
            labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          series: <ColumnSeries<Candle, DateTime>>[
            ColumnSeries<Candle, DateTime>(
              dataSource: _currentData,
              xValueMapper: (candle, _) => candle.time,
              yValueMapper: (candle, _) => candle.volume,
              pointColorMapper: (candle, _) => candle.close >= candle.open
                  ? Colors.green.shade700
                  : Colors.red.shade700,
              animationDuration: 0, // Disable animation for better performance
            ),
          ],
        );
      },
    );
  }
}

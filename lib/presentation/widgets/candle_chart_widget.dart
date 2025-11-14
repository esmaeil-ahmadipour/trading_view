import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trading_view/data/candle.dart';
import 'package:trading_view/repository/candle_repository.dart';

// Separate widget for candle chart with preserved state
class CandleChartWidget extends StatefulWidget {
  final CandleRepository repo;
  final bool running;
  final ZoomPanBehavior zoom;
  final TrackballBehavior trackball;

  const CandleChartWidget({
    super.key,
    required this.repo,
    required this.running,
    required this.zoom,
    required this.trackball,
  });

  @override
  State<CandleChartWidget> createState() => CandleChartWidgetState();
}

class CandleChartWidgetState extends State<CandleChartWidget> {
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
          zoomPanBehavior: widget.zoom,
          trackballBehavior: widget.trackball,
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.minutes,
            labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 11),
            majorGridLines: MajorGridLines(color: Colors.grey.shade900),
          ),
          primaryYAxis: NumericAxis(
            opposedPosition: true,
            labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 11),
            majorGridLines: MajorGridLines(color: Colors.grey.shade900),
          ),
          series: <CandleSeries<Candle, DateTime>>[
            CandleSeries<Candle, DateTime>(
              dataSource: _currentData,
              xValueMapper: (candle, _) => candle.time,
              lowValueMapper: (candle, _) => candle.low,
              highValueMapper: (candle, _) => candle.high,
              openValueMapper: (candle, _) => candle.open,
              closeValueMapper: (candle, _) => candle.close,
              bullColor: Colors.green,
              bearColor: Colors.red,
              animationDuration: 0, // Disable animation for better performance
            ),
          ],
        );
      },
    );
  }
}

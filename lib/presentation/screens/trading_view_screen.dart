import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trading_view/data/candle.dart';
import 'package:trading_view/presentation/widgets/candle_chart_widget.dart'
    show CandleChartWidget;
import 'package:trading_view/presentation/widgets/header_widget.dart'
    show HeaderWidget;
import 'package:trading_view/presentation/widgets/volume_chart_widget.dart'
    show VolumeChartWidget;
import 'package:trading_view/repository/candle_repository.dart';

class TradingViewScreen extends StatefulWidget {
  final CandleRepository repo;

  const TradingViewScreen({super.key, required this.repo});

  @override
  State<TradingViewScreen> createState() => _TradingViewScreenState();
}

class _TradingViewScreenState extends State<TradingViewScreen> {
  late ZoomPanBehavior _zoom;
  late TrackballBehavior _trackball;
  final bool _running = true;

  // Unique keys to preserve chart state
  final UniqueKey _candleChartKey = UniqueKey();
  final UniqueKey _volumeChartKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    _zoom = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );

    _trackball = TrackballBehavior(
      enable: true,
      lineType: TrackballLineType.vertical,
      activationMode: ActivationMode.longPress,
    );

    widget.repo.start();
  }

  @override
  void dispose() {
    widget.repo.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "TradingView - WS Backend",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Header - Only rebuilds when last candle changes
          ValueListenableBuilder<Candle?>(
            valueListenable: widget.repo.lastCandleNotifier,
            builder: (context, lastCandle, child) {
              return HeaderWidget(lastCandle: lastCandle, repo: widget.repo);
            },
          ),

          // Candle Chart - Preserves zoom/pan state
          Expanded(
            flex: 3,
            child: CandleChartWidget(
              key: _candleChartKey,
              repo: widget.repo,
              running: _running,
              zoom: _zoom,
              trackball: _trackball,
            ),
          ),

          // Volume Chart - Preserves state
          Expanded(
            flex: 1,
            child: VolumeChartWidget(
              key: _volumeChartKey,
              repo: widget.repo,
              running: _running,
            ),
          ),
        ],
      ),
    );
  }
}

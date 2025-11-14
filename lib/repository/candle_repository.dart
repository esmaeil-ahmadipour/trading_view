import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/candle.dart';
import '../data/candle_service.dart';

class CandleRepository with ChangeNotifier {
  final CandleWebSocketService service;
  final List<Candle> _candles = [];
  final StreamController<List<Candle>> _candlesController =
      StreamController<List<Candle>>.broadcast();
  final ValueNotifier<Candle?> _lastCandleNotifier = ValueNotifier<Candle?>(
    null,
  );

  // Throttle updates to prevent too many rebuilds
  Timer? _throttleTimer;
  List<Candle> _pendingCandles = [];

  List<Candle> get candles => List.unmodifiable(_candles);
  Candle? get lastCandle => _candles.isNotEmpty ? _candles.last : null;
  ValueNotifier<Candle?> get lastCandleNotifier => _lastCandleNotifier;
  Stream<List<Candle>> get candlesStream => _candlesController.stream;

  CandleRepository(this.service);

  Future<void> start() async {
    await service.connect();

    service.stream.listen(
      (data) {
        try {
          final type = data['type'];

          if (type == 'seed') {
            _handleSeedData(data);
          } else if (type == 'update') {
            _handleUpdateData(data);
          } else if (type == 'new') {
            _handleNewData(data);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error processing WebSocket message: $e');
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('WebSocket error: $error');
        }
      },
    );
  }

  void _handleSeedData(Map<String, dynamic> data) {
    final List<dynamic> seedData = data['data'];
    _candles.clear();
    _candles.addAll(seedData.map((item) => Candle.fromJson(item)).toList());
    _emitCandlesUpdate();
    _lastCandleNotifier.value = lastCandle;
  }

  void _handleUpdateData(Map<String, dynamic> data) {
    if (_candles.isNotEmpty) {
      final updatedCandle = Candle.fromJson(data['data']);
      _candles[_candles.length - 1] = updatedCandle;
      _throttleCandlesUpdate();
      _lastCandleNotifier.value = updatedCandle;
    }
  }

  void _handleNewData(Map<String, dynamic> data) {
    final newCandle = Candle.fromJson(data['data']);
    _candles.add(newCandle);
    if (_candles.length > 100) {
      _candles.removeAt(0);
    }
    _throttleCandlesUpdate();
    _lastCandleNotifier.value = newCandle;
  }

  void _throttleCandlesUpdate() {
    _pendingCandles = List.from(_candles);

    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(milliseconds: 50), () {
      _emitCandlesUpdate();
    });
  }

  void _emitCandlesUpdate() {
    _candlesController.add(
      List.from(_pendingCandles.isNotEmpty ? _pendingCandles : _candles),
    );
    _pendingCandles.clear();
  }

  void clearData() {
    _candles.clear();
    _pendingCandles.clear();
    _throttleTimer?.cancel();
    _candlesController.add(List.from(_candles));
    _lastCandleNotifier.value = null;
  }

  Future<void> stop() async {
    _throttleTimer?.cancel();
    await service.close();
  }
}

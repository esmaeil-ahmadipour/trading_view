import 'package:flutter/material.dart';
import 'package:trading_view/data/candle_service.dart';
import 'package:trading_view/presentation/screens/trading_view_screen.dart'
    show TradingViewScreen;
import 'package:trading_view/repository/candle_repository.dart'
    show CandleRepository;

void main() {
  runApp(const CandleApp());
}

class CandleApp extends StatelessWidget {
  const CandleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wsService = CandleWebSocketService("ws://localhost:3000/ws");
    final repo = CandleRepository(wsService);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TradingViewScreen(repo: repo),
    );
  }
}

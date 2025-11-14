import 'package:flutter/material.dart';
import 'package:trading_view/data/candle.dart';
import 'package:trading_view/repository/candle_repository.dart';

// Header widget
class HeaderWidget extends StatelessWidget {
  final Candle? lastCandle;
  final CandleRepository repo;

  const HeaderWidget({super.key, required this.lastCandle, required this.repo});

  @override
  Widget build(BuildContext context) {
    if (lastCandle == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        color: Colors.grey.shade900,
        child: const Text(
          "Connecting...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final candles = repo.candles;
    final prev = candles.length > 1
        ? candles[candles.length - 2].close
        : lastCandle!.open;
    final change = lastCandle!.close - prev;
    final pct = (change / prev) * 100;
    final isPositive = change >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      color: Colors.grey.shade900,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$${lastCandle!.close.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${isPositive ? '+' : ''}${change.toStringAsFixed(2)} (${isPositive ? '+' : ''}${pct.toStringAsFixed(2)}%)",
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildHeaderItem("O", lastCandle!.open),
              _buildHeaderItem("H", lastCandle!.high),
              _buildHeaderItem("L", lastCandle!.low),
              _buildHeaderItem("V", lastCandle!.volume),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String label, double value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        Text(
          label == 'V'
              ? value.toStringAsFixed(0)
              : "\$${value.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

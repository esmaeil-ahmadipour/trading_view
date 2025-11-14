import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class CandleWebSocketService {
  final String url;
  WebSocketChannel? _channel;
  final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();

  bool _closedByUser = false;

  CandleWebSocketService(this.url);

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        (event) {
          try {
            _controller.add(jsonDecode(event));
          } catch (_) {}
        },
        onDone: _reconnect,
        onError: (e) => _reconnect(),
      );
    } catch (e) {
      _reconnect();
    }
  }

  Stream<dynamic> get stream => _controller.stream;

  void _reconnect() {
    if (_closedByUser) return;

    Future.delayed(const Duration(seconds: 2), () {
      connect();
    });
  }

  Future<void> close() async {
    _closedByUser = true;
    await _channel?.sink.close();
    await _controller.close();
  }
}

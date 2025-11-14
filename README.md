# Flutter Trading View

A sample , real-time trading chart interface built with Flutter.  
This application features live WebSocket data streaming, interactive candlestick charts, and synchronized volume indicators , providing a powerful tool for market analysis.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

---

## ✨ Features

- **Real-time Candlestick Charts**  
  Interactive OHLC charts with professional styling and color-coded bull/bear candles.
- **Live WebSocket Integration**  
  Persistent, real-time data streaming using WebSocket.
- **Synchronized Volume Indicators**  
  Volume bars displayed in a separate chart, color-matched to candle direction.
- **Interactive Chart Tools**  
  Zooming, panning, and trackball support for detailed data inspection.
- **Optimized Performance**  
  Smooth performance with efficient state management and streaming.
- **Responsive Design**  
  Works seamlessly on mobile, tablet, and desktop.

---

## 🏗 Project Architecture

This project follows a layered architecture for clean separation of concerns, testability, and maintainability.

*(Add your architecture diagram or explanation here)*

---

## 🚀 Getting Started

### **Prerequisites**

- **Flutter SDK**: `>= 3.0.0`
- **Dart SDK**: `>= 2.17.0`
- A WebSocket server providing real-time candle data

---

## 🔧 Installation

### **1. Clone the repository**
```bash
git clone https://github.com/esmaeil-ahmadipour/trading_view.git
cd trading_view
2. Install dependencies
bash
Copy code
flutter pub get
3. Run the application
bash
Copy code
flutter run
```

##  📡 Backend Data Format
The app connects to a WebSocket endpoint (e.g., ws://localhost:3000/ws)
and expects messages of these types:

* seed – Initial list of candles

* update – Modify the last candle

* new – Add a completely new candle

📥 Example Seed Message
```json
{
  "type": "seed",
  "data": [
    {
      "time": "2024-01-15T09:00:00.000Z",
      "open": 100.0,
      "high": 105.0,
      "low": 95.0,
      "close": 102.0,
      "volume": 500.0
    }
  ]
}
```

📥 Example Update Message
```json
{
  "type": "update",
  "data": {
    "time": "2024-01-15T10:00:00.000Z",
    "open": 102.0,
    "high": 108.0,
    "low": 101.0,
    "close": 106.0,
    "volume": 600.0
  }
}
```
##  📦 Dependencies
This project leverages the following Flutter packages:

Package	Version	Description:

```syncfusion_flutter_charts: ^31.1.19``` High-quality and professional charting library

```web_socket_channel: ^2.4.0```  WebSocket communication for real-time data

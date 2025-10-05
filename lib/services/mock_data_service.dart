import 'dart:async';
import 'dart:math';

class SensorSnapshot {
  final String rollNo;
  final String lotNo;
  final double lengthM;   // cumulative
  final double widthCm;
  final double gsm;
  final bool hole;
  final DateTime ts;
  final List<double> gsmHistory;   // last N points for sparkline
  final List<double> widthHistory; // last N points

  SensorSnapshot({
    required this.rollNo,
    required this.lotNo,
    required this.lengthM,
    required this.widthCm,
    required this.gsm,
    required this.hole,
    required this.ts,
    required this.gsmHistory,
    required this.widthHistory,
  });

  SensorSnapshot copyWith({
    String? rollNo,
    String? lotNo,
    double? lengthM,
    double? widthCm,
    double? gsm,
    bool? hole,
    DateTime? ts,
    List<double>? gsmHistory,
    List<double>? widthHistory,
  }) {
    return SensorSnapshot(
      rollNo: rollNo ?? this.rollNo,
      lotNo: lotNo ?? this.lotNo,
      lengthM: lengthM ?? this.lengthM,
      widthCm: widthCm ?? this.widthCm,
      gsm: gsm ?? this.gsm,
      hole: hole ?? this.hole,
      ts: ts ?? this.ts,
      gsmHistory: gsmHistory ?? this.gsmHistory,
      widthHistory: widthHistory ?? this.widthHistory,
    );
  }
}

class MockDataService {
  MockDataService({this.machineId = 'M1'});
  final String machineId;

  final _rng = Random();
  final _ctrl = StreamController<SensorSnapshot>.broadcast();
  Timer? _timer;

  // state
  late SensorSnapshot _state;

  Stream<SensorSnapshot> get stream => _ctrl.stream;

  void start() {
    // initial state
    _state = SensorSnapshot(
      rollNo: 'R-${1000 + _rng.nextInt(9000)}',
      lotNo: 'L-${7000 + _rng.nextInt(2999)}',
      lengthM: 0,
      widthCm: 180 + _rng.nextDouble() * 20, // 180 to 200
      gsm: 110 + _rng.nextDouble() * 30,     // 110 to 140
      hole: false,
      ts: DateTime.now(),
      gsmHistory: <double>[],
      widthHistory: <double>[],
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      _tick();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _tick() {
    // random walk
    final width = (_state.widthCm + _jitter(0.6)).clamp(175.0, 205.0);
    final gsm = (_state.gsm + _jitter(0.8)).clamp(100.0, 150.0);
    final len = _state.lengthM + 0.12; // 0.12 m every 300 ms -> ~24 m per min

    // rare hole event
    final holeNow = _rng.nextDouble() < 0.02 ? true : false;
    final hole = holeNow ? true : false;

    final hGsm = [..._state.gsmHistory, gsm];
    final hW = [..._state.widthHistory, width];
    const maxPts = 120; // last ~36 s window
    if (hGsm.length > maxPts) hGsm.removeRange(0, hGsm.length - maxPts);
    if (hW.length > maxPts) hW.removeRange(0, hW.length - maxPts);

    _state = _state.copyWith(
      widthCm: width,
      gsm: gsm,
      lengthM: len,
      hole: holeNow ? true : ( // keep hole true for a short burst
          _state.hole && _rng.nextDouble() < 0.7
      ),
      ts: DateTime.now(),
      gsmHistory: hGsm,
      widthHistory: hW,
    );

    _ctrl.add(_state);
  }

  double _jitter(double scale) => (_rng.nextDouble() - 0.5) * 2 * scale;
}

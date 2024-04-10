import 'package:flutter/material.dart';
import 'package:flutter_pd/flutter_pd.dart';

class Spatialization extends StatefulWidget {
  @override
  _SpatializationState createState() => _SpatializationState();
}

class _SpatializationState extends State<Spatialization> {
  final _pd = FlutterPd.instance;
  late PdFileHandle _pdFileHandle;

  final _patchFilePath = 'pd-patches/main/spatialization.pd';
  double _azimuth = 0.0;

  @override
  void initState() {
    super.initState();
    _setupPd();
  }

  @override
  void dispose() {
    _pdFileHandle.close();
    _pd.stopPd();
    super.dispose();
  }

  Future<bool> _setupPd() async {
    await _pd.startPd();

    _pdFileHandle = await _pd.openPatch(_patchFilePath);

    await _pd.startAudio(
      requireInput: false,
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spatialization demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Azimuth:'),
              Slider(
                onChanged: _changeAzimuth,
                value: _azimuth,
                min: -180,
                max: 180,
                divisions: 360,
                label: _azimuth.toStringAsFixed(0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeAzimuth(double newValue) {
    _pd.send('azimuth', newValue);
    setState(() {
      _azimuth = newValue;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_pd/flutter_pd.dart';

class SimpleSin extends StatefulWidget {
  @override
  _SimpleSinState createState() => _SimpleSinState();
}

class _SimpleSinState extends State<SimpleSin> {
  final _pd = FlutterPd.instance;
  late PdFileHandle _pdFileHandle;

  final _patchFilePath = 'pd-patches/main/simple_sin.pd';

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
    
    // Open the patch from the app's local cache storage.
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
        title: Text('Simple sin'),
      ),
      body: Center(
        child: Text('Playing $_patchFilePath'),
      ),
    );
  }
}

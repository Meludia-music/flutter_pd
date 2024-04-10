import 'package:flutter/material.dart';
import 'package:flutter_pd/flutter_pd.dart';

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class SoundfilePlayer extends StatefulWidget {
  @override
  _SoundfilePlayerState createState() => _SoundfilePlayerState();
}

class _SoundfilePlayerState extends State<SoundfilePlayer> {
  final _pd = FlutterPd.instance;
  late PdFileHandle _pdFileHandle;

  final _patchFilePath = 'pd-patches/main/soundfile_player.pd';
  bool _isPlaying = false;

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
    // this step can be skipped because simple_sin_with_volume.pd does not require audio input.
    // final hasPermission = await pd.checkPermission();
    // if (!hasPermission) {
    //   return false;
    // }

    await _pd.startPd();

    _pdFileHandle = await _pd.openPatch(_patchFilePath);

    await _pd.startAudio(
      requireInput: false,
    );

    // Copy the soundfile "audio/falling.wav" to the app's local storage.
    // This is necessary because the [openfile] message in the Pure Data patch
    // expects a file path, and the file path must be accessible to the Pure Data engine.
    // ToDo
    final byteData = await rootBundle.load('assets/audio/falling.wav');
    final List<int> bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    
    final Directory dir = await getApplicationDocumentsDirectory();
    // create the directory if it does not exist
    final Directory audioDir = Directory('${dir.path}/audio');
    if (!audioDir.existsSync()) {
      audioDir.createSync();
    }
    final File file = File('${dir.path}/audio/falling.wav');
    
    await file.writeAsBytes(bytes);
    print('File copied to ${file.path}');

    // load the audio file called "audio/falling.wav", by sending a message to the [openfile] receiver.
    // await _pd.send('openfile', 'audio/falling.wav');
    await _pd.send('openfile', '${dir.path}/audio/falling.wav');

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opens a file and control playback: play/stop.'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Playback:'),
              Switch(
                onChanged: _togglePlayback,
                value: _isPlaying,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePlayback(bool newValue) {
    _pd.send('playback_command', newValue ? 'play' : 'stop');
    setState(() {
      _isPlaying = newValue;
    });
  }
}

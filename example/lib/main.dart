import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';

import 'home_page.dart';
import 'microphone_meter.dart';
import 'simple_sin.dart';
import 'simple_sin_with_volume.dart';
import 'soundfile_player.dart';
import 'spatialization.dart';

import 'package:path_provider/path_provider.dart';

import 'package:flutter_archive/flutter_archive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Copy the 'assets/pd-patches.zip' file to the app's local cache storage,
    // and extract the contents to 'pd-patches' directory.

    Future<void> copyPdPatches() async {
      print('Copying pd-patches to app cache directory');

      final appCacheDir = await getApplicationCacheDirectory();
      final pdPatchesZip = File('${appCacheDir.path}/pd-patches.zip');

      if (!await pdPatchesZip.exists()) {
        final data = await rootBundle.load('assets/pd-patches.zip');
        final bytes = data.buffer.asUint8List();
        await pdPatchesZip.writeAsBytes(bytes);
      }

      try {
        await ZipFile.extractToDirectory(
          zipFile: pdPatchesZip,
          destinationDir: appCacheDir,
        );
        print('Extracted pd-patches.zip to $appCacheDir/pd-patches');
      } catch (e) {
        print('Error extracting pd-patches.zip: $e');
        return;
      }
    }

    // Call the function "copyPdPatches()" if we are running on Android.
    if (Platform.isAndroid) {
      copyPdPatches();
    }

    return MaterialApp(
      routes: {
        '/': (_) => HomePage(),
        '/simple_sin': (_) => SimpleSin(),
        '/simple_sin_with_volume': (_) => SimpleSinWithVolume(),
        '/microphone_meter': (_) => MicrophoneMeter(),
        '/soundfile_player': (_) => SoundfilePlayer(),
        '/spatialization': (_) => Spatialization(),
      },
    );
  }
}

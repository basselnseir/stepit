import 'dart:math';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/cam_mode_notifier.dart';

class PipModeNotifier with ChangeNotifier {
  bool _inPipMode = false;
  final floating = Floating();

  bool get inPipMode => _inPipMode;

  set inPipMode(bool value) {
    _inPipMode = value;
    notifyListeners();
  }

  Scaffold setPipModeImg(){
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/stepit_logo.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> enablePip(BuildContext context) async {
    final camModeNotifier = Provider.of<CamModeNotifier>(context, listen: false);
    if (camModeNotifier.inCamMode) {
      return;
    }
    // const rational = Rational.landscape();
    // const rational = Rational(38, 39);
    const rational = Rational(1, 1);
    final screenSize =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final status = await floating.enable(
      aspectRatio: rational,
      sourceRectHint: Rectangle<int>(
        0,
        (screenSize.height ~/ 2) - (height ~/ 2),
        screenSize.width.toInt(),
        height,
      ),
    );
    debugPrint('PiP enabled? $status');

    if (status == PiPStatus.enabled) {
      inPipMode = true;
    }
  }
}




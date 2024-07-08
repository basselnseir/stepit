import 'package:flutter/material.dart';

class CamModeNotifier with ChangeNotifier {
  bool _inCamMode = false;

  bool get inCamMode => _inCamMode;

  set inCamMode(bool value) {
    _inCamMode = value;
    notifyListeners();
  }

  // Scaffold setCamModeImg(){
  //   return Scaffold(
  //     body: Container(
  //       decoration: const BoxDecoration(
  //         image: DecorationImage(
  //           image: AssetImage('lib/images/walking_sausage.gif'),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> enablePip(BuildContext context) async {
  //   // const rational = Rational.landscape();
  //   // const rational = Rational(38, 39);
  //   const rational = Rational(1, 1);
  //   final screenSize =
  //       MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
  //   final height = screenSize.width ~/ rational.aspectRatio;

  //   final status = await floating.enable(
  //     aspectRatio: rational,
  //     sourceRectHint: Rectangle<int>(
  //       0,
  //       (screenSize.height ~/ 2) - (height ~/ 2),
  //       screenSize.width.toInt(),
  //       height,
  //     ),
  //   );
  //   debugPrint('PiP enabled? $status');

  //   if (status == PiPStatus.enabled) {
  //     inPipMode = true;
  //   }
  // }
}




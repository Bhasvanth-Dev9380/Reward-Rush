

import 'dart:async';

Timer startCountdownTimer(DateTime nextScratchTime, void Function(Duration) onTick) {
  return Timer.periodic(Duration(seconds: 1), (timer) {
    final remainingTime = nextScratchTime.difference(DateTime.now());

    if (remainingTime.isNegative) {
      timer.cancel(); // Stop the timer if time is up
    }

    // Call the callback with the remaining time
    onTick(remainingTime);
  });
}

import 'dart:math';

randomNumber() {
  var rng = Random();
  for (var i = 0; i < 10; i++) {
    print(rng.nextInt(100));
  }
}

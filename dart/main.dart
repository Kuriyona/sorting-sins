// Sorting Sins - Dart

import 'dart:math';

void main() {
  var arr = List<int>.generate(100, (i) => i);
  var rng = Random();

  arr.sort((a, b) => rng.nextInt(3) - 1);

  print(arr);
}

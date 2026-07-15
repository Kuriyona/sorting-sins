// Sorting Sins - Dart

import 'dart:math';
import 'dart:io';

void main(List<String> args) {
  var n = args.isNotEmpty ? int.parse(args[0]) : 100;
  var arr = List<int>.generate(n, (i) => i);
  var rng = Random();

  arr.sort((a, b) => rng.nextInt(3) - 1);

  print(arr.take(100).toList());
}

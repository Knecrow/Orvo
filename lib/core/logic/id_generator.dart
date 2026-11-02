import 'dart:math';

final Random _random = Random();

String generateId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  final randomSuffix = _random.nextInt(0xFFFFFF).toRadixString(36).padLeft(4, '0');
  return '$timestamp-$randomSuffix';
}


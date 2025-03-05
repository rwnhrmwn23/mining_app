import 'dart:math';

String generateDeviceId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
  Random rnd = Random();
  return 'SID${String.fromCharCodes(Iterable.generate(12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))))}';
}
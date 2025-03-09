import 'dart:math';

import 'package:intl/intl.dart';

String generateDeviceId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
  Random rnd = Random();
  return 'SID${String.fromCharCodes(Iterable.generate(12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))))}';
}


String formatDateTime(String isoDateTime) {
  try {
    DateTime dateTime = DateTime.parse(isoDateTime).toLocal();
    String formattedDate = DateFormat("dd MMM yyyy, HH:mm").format(dateTime);
    return formattedDate;
  } catch (e) {
    return "Invalid Date";
  }
}

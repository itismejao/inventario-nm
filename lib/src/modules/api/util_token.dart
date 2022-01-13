import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

Future<String> getStringToken(String key) async {
  String value = '';

  await SharedPreferences.getInstance()
      .then((prefs) => {value = prefs.getString(key) ?? ''});

  return value;
}

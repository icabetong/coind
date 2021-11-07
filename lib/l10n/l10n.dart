import 'package:flutter/material.dart';
import 'package:coind/domain/locales_static.dart';

class L10n {
  static final all = languages.map((lang) => Locale(lang)).toList();
}

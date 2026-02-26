import 'package:flutter/widgets.dart';
import '../utils/language_model.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

extension I18nExt on BuildContext {
  String i18n(String key) {
    final languageModel = read<LanguageModel>();
    return languageModel.getText(Constants.keyToString(key, this));
  }
}
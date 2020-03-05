import 'package:sloboda/models/sloboda_localizations.dart';

abstract class StockItem<T> {
  String localizedKey;
  String localizedDescriptionKey;
  T type;
  int value;

  StockItem([this.value]);

  String toLocalizedString() {
    return SlobodaLocalizations.getForKey(localizedKey);
  }

  String toLocalizedDescriptionString() {
    return SlobodaLocalizations.getForKey(localizedDescriptionKey);
  }

  String toImagePath();

  String toIconPath();

  static StockItem fromType(type, [int value]) {
    throw UnimplementedError();
  }
}

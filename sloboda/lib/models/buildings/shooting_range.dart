import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/city_property.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

class ShootingRange implements Buildable<RESOURCE_TYPES> {
  String localizedKey = 'cityBuildings.shootingRange';
  CITY_PROPERTIES produces = CITY_PROPERTIES.COSSACKS;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.WOOD: 30,
  };

  Stock requiresForCossack = Stock({
    RESOURCE_TYPES.FOOD: 10,
    RESOURCE_TYPES.FIREARM: 1,
    RESOURCE_TYPES.HORSE: 1,
  });

  bool canProduceCossack(CityProps cityProps, Stock stock) {
    return requiresForCossack < stock &&
        cityProps.getByType(CITY_PROPERTIES.CITIZENS) >= 1;
  }

  Widget build(BuildContext context, Function callback, Sloboda city) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SoftContainer(
                    child: Image.asset(
                      image,
                      height: 320,
                    ),
                  ),
                ),
                VDivider(),
                SoftContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SlideableButton(
                              child: ButtonText(
                                  SlobodaLocalizations.trainCossacks),
                              onPress: () {
                                _tryToCreateCossack(city, callback);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                VDivider(),
                TitleText(SlobodaLocalizations.requiredForProductionBy),
                VDivider(),
                SoftContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StockFullView(
                      stock: requiresForCossack,
                      stockSimulation: null,
                    ),
                  ),
                ),
                VDivider(),
                SoftContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 9,
                          child: CityProperty(
                            property: CITY_PROPERTIES.CITIZENS,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(city.props
                              .getByType(CITY_PROPERTIES.CITIZENS)
                              .toString()),
                        ),
                      ],
                    ),
                  ),
                ),
                VDivider(),
                SoftContainer(
                  child: StockFullView(
                    stock: city.stock,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _tryToCreateCossack(Sloboda city, Function callback) {
    if (canProduceCossack(city.props, city.stock)) {
      city.stock - requiresForCossack;
      city.removeCitizens(amount: 1);
      city.props +
          CityProps(
            {
              CITY_PROPERTIES.COSSACKS: 1,
            },
          );
      callback();
    }
  }

  get icon {
    return 'images/city_buildings/shooting_range_64.png';
  }

  get image {
    return 'images/city_buildings/shooting_range.png';
  }
}

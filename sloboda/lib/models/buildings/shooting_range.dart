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
import 'package:sloboda/views/components/soft_container.dart';

class ShootingRange implements Buildable<RESOURCE_TYPES> {
  CITY_PROPERTIES produces = CITY_PROPERTIES.COSSACKS;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.WOOD: 30,
  };

  Map<RESOURCE_TYPES, int> requiresForCossack = {
    RESOURCE_TYPES.FOOD: 10,
    RESOURCE_TYPES.FIREARM: 1,
    RESOURCE_TYPES.HORSE: 1,
  };

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
                              child: ButtonText('Train cossacks'),
                              onPress: () {
                                city.stock +
                                    Stock(
                                      requiresForCossack.map(
                                        (key, value) => MapEntry(key, -value),
                                      ),
                                    );
                                city.props +
                                    CityProps(
                                      {
                                        CITY_PROPERTIES.CITIZENS: -1,
                                        CITY_PROPERTIES.COSSACKS: 1,
                                      },
                                    );
                                callback();
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
                    child: Column(
                      children: [
                        ...requiresForCossack.keys.map((type) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TitleText(localizedResourceByType(type)),
                              TitleText(requiresForCossack[type].toString()),
                            ],
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(
                              SlobodaLocalizations.citizens,
                            ),
                            TitleText(
                              '${city.props.getByType(CITY_PROPERTIES.CITIZENS)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                VDivider(),
                TitleText(
                  SlobodaLocalizations.stock,
                ),
                VDivider(),
                SoftContainer(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: [
                    RESOURCE_TYPES.FIREARM,
                    RESOURCE_TYPES.FOOD,
                    RESOURCE_TYPES.HORSE
                  ].map((type) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TitleText(localizedResourceByType(type)),
                        TitleText(city.stock.getByType(type).toString()),
                      ],
                    );
                  }).toList()),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  get icon {
    return 'images/city_buildings/shooting_range_64.png';
  }

  get image {
    return 'images/city_buildings/shooting_range.png';
  }
}

import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

Map<String, List<CityEvent>> foldEvents(List<CityEvent> events) {
  Map<String, List<CityEvent>> result = {};

  for (final e in events) {
    if (result.containsKey(
        e.yearHappened.toString() + ',' + e.season.toLocalizedKey())) {
      result[e.yearHappened.toString() + ',' + e.season.toLocalizedKey()]
          .add(e);
    } else {
      result[e.yearHappened.toString() + ',' + e.season.toLocalizedKey()] = [e];
    }
  }

  return result;
}

class EventsView extends StatelessWidget {
  Map<String, List<CityEvent>> _events;

  EventsView({List events}) {
    _events = foldEvents(events);
  }

  Widget build(BuildContext context) {
    final city = InheritedCity.of(context).city;
    print(city.currentSeason);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SoftContainer(
        child: ListView.separated(
          itemCount: _events.keys.length,
          separatorBuilder: (context, index) {
            return VDivider();
          },
          itemBuilder: (context, index) {
            final keysList = _events.keys.toList();
            keysList.sort((a, b) {
              var year1 = a.split(',')[0];
              var year2 = b.split(',')[0];

              return year1.compareTo(year2);
            });
            final key = keysList[keysList.length - 1 - index];
            var seasonKey = key.split(',')[1];
            var year = key.split(',')[0];
            return SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SoftContainer(
                      child: Container(
                        height: 40,
                        child: FullWidth(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TitleText(
                                '${SlobodaLocalizations.getForKey(seasonKey)} ${year.toString()}'),
                          ),
                        ),
                      ),
                    ),
                    ..._events[key].map((event) {
                      var textStyle;
                      if (city.currentSeason.isNextTo(event.season)) {
                        textStyle = Theme.of(context).textTheme.headline6;
                      }
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              FullWidth(
                                child: Text(
                                  SlobodaLocalizations.getForKey(
                                      event.sourceEvent.messageKey),
                                  textAlign: TextAlign.center,
                                  style: textStyle,
                                ),
                              ),
                              if (event.sourceEvent.stock != null)
                                StockMiniView(
                                  stock: event.sourceEvent.stock,
                                  stockSimulation: null,
                                ),
                              if (event.sourceEvent.cityProps != null)
                                CityPropsMiniView(
                                  props: event.sourceEvent.cityProps,
                                ),
                            ],
                          ));
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

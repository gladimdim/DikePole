import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

bool compare(CityEvent a, CityEvent b) {
  return (a.yearHappened == b.yearHappened && a.season == b.season);
}

List<CityEvent> foldEvents(List<CityEvent> events) {
  return events.fold<List<CityEvent>>([], (List<CityEvent> cv, CityEvent nv) {
    try {
      CityEvent found = cv.firstWhere((v) {
        return compare(v, nv);
      });
      found.events.addAll(nv.events);
    } catch (e) {
      cv.add(CityEvent.copyFrom(nv));
    }

    return cv;
  }).toList();
}

class EventsView extends StatelessWidget {
  List<CityEvent> _events;

  EventsView({List events}) {
    _events = foldEvents(events);
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SoftContainer(
        child: ListView.separated(
          itemCount: _events.length,
          separatorBuilder: (context, index) {
            return VDivider();
          },
          itemBuilder: (context, index) {
            final event = _events[_events.length - 1 - index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SoftContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TitleText(
                            '${SlobodaLocalizations.getForKey(event.season.toLocalizedKey())} ${event.yearHappened}'),
                      ),
                    ),
                    ...event.events.map((RandomEventMessage e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              SlobodaLocalizations.getForKey(e.messageKey),
                              textAlign: TextAlign.center,
                            ),
                            if (e.stock != null)
                              StockMiniView(
                                stock: e.stock,
                                stockSimulation: null,
                              )
                          ],
                        ),
                      );
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

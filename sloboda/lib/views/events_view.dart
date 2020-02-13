import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

class EventsView extends StatelessWidget {
  final List<CityEvent> events;

  EventsView({this.events});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SoftContainer(
        child: ListView.separated(
          itemCount: events.length,
          separatorBuilder: (context, index) {
            return VDivider();
          },
          itemBuilder: (context, index) {
            final event = events[events.length - 1 - index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SoftContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: TitleText(
                          '${SlobodaLocalizations.getForKey(event.season.toLocalizedKey())} ${event.yearHappened}'),
                    ),
                    if (event.messages.isNotEmpty)
                      Column(
                        children: event.messages
                            .map((m) => Text(
                                  m,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ))
                            .toList(),
                      ),
                    if (event.stock != null)
                      Center(
                        child: StockMiniView(
                          stockSimulation: null,
                          stock: event.stock,
                        ),
                      ),
                    if (event.messages.isEmpty)
                      Text(
                        SlobodaLocalizations.nothingHappened,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
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

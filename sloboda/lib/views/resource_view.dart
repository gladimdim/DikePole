import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/resource_buildings/resource_building_view.dart';

class ResourceDetailsScreen extends StatelessWidget {
  static final routeName = '/city_building/resource_details_view';
  final ResourceType type;

  ResourceDetailsScreen({this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: TitleText(
          type.toLocalizedString(),
        ),
      ),
      body: ResourceDetailsView(type: type),
    );
  }
}

class ResourceDetailsView extends StatelessWidget {
  final ResourceType type;

  ResourceDetailsView({this.type});

  @override
  Widget build(BuildContext context) {
    var requiredProd = RESOURCE_BUILDING_TYPES.values.where((v) {
      var instance = ResourceBuilding.fromType(v);
      return instance.requires.containsKey(type);
    }).toList();
    var requiredToBuild = RESOURCE_BUILDING_TYPES.values.where((v) {
      var instance = ResourceBuilding.fromType(v);
      return instance.requiredToBuild.containsKey(type);
    }).toList();

    var producedBy = RESOURCE_BUILDING_TYPES.values.where((v) {
      var instance = ResourceBuilding.fromType(v);
      return instance.produces == type;
    }).toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SoftContainer(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      type.toImagePath(),
                      height: kIsWeb ? 512 : null,
                    ),
                  ),
                ),
                VDivider(),
                SoftContainer(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(type.toLocalizedDescriptionString()),
                )),
                VDivider(),
                if (requiredProd.isNotEmpty) ...[
                  Center(
                    child: Text(SlobodaLocalizations.requiredForProductionBy),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  SoftContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: requiredProd
                          .divideBy(2)
                          .map((List row) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: row
                                      .map(
                                        (e) => ResourceBuildingImageView(
                                          building:
                                              ResourceBuilding.fromType(e),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
                if (requiredToBuild.isNotEmpty) ...[
                  VDivider(),
                  Center(
                    child: Text(SlobodaLocalizations.requiredToBuildBy),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SoftContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: requiredToBuild
                          .divideBy(2)
                          .map((List row) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: row
                                      .map(
                                        (e) => ResourceBuildingImageView(
                                          building:
                                              ResourceBuilding.fromType(e),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
                if (producedBy.isNotEmpty) ...[
                  SizedBox(
                    height: 35,
                  ),
                  Center(child: Text('Produced by')),
                  SizedBox(
                    height: 15,
                  ),
                  SoftContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: producedBy
                          .divideBy(2)
                          .map(
                            (List row) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: row
                                    .map(
                                      (e) => ResourceBuildingImageView(
                                        building: ResourceBuilding.fromType(e),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResourceDetailsScreenArguments {
  final ResourceType type;

  ResourceDetailsScreenArguments({this.type});
}

class ExtractResourceDetailsScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final ResourceDetailsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return ResourceDetailsScreen(
      type: args.type,
    );
  }
}

class ResourceImageView extends StatelessWidget {
  final ResourceType type;
  final int amount;

  ResourceImageView({this.type, this.amount});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: type.toLocalizedString(),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            ResourceDetailsScreen.routeName,
            arguments: ResourceDetailsScreenArguments(
              type: type,
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Image.asset(
              type.toIconPath(),
              width: 32,
            ),
            if (amount != null)
              Text(
                ' $amount',
                style: Theme.of(context).textTheme.bodyText2,
              ),
          ],
        ),
      ),
    );
  }
}

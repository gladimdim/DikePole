import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/animations/slideable_button_web.dart';
import 'package:locadeserta_web/models/background_image_web.dart';
import 'package:locadeserta_web/models/localizations_web.dart';
import 'package:locadeserta_web/animations/fade_images_web.dart';
import 'package:locadeserta_web/locale_selection_web.dart';
import 'package:locadeserta_web/radiuses_web.dart';

class MainView extends StatefulWidget {
  final VoidCallback onContinue;
  final Function onSetLocale;
  final Locale locale;
  LDLocalizations localization;

  MainView({this.onContinue, this.onSetLocale, this.locale}) {
    localization = LDLocalizations(locale);
  }

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        LocaleSelection(
          onLocaleChanged: _setNewLocale,
          locale: widget.locale,
        ),
        ClipRRect(
          borderRadius: getAllRoundedBorderRadius(),
          child: Hero(
            tag: "CossackHero",
            child: TweenImage(
              repeat: true,
              last: AssetImage("images/background/cossack_0.jpg"),
              first: AssetImage("images/background/c_cossack_0.jpg"),
              duration: 2,
              height: 300,
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        SlideableButton(
          onPress: () {},
          child: Container(
            height: 50.0,
            color: Theme.of(context).primaryColor,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.localization.start,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ),
        ),
        LimitedBox(
          maxHeight: 300,
          child: GridView.count(
            crossAxisCount: 5,
            children: List.generate(
              20,
              (index) {
                var b1 = BackgroundImage.getRandomImageForType(ImageType.CAMP);
                b1.nextRandom();
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Hero(
                    tag: "CossackHero",
                    child: TweenImage(
                      repeat: true,
                      last: b1.getAssetImageColored(),
                      first: b1.getAssetImage(),
                      duration: 5,
                      height: 300,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Center(
          child: Text("1.69"),
        ),
      ],
    );
  }

  _setNewLocale(Locale locale) {
    widget.onSetLocale(locale);
  }
}

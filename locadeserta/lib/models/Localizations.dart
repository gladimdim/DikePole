import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

var version = "1.85";

class LDLocalizations {
  LDLocalizations(this.locale);

  final Locale locale;

  static LDLocalizations of(BuildContext context) {
    return Localizations.of<LDLocalizations>(context, LDLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'continue': 'Continue',
      'signout': 'Signout',
      'next': 'Next',
      'signinwithgoogle': "With Google",
      'apptitle': 'Loca Deserta',
      'view': 'View',
      'start': 'Start',
      'greet': 'Good day',
      'version': 'Version',
      'loadingstory': 'Loading Story',
      'startstory': 'Read',
      'lookingforheroes': 'Looking for heroes in Loca Deserta lands...',
      'save': 'Save',
      'reset': 'Reset',
      'anonlogin': 'Guest',
      'welcometext': 'Select login method',
      'theend': 'THE END',
      'tobecontinued': 'To be continued. Wait on the story update.',
      'showstorydetails': 'More Details',
      'translationnotready':
          'Translations are not yet ready for your language.',
      'aboutgame':
          'Interactive Fiction. This game allows to dive into heroic epoch in XVII century, which took part in the southern part of Ukraine, at Loca Deserta. You not only read the story but you can select how it proceeds further! Depending on your selections you can get absolutely different events, encounters. Or you can even die.',
      'menu': 'Menu',
      'backtostories': 'Back to stories',
      'backtomenu': 'Back to menu',
      'authors': 'Authors: ',
      'storybegin': 'The Beginning',
      'sharestory': 'Share story',
      'preparingexport': 'Preparing export of the story',
      'openingsharedialog': 'Sending story to share dialog',
      'warninglongprocess':
          'This feature takes some time to finish, please wait.',
      'longprocesswarning': 'Operation might take up to 30 seconds.',
      'longprocessdescription':
          'We have to compile your story into passages, add pictures and create PDF file. It might take some time.',
      'createpdfdocument': 'Create',
      'cancel': 'Cancel',
      'processingimage': "Processing image, please wait",
      'savingexportdocument': 'Saving exported file',
      'enterstorytitle': 'Enter story title',
      'labelStoryTitle': 'Title: ',
      'listofauthors': 'List of authors',
      'labelauthors': 'Authors:',
      'createstory': 'Create your story',
      'edit': 'Edit',
      'description': 'Description',
      'hintdescription': 'Enter story description',
      'remove': 'Remove',
      'labeloptions': 'Add new option',
      'optionplaceholder': 'Replace this',
      'gotorootpage': 'Go to root page',
      'addnewpassage': 'Add new passage',
      'passagewillhaveimage': 'Passage will have image',
      'selectimageforpassage': 'Select image for the passage: ',
      'editingpassage': 'Editing passage',
      'previewstory': 'Preview story',
      'optionslistempty': 'Options list is empty',
      'passagelistempty': 'Passage list is empty',
      'labelistheenddead': 'Dies',
      'labelistheendalive': 'Lives',
      'labelistheend': 'The End',
      'labelback': 'Back',
      'exportgladstorytojson': 'Export to JSON',
      'pastefulljson': 'Paste full JSON text',
      'import': 'Import',
    },
    'uk': {
      'continue': 'Продовжити',
      'signout': 'Вийти',
      'next': 'Далі',
      'signinwithgoogle': "З Google",
      'apptitle': 'Дике Поле',
      'view': 'Переглянути',
      'start': 'Почати',
      'greet': 'Доброго дня',
      'version': 'Версія',
      'loadingstory': 'Завантаження історії',
      'startstory': 'Читати',
      'lookingforheroes': 'Шукаємо героїв в землях Дикого Поля...',
      'save': 'Зберегти',
      'reset': 'Заново',
      'anonlogin': 'Гість',
      'welcometext': 'Виберіть метод входу в гру',
      'theend': "Кінець",
      'tobecontinued': 'Далі буде. Чекайте на оновлення.',
      'showstorydetails': 'Детальніше',
      'translationnotready': 'Переклад історії на вашу мову ще не готовий.',
      'aboutgame':
          'Інтерактивна гра-книга (Interactive Fiction). Гра дозволяє зануритись в бурхливі події 1620х років, які відбувалися на Дикому Полі. Але ви не тільки читаєте історію, а ще і можете вибирати подальший розвиток подій. В залежності від вашого вибору, історія продовжується в різних напрямах, або ж і просто обривається назавжди.',
      'menu': 'Меню',
      'backtostories': 'Назад до історій',
      'backtomenu': 'Назад до меню',
      'authors': 'Автори: ',
      'storybegin': 'Початок',
      'sharestory': 'Поділитися історією',
      'preparingexport': 'Підготовка до експорту історії',
      'openingsharedialog': 'Передаю дані до діалогу поширення',
      'warninglongprocess':
          'Ця функція займає деякий час, будь ласка, почекайте.',
      'longprocesswarning': 'Операція може зайняти до 30 секунд.',
      'longprocessdescription':
          'Нам необхідно обробити вашу пройдену історію, сформувати абзаци і додати картинки. Тому це може заняти деякий час.',
      'createpdfdocument': 'Сформувати документ',
      'cancel': 'Скасувати',
      'processingimage': 'Обробляємо картинку, будь ласка, почекайте',
      'savingexportdocument': 'Зберігаємо експортований файл',
      'enterstorytitle': 'Введіть назву історії',
      'labelStoryTitle': 'Назва: ',
      'listofauthors': 'Список авторів',
      'labelauthors': 'Автори:',
      'createstory': 'Створити свою історію',
      'edit': 'Редагувати',
      'description': 'Описання',
      'hintdescription': 'Введіть описання історії',
      'remove': 'Видалити',
      'labeloptions': 'Додати вибір',
      'optionplaceholder': 'Замініть це',
      'gotorootpage': 'Назад на головну сторінку',
      'addnewpassage': 'Додати новий абзац',
      'passagewillhaveimage': 'Абзац буде з картинкою',
      'selectimageforpassage': 'Виберіть картинку для абзацу: ',
      'editingpassage': 'Редагування абзацу',
      'previewstory': 'Перегляд історії',
      'optionslistempty': 'Список опцій порожній',
      'passagelistempty': 'Список абзаців порожній',
      'labelistheenddead': 'Умирає',
      'labelistheendalive': 'Живе',
      'labelistheend': 'Це кінець',
      'labelback': 'Назад',
      'exportgladstorytojson': 'Експорт в JSON',
      'pastefulljson': 'Вставте повний текст JSON',
      'import': 'Імпортувати',
    },
    'pl': {
      'continue': 'Dalej',
      'signout': 'Wyloguj się',
      'next': 'Kolejny',
      'signinwithgoogle': "Z google",
      'apptitle': 'Dzikie Pole',
      'view': 'Widok',
      'start': 'Początek',
      'greet': 'Dobry dzień',
      'version': 'Wersja',
      'loadingstory': 'Historia ładowania',
      'startstory': 'Сzytać',
      'lookingforheroes': 'poszukuje bohaterów w Dzikie Pole ziemia...',
      'save': 'Zapisać',
      'reset': 'Nastawić',
      'anonlogin': 'Gość',
      'welcometext': 'Wybierz metodę logowania',
      'theend': 'Koniec',
      'tobecontinued': 'Ciąg dalszy nastąpi. Poczekaj na aktualizację historii',
      'showstorydetails': 'Więcej szczegółów',
      'translationnotready':
          'Tłumaczenie opowiadań dla twojego języka nie jest jeszcze gotowe.',
      'aboutgame':
          'Interaktywna fikcja. Ta gra pozwala zanurzyć się w heroicznej epoce w XVII wieku, która odbyła się w południowej części Ukrainy, w Loca Deserta. Nie tylko czytasz historię, ale możesz wybrać, jak dalej będzie postępować! W zależności od wyboru możesz uzyskać zupełnie inne wydarzenia, spotkania. Albo możesz nawet umrzeć.',
      'menu': 'Menu',
      'backtostories': 'Powrót do historii',
      'backtomenu': 'Powrót do menu',
      'authors': 'Autorzy: ',
      'storybegin': 'Początek',
      'sharestory': 'Podziel się historią',
      'preparingexport': 'Przygotowanie historii na eksport',
      'openingsharedialog':
          'Wysyłanie danych do okna dialogowego udostępniania',
      'warninglongprocess': 'Ta funkcja wymaga trochę czasu, proszę czekać.',
      'longprocesswarning': 'Operacja może potrwać do 30 sekund.',
      'longprocessdescription':
          'Musimy przetworzyć twoją historię, utworzyć akapity i dodać zdjęcia. Dlatego tak długo to trwało.',
      'createpdfdocument': 'Utwórz dokument',
      'cancel': 'Anuluj',
      'processingimage': 'Przetwarzanie obrazu',
      'savingexportdocument': 'Zapisywanie wyeksportowanego pliku',
      'enterstorytitle': 'Wpisz tytuł opowieści',
      'labelStoryTitle': 'Tytuł:',
      'listofauthors': 'Lista autorów',
      'labelauthors': 'Autorski:',
      'createstory': 'Utwórz historię',
      'edit': 'Edytować',
      'description': 'Opis',
      'hintdescription': 'Wpisz opis historii',
      'remove': 'Usunąć',
      'labeloptions': 'Dodaj wybór',
      'optionplaceholder': 'Zamień tę',
      'gotorootpage': 'Idź do strony głównej',
      'addnewpassage': 'Dodaj nowy fragment',
      'passagewillhaveimage': 'Przejście będzie miało obraz',
      'selectimageforpassage': 'Wybierz zdjęcie do przejścia: ',
      'editingpassage': 'Edycja fragmentu',
      'previewstory': 'Zobacz historię',
      'optionslistempty': 'Lista opcji jest pusta',
      'passagelistempty': 'Lista pasaży jest pusta',
      'labelistheenddead': 'Bohater nie żyje',
      'labelistheendalive': 'Bohater żyje',
      'labelistheend': 'Koniec',
      'labelback': 'Wróć',
      'exportgladstorytojson': 'Eksportuj do JSON',
      'pastefulljson': 'Wklej pełny JSON',
      'import': 'Import',
    }
  };

  String get Continue {
    return _localizedValues[locale.languageCode]['continue'];
  }

  String get signInWithGoogle {
    return _localizedValues[locale.languageCode]['signinwithgoogle'];
  }

  String get signOut {
    return _localizedValues[locale.languageCode]['signout'];
  }

  String get next {
    return _localizedValues[locale.languageCode]['next'];
  }

  String get appTitle {
    return _localizedValues[locale.languageCode]['apptitle'];
  }

  String get view {
    return _localizedValues[locale.languageCode]['view'];
  }

  String get start {
    return _localizedValues[locale.languageCode]['start'];
  }

  String greetUserByName(String name) {
    return '${_localizedValues[locale.languageCode]['greet']}, $name';
  }

  String get versionLabel {
    return "${_localizedValues[locale.languageCode]['version']}: $version";
  }

  String get loadingStory {
    return _localizedValues[locale.languageCode]['loadingstory'];
  }

  String get startStory {
    return _localizedValues[locale.languageCode]['startstory'];
  }

  String get lookingForHeroes {
    return _localizedValues[locale.languageCode]['lookingforheroes'];
  }

  String get save {
    return _localizedValues[locale.languageCode]['save'];
  }

  String get reset {
    return _localizedValues[locale.languageCode]['reset'];
  }

  String get anonLogin {
    return _localizedValues[locale.languageCode]['anonlogin'];
  }

  String get welcomeText {
    return _localizedValues[locale.languageCode]['welcometext'];
  }

  String get theEnd {
    return _localizedValues[locale.languageCode]['theend'];
  }

  String get toBeContinued {
    return _localizedValues[locale.languageCode]['tobecontinued'];
  }

  String get showStoryDetails {
    return _localizedValues[locale.languageCode]['showstorydetails'];
  }

  String get translationNotYetReady {
    return _localizedValues[locale.languageCode]['translationnotready'];
  }

  String get aboutGame {
    return _localizedValues[locale.languageCode]['aboutgame'];
  }

  String get menuText {
    return _localizedValues[locale.languageCode]['menu'];
  }

  String get backToStories {
    return _localizedValues[locale.languageCode]['backtostories'];
  }

  String get backToMenu {
    return _localizedValues[locale.languageCode]['backtomenu'];
  }

  String get authors {
    return _localizedValues[locale.languageCode]['authors'];
  }

  String get storyBegin {
    return _localizedValues[locale.languageCode]['storybegin'];
  }

  String get shareStory {
    return _localizedValues[locale.languageCode]['sharestory'];
  }

  String get preparingExport {
    return _localizedValues[locale.languageCode]['preparingexport'];
  }

  String get openingShareDialog {
    return _localizedValues[locale.languageCode]['openingsharedialog'];
  }

  String get longProcessWarning {
    return _localizedValues[locale.languageCode]['longprocesswarning'];
  }

  String get longProcessDescription {
    return _localizedValues[locale.languageCode]['longprocessdescription'];
  }

  String get createPdfDocument {
    return _localizedValues[locale.languageCode]['createpdfdocument'];
  }

  String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  String get processingImage {
    return _localizedValues[locale.languageCode]['processingimage'];
  }

  String get savingExportFile {
    return _localizedValues[locale.languageCode]['savingexportdocument'];
  }

  String get enterStoryTitle {
    return _localizedValues[locale.languageCode]['enterstorytitle'];
  }

  String get labelStoryTitle {
    return _localizedValues[locale.languageCode]['labelStoryTitle'];
  }

  String get listOfAuthors {
    return _localizedValues[locale.languageCode]['listofauthors'];
  }

  String get labelAuthors {
    return _localizedValues[locale.languageCode]['labelauthors'];
  }

  String get createStory {
    return _localizedValues[locale.languageCode]['createstory'];
  }

  String get edit {
    return _localizedValues[locale.languageCode]['edit'];
  }

  String get description {
    return _localizedValues[locale.languageCode]['description'];
  }

  String get hintDescription {
    return _localizedValues[locale.languageCode]['hintDescription'];
  }

  String get remove {
    return _localizedValues[locale.languageCode]['remove'];
  }

  String get labelOptions {
    return _localizedValues[locale.languageCode]['labeloptions'];
  }

  String get optionPlaceHolder {
    return _localizedValues[locale.languageCode]['optionplaceholder'];
  }

  String get goToRootPage {
    return _localizedValues[locale.languageCode]['gotorootpage'];
  }

  String get addNewPassage {
    return _localizedValues[locale.languageCode]['addnewpassage'];
  }

  String get passageWillHaveImage {
    return _localizedValues[locale.languageCode]['passagewillhaveimage'];
  }

  String get selectImageForPassage {
    return _localizedValues[locale.languageCode]['selectimageforpassage'];
  }

  String get editingPassage {
    return _localizedValues[locale.languageCode]['editingpassage'];
  }

  String get previewStory {
    return _localizedValues[locale.languageCode]['previewstory'];
  }

  String get optionsListEmpty {
    return _localizedValues[locale.languageCode]['optionslistempty'];
  }

  String get passageListEmpty {
    return _localizedValues[locale.languageCode]['passagelistempty'];
  }

  String get labelIsTheEndDead {
    return _localizedValues[locale.languageCode]['labelistheenddead'];
  }

  String get labelIsTheEndAlive {
    return _localizedValues[locale.languageCode]['labelistheendalive'];
  }

  String get labelIsTheEnd {
    return _localizedValues[locale.languageCode]['labelistheend'];
  }

  String get labelBack {
    return _localizedValues[locale.languageCode]['labelback'];
  }

  String get exportGladStoryToJson {
    return _localizedValues[locale.languageCode]['exportgladstorytojson'];
  }

  String get pasteFullJSON {
    return _localizedValues[locale.languageCode]['pastefulljson'];
  }

  String get labelImport {
    return _localizedValues[locale.languageCode]['import'];
  }
}

class LDLocalizationsDelegate extends LocalizationsDelegate<LDLocalizations> {
  const LDLocalizationsDelegate();

  bool isSupported(Locale locale) =>
      ['en', 'uk', 'pl'].contains(locale.languageCode);

  Future<LDLocalizations> load(Locale locale) {
    return SynchronousFuture<LDLocalizations>(LDLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<LDLocalizations> old) {
    return false;
  }
}

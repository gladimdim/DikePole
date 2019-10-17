import 'dart:core';

import 'package:flutter/material.dart';

var version = "1.88";

class LDLocalizations {
  static Locale locale = Locale('uk');

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
      'statisticsTitle': 'Statistics of the platform',
      'theendstartoverquestion': 'This is the end. Start again?',
      'statisticsViewTitle': 'Statistics of the Platform',
      'registeredUsers': 'Registered users',
      'timesRead': 'Times read',
      'failedToLoadStats': 'Failed to load statistics',
      'loadingStats': 'Loading. Might take up to 6 seconds...'
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
      'statisticsTitle': 'Статистика по платформі',
      'theendstartoverquestion': 'Це кінець, почати заново?',
      'statisticsViewTitle': 'Статистики платформи',
      'registeredUsers': 'Зареєстровано користувачів',
      'timesRead': 'Прочитано разів',
      'failedToLoadStats': 'Не змогли завантажити статистику',
      'loadingStats': 'Завантажуємо статистику. Може зайняти до 6 секунд.'
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
      'statisticsTitle': 'Statystyka platformy',
      'theendstartoverquestion': 'To jest koniec. Zacznij jeszcze raz?',
      'statisticsViewTitle': 'Platform Stats',
      'registeredUsers': 'Zarejestrowani Użytkownicy',
      'timesRead': 'Czytaj czasy',
      'failedToLoadStats': 'Nie udało się załadować statystyk',
      'loadingStats': 'Ładowanie statystyk. Może to potrwać do 6 sekund.'
    }
  };

  static String get Continue {
    return _localizedValues[LDLocalizations.locale.languageCode]['continue'];
  }

  static String get signInWithGoogle {
    return _localizedValues[locale.languageCode]['signinwithgoogle'];
  }

  static String get signOut {
    return _localizedValues[locale.languageCode]['signout'];
  }

  static String get next {
    return _localizedValues[locale.languageCode]['next'];
  }

  static String get appTitle {
    return _localizedValues[locale.languageCode]['apptitle'];
  }

  static String get view {
    return _localizedValues[locale.languageCode]['view'];
  }

  static String get start {
    return _localizedValues[locale.languageCode]['start'];
  }

  static String greetUserByName(String name) {
    return '${_localizedValues[locale.languageCode]['greet']}, $name';
  }

  static String get versionLabel {
    return "${_localizedValues[locale.languageCode]['version']}: $version";
  }

  static String get loadingStory {
    return _localizedValues[locale.languageCode]['loadingstory'];
  }

  static String get startStory {
    return _localizedValues[locale.languageCode]['startstory'];
  }

  static String get lookingForHeroes {
    return _localizedValues[locale.languageCode]['lookingforheroes'];
  }

  static String get save {
    return _localizedValues[locale.languageCode]['save'];
  }

  static String get reset {
    return _localizedValues[locale.languageCode]['reset'];
  }

  static String get anonLogin {
    return _localizedValues[locale.languageCode]['anonlogin'];
  }

  static String get welcomeText {
    return _localizedValues[locale.languageCode]['welcometext'];
  }

  static String get theEnd {
    return _localizedValues[locale.languageCode]['theend'];
  }

  static String get toBeContinued {
    return _localizedValues[locale.languageCode]['tobecontinued'];
  }

  static String get showStoryDetails {
    return _localizedValues[locale.languageCode]['showstorydetails'];
  }

  static String get translationNotYetReady {
    return _localizedValues[locale.languageCode]['translationnotready'];
  }

  static String get aboutGame {
    return _localizedValues[locale.languageCode]['aboutgame'];
  }

  static String get menuText {
    return _localizedValues[locale.languageCode]['menu'];
  }

  static String get backToStories {
    return _localizedValues[locale.languageCode]['backtostories'];
  }

  static String get backToMenu {
    return _localizedValues[locale.languageCode]['backtomenu'];
  }

  static String get authors {
    return _localizedValues[locale.languageCode]['authors'];
  }

  static String get storyBegin {
    return _localizedValues[locale.languageCode]['storybegin'];
  }

  static String get shareStory {
    return _localizedValues[locale.languageCode]['sharestory'];
  }

  static String get preparingExport {
    return _localizedValues[locale.languageCode]['preparingexport'];
  }

  static String get openingShareDialog {
    return _localizedValues[locale.languageCode]['openingsharedialog'];
  }

  static String get longProcessWarning {
    return _localizedValues[locale.languageCode]['longprocesswarning'];
  }

  static String get longProcessDescription {
    return _localizedValues[locale.languageCode]['longprocessdescription'];
  }

  static String get createPdfDocument {
    return _localizedValues[locale.languageCode]['createpdfdocument'];
  }

  static String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  static String get processingImage {
    return _localizedValues[locale.languageCode]['processingimage'];
  }

  static String get savingExportFile {
    return _localizedValues[locale.languageCode]['savingexportdocument'];
  }

  static String get enterStoryTitle {
    return _localizedValues[locale.languageCode]['enterstorytitle'];
  }

  static String get labelStoryTitle {
    return _localizedValues[locale.languageCode]['labelStoryTitle'];
  }

  static String get listOfAuthors {
    return _localizedValues[locale.languageCode]['listofauthors'];
  }

  static String get labelAuthors {
    return _localizedValues[locale.languageCode]['labelauthors'];
  }

  static String get createStory {
    return _localizedValues[locale.languageCode]['createstory'];
  }

  static String get edit {
    return _localizedValues[locale.languageCode]['edit'];
  }

  static String get description {
    return _localizedValues[locale.languageCode]['description'];
  }

  static String get hintDescription {
    return _localizedValues[locale.languageCode]['hintDescription'];
  }

  static String get remove {
    return _localizedValues[locale.languageCode]['remove'];
  }

  static String get labelOptions {
    return _localizedValues[locale.languageCode]['labeloptions'];
  }

  static String get optionPlaceHolder {
    return _localizedValues[locale.languageCode]['optionplaceholder'];
  }

  static String get goToRootPage {
    return _localizedValues[locale.languageCode]['gotorootpage'];
  }

  static String get addNewPassage {
    return _localizedValues[locale.languageCode]['addnewpassage'];
  }

  static String get passageWillHaveImage {
    return _localizedValues[locale.languageCode]['passagewillhaveimage'];
  }

  static String get selectImageForPassage {
    return _localizedValues[locale.languageCode]['selectimageforpassage'];
  }

  static String get editingPassage {
    return _localizedValues[locale.languageCode]['editingpassage'];
  }

  static String get previewStory {
    return _localizedValues[locale.languageCode]['previewstory'];
  }

  static String get optionsListEmpty {
    return _localizedValues[locale.languageCode]['optionslistempty'];
  }

  static String get passageListEmpty {
    return _localizedValues[locale.languageCode]['passagelistempty'];
  }

  static String get labelIsTheEndDead {
    return _localizedValues[locale.languageCode]['labelistheenddead'];
  }

  static String get labelIsTheEndAlive {
    return _localizedValues[locale.languageCode]['labelistheendalive'];
  }

  static String get labelIsTheEnd {
    return _localizedValues[locale.languageCode]['labelistheend'];
  }

  static String get labelBack {
    return _localizedValues[locale.languageCode]['labelback'];
  }

  static String get exportGladStoryToJson {
    return _localizedValues[locale.languageCode]['exportgladstorytojson'];
  }

  static String get pasteFullJSON {
    return _localizedValues[locale.languageCode]['pastefulljson'];
  }

  static String get labelImport {
    return _localizedValues[locale.languageCode]['import'];
  }

  static String get statisticsTitle {
    return _localizedValues[locale.languageCode]['statisticsTitle'];
  }

  static String get theEndStartOverQuestion {
    return _localizedValues[locale.languageCode]['theendstartoverquestion'];
  }

  static String get statisticsViewTitle {
    return _localizedValues[locale.languageCode]['statisticsViewTitle'];
  }

  static String get registeredUsers {
    return _localizedValues[locale.languageCode]['registeredUsers'];
  }

  static String get timesRead {
    return _localizedValues[locale.languageCode]['timesRead'];
  }

  static String get failedToLoadStats {
    return _localizedValues[locale.languageCode]['failedToLoadStats'];
  }

  static String get loadingStats {
    return _localizedValues[locale.languageCode]['loadingStats'];
  }
}

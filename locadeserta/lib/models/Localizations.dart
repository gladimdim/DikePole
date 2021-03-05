import 'dart:core';

import 'package:flutter/material.dart';
import 'package:locadeserta/loaders/url_parser.dart';
import 'package:locadeserta/models/app_preferences.dart';

var version = "1.124";

String getDefaultOrUrlLanguage() {
  var urlLang = UrlParser.getLanguage();
  final savedLangCode = AppPreferences.instance.getUILanguage();
  if (LDLocalizations.supportedLanguageCodes.contains(urlLang)) {
    return urlLang;
  } else if (savedLangCode != null &&
      LDLocalizations.supportedLanguageCodes.contains(savedLangCode)) {
    return savedLangCode;
  } else {
    return 'uk';
  }
}

class LDLocalizations {
  static List supportedLanguageCodes = ['uk', 'en'];

  static Locale locale = Locale(getDefaultOrUrlLanguage());

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
      'passagewillhaveimage': 'Passage image',
      'selectimageforpassage': 'Select image: ',
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
      'registeredUsers': 'Registered users',
      'timesRead': 'Times read',
      'failedToLoadStats': 'Failed to load statistics',
      'loadingStats': 'Loading. Might take up to 6 seconds...',
      'hintFieldYear': 'Enter year when the story happened',
      'labelYear': 'Year:',
      'createNewStory': 'Create new story',
      'ownStories': 'Your stories',
      'yourExistingStories': 'Your existing stories',
      'darkThemeLabel': 'Dark theme',
      'lightThemeLabel': 'Light theme',
      'updateStatsLabel': 'Update Stats',
      'publishUserStory': 'Publish story',
      'publishStoryInstructions':
          'Copy the story by using button below and send the file to the email <gladimdim@gmail.com>.',
      'labelNoPassagesAvailable':
          'There are no passages in this page, return back and add a passage.',
      'labelShowMarkdownSource': 'Show source',
      'labelShowMarkdownRendered': 'Show Markdown',
      'labelConvertToMarkdown': 'Export to Markdown',
      'labelEditStory': 'Edit Story',
      'labelInstructionsForUploadingStory':
          'Press Upload button to generate unique link.',
      'labelOpenInBrowser': 'Browser',
      'labelFileIsBeingUploaded':
          'File is being uploaded, your link will appear soon.',
      'labelShareActions': 'Share actions',
      'labelShareToTwitter': 'Twitter',
      'labelShareToFacebook': 'Facebook',
      'labelUserStoriesCatalog': 'List of user stories',
      'labelInstructionsForUploadingStoryToPurgatory':
          'Upload your story to online Purgatory catalog. Your story will be available for every reader! By uploading the story you agree to Free Art License.',
      'labelUploading': 'Uploading',
      'labelUploadedPurgatoryStoryInstructions':
          'Uploaded! Now your story is available for everybody in the "User stories" section of the game.',
      'shareStoryToPdf': "Share to PDF",
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
      'passagewillhaveimage': 'Картинка абзацу',
      'selectimageforpassage': 'Виберіть картинку: ',
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
      'registeredUsers': 'Зареєстровано користувачів',
      'timesRead': 'Прочитано разів',
      'failedToLoadStats': 'Не змогли завантажити статистику',
      'loadingStats': 'Завантажуємо статистику. Може зайняти до 6 секунд.',
      'hintFieldYear': 'Введіть рік, коли історія відбулася',
      'labelYear': 'Рік:',
      'createNewStory': 'Створити нову історію',
      'ownStories': 'Ваші історії',
      'yourExistingStories': 'Ваші існуючі історії',
      'darkThemeLabel': 'Темна тема',
      'lightThemeLabel': 'Світла тема',
      'updateStatsLabel': 'Оновити статистику',
      'publishUserStory': 'Опублікувати історію',
      'publishStoryInstructions':
          'Скопіюйте історію за допомогою кнопки внизу і надішліть файл на пошту <gladimdim@gmail.com>.',
      'labelNoPassagesAvailable':
          'На цій сторінці немає жодного абзацу. Поверніться назад і додайте хоча б один.',
      'labelShowMarkdownSource': 'Показати текст',
      'labelShowMarkdownRendered': 'Показати документ',
      'labelConvertToMarkdown': 'Експорт в Markdown',
      'labelEditStory': 'Редагувати історію',
      'labelInstructionsForUploadingStory':
          'Натисніть кнопку, щоб згенерувати унікальне посилання.',
      'labelOpenInBrowser': 'Браузер',
      'labelFileIsBeingUploaded':
          'Історія завантажується. Незабаром буде згенероване посилання для вас.',
      'labelShareActions': 'Поширення',
      'labelShareToTwitter': 'Твітнути',
      'labelShareToFacebook': 'Facebook',
      'labelUserStoriesCatalog': 'Історії інших читачів',
      'labelInstructionsForUploadingStoryToPurgatory':
          'Завантажте свою історію в онлайн каталог Чистилища. Ваша історія буде доступна для всіх читачів. Якщо ви завантажуєте вашу історію, то ви автоматично погоджуєтесь на Free Art License.',
      'labelUploading': 'Завантажуємо',
      'labelUploadedPurgatoryStoryInstructions':
          'Завантажено! Тепер ваша історія доступна для всіх читачів в секції "Історії інших читаів".',
      "shareStoryToPdf": "Експорт в PDF",
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
      'selectimageforpassage': 'Wybierz zdjęcie: ',
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
      'registeredUsers': 'Zarejestrowani Użytkownicy',
      'timesRead': 'Czytaj czasy',
      'failedToLoadStats': 'Nie udało się załadować statystyk',
      'loadingStats': 'Ładowanie statystyk. Może to potrwać do 6 sekund.',
      'hintFieldYear': 'Podaj rok, w którym wydarzyła się historia',
      'labelYear': 'Rok:',
      'createNewStory': 'Utwórz nową historię',
      'ownStories': 'Własne historie',
      'yourExistingStories': 'Twoje istniejące historie',
      'darkThemeLabel': 'Ciemny motyw',
      'lightThemeLabel': 'Lekki motyw',
      'updateStatsLabel': 'Update stats',
      'publishUserStory': 'Publish user story',
      'labelNoPassagesAvailable':
          '"There are no passages in this page, return back and add a passage."',
      'labelShowMarkdownSource': 'Show text',
      'labelShowMarkdownRendered': 'Show markdown',
      'labelConvertToMarkdown': 'Export to Markdown',
      'labelEditStory': 'Edit Story',
      'labelInstructionsForUploadingStory':
          'Press upload button to generate unique link for this story.',
      'labelOpenInBrowser': 'Browser',
      'labelFileIsBeingUploaded':
          'File is being uploaded. Link will be generated soon.',
      'labelShareActions': 'Share actions',
      'labelShareToTwitter': 'Twitter',
      'labelShareToFacebook': 'Facebook',
      'labelUserStoriesCatalog': 'Catalog of user stories',
      'labelInstructionsForUploadingStoryToPurgatory':
          'Upload your story to online Purgatory catalog. Your story will be available for every reader! By uploading the story you agree to Free Art License.',
      'labelUploading': 'Uploading',
      'labelUploadedPurgatoryStoryInstructions':
          'Uploaded! Now your story is available for everybody in the "User stories" section of the game.',
      "shareStoryToPdf": "Share to PDF",
    }
  };

  static String get labelContinue {
    return _localizedValues[LDLocalizations.locale.languageCode]!['continue']!;
  }

  static String get signInWithGoogle {
    return _localizedValues[locale.languageCode]!['signinwithgoogle']!;
  }

  static String get signOut {
    return _localizedValues[locale.languageCode]!['signout']!;
  }

  static String get next {
    return _localizedValues[locale.languageCode]!['next']!;
  }

  static String get appTitle {
    return _localizedValues[locale.languageCode]!['apptitle']!;
  }

  static String get view {
    return _localizedValues[locale.languageCode]!['view']!;
  }

  static String get start {
    return _localizedValues[locale.languageCode]!['start']!;
  }

  static String greetUserByName(String name) {
    return '${_localizedValues[locale.languageCode]!['greet']}, $name';
  }

  static String get versionLabel {
    return "${_localizedValues[locale.languageCode]!['version']}: $version";
  }

  static String get loadingStory {
    return _localizedValues[locale.languageCode]!['loadingstory']!;
  }

  static String get startStory {
    return _localizedValues[locale.languageCode]!['startstory']!;
  }

  static String get lookingForHeroes {
    return _localizedValues[locale.languageCode]!['lookingforheroes']!;
  }

  static String get save {
    return _localizedValues[locale.languageCode]!['save']!;
  }

  static String get reset {
    return _localizedValues[locale.languageCode]!['reset']!;
  }

  static String get anonLogin {
    return _localizedValues[locale.languageCode]!['anonlogin']!;
  }

  static String get welcomeText {
    return _localizedValues[locale.languageCode]!['welcometext']!;
  }

  static String get theEnd {
    return _localizedValues[locale.languageCode]!['theend']!;
  }

  static String get toBeContinued {
    return _localizedValues[locale.languageCode]!['tobecontinued']!;
  }

  static String get showStoryDetails {
    return _localizedValues[locale.languageCode]!['showstorydetails']!;
  }

  static String get translationNotYetReady {
    return _localizedValues[locale.languageCode]!['translationnotready']!;
  }

  static String get aboutGame {
    return _localizedValues[locale.languageCode]!['aboutgame']!;
  }

  static String get menuText {
    return _localizedValues[locale.languageCode]!['menu']!;
  }

  static String get backToStories {
    return _localizedValues[locale.languageCode]!['backtostories']!;
  }

  static String get backToMenu {
    return _localizedValues[locale.languageCode]!['backtomenu']!;
  }

  static String get authors {
    return _localizedValues[locale.languageCode]!['authors']!;
  }

  static String get storyBegin {
    return _localizedValues[locale.languageCode]!['storybegin']!;
  }

  static String get shareStory {
    return _localizedValues[locale.languageCode]!['sharestory']!;
  }

  static String get preparingExport {
    return _localizedValues[locale.languageCode]!['preparingexport']!;
  }

  static String get openingShareDialog {
    return _localizedValues[locale.languageCode]!['openingsharedialog']!;
  }

  static String get longProcessWarning {
    return _localizedValues[locale.languageCode]!['longprocesswarning']!;
  }

  static String get longProcessDescription {
    return _localizedValues[locale.languageCode]!['longprocessdescription']!;
  }

  static String get createPdfDocument {
    return _localizedValues[locale.languageCode]!['createpdfdocument']!;
  }

  static String get cancel {
    return _localizedValues[locale.languageCode]!['cancel']!;
  }

  static String get processingImage {
    return _localizedValues[locale.languageCode]!['processingimage']!;
  }

  static String get savingExportFile {
    return _localizedValues[locale.languageCode]!['savingexportdocument']!;
  }

  static String get enterStoryTitle {
    return _localizedValues[locale.languageCode]!['enterstorytitle']!;
  }

  static String get labelStoryTitle {
    return _localizedValues[locale.languageCode]!['labelStoryTitle']!;
  }

  static String get listOfAuthors {
    return _localizedValues[locale.languageCode]!['listofauthors']!;
  }

  static String get labelAuthors {
    return _localizedValues[locale.languageCode]!['labelauthors']!;
  }

  static String get createStory {
    return _localizedValues[locale.languageCode]!['createstory']!;
  }

  static String get edit {
    return _localizedValues[locale.languageCode]!['edit']!;
  }

  static String get description {
    return _localizedValues[locale.languageCode]!['description']!;
  }

  static String get hintDescription {
    return _localizedValues[locale.languageCode]!['hintDescription']!;
  }

  static String get remove {
    return _localizedValues[locale.languageCode]!['remove']!;
  }

  static String get labelOptions {
    return _localizedValues[locale.languageCode]!['labeloptions']!;
  }

  static String get optionPlaceHolder {
    return _localizedValues[locale.languageCode]!['optionplaceholder']!;
  }

  static String get goToRootPage {
    return _localizedValues[locale.languageCode]!['gotorootpage']!;
  }

  static String get addNewPassage {
    return _localizedValues[locale.languageCode]!['addnewpassage']!;
  }

  static String get passageWillHaveImage {
    return _localizedValues[locale.languageCode]!['passagewillhaveimage']!;
  }

  static String get selectImageForPassage {
    return _localizedValues[locale.languageCode]!['selectimageforpassage']!;
  }

  static String get editingPassage {
    return _localizedValues[locale.languageCode]!['editingpassage']!;
  }

  static String get previewStory {
    return _localizedValues[locale.languageCode]!['previewstory']!;
  }

  static String get optionsListEmpty {
    return _localizedValues[locale.languageCode]!['optionslistempty']!;
  }

  static String get passageListEmpty {
    return _localizedValues[locale.languageCode]!['passagelistempty']!;
  }

  static String get labelIsTheEndDead {
    return _localizedValues[locale.languageCode]!['labelistheenddead']!;
  }

  static String get labelIsTheEndAlive {
    return _localizedValues[locale.languageCode]!['labelistheendalive']!;
  }

  static String get labelIsTheEnd {
    return _localizedValues[locale.languageCode]!['labelistheend']!;
  }

  static String get labelBack {
    return _localizedValues[locale.languageCode]!['labelback']!;
  }

  static String get exportGladStoryToJson {
    return _localizedValues[locale.languageCode]!['exportgladstorytojson']!;
  }

  static String get pasteFullJSON {
    return _localizedValues[locale.languageCode]!['pastefulljson']!;
  }

  static String get labelImport {
    return _localizedValues[locale.languageCode]!['import']!;
  }

  static String get statisticsTitle {
    return _localizedValues[locale.languageCode]!['statisticsTitle']!;
  }

  static String get theEndStartOverQuestion {
    return _localizedValues[locale.languageCode]!['theendstartoverquestion']!;
  }

  static String get registeredUsers {
    return _localizedValues[locale.languageCode]!['registeredUsers']!;
  }

  static String get timesRead {
    return _localizedValues[locale.languageCode]!['timesRead']!;
  }

  static String get failedToLoadStats {
    return _localizedValues[locale.languageCode]!['failedToLoadStats']!;
  }

  static String get loadingStats {
    return _localizedValues[locale.languageCode]!['loadingStats']!;
  }

  static String get hintFieldYear {
    return _localizedValues[locale.languageCode]!['hintFieldYear']!;
  }

  static String get labelYear {
    return _localizedValues[locale.languageCode]!['labelYear']!;
  }

  static String get createNewStory {
    return _localizedValues[locale.languageCode]!['createNewStory']!;
  }

  static String get ownStories {
    return _localizedValues[locale.languageCode]!['ownStories']!;
  }

  static String get yourExistingStories {
    return _localizedValues[locale.languageCode]!['yourExistingStories']!;
  }

  static String get darkThemeLabel {
    return _localizedValues[locale.languageCode]!['darkThemeLabel']!;
  }

  static String get lightThemeLabel {
    return _localizedValues[locale.languageCode]!['lightThemeLabel']!;
  }

  static String get updateStats {
    return _localizedValues[locale.languageCode]!['updateStatsLabel']!;
  }

  static String get publishUserStory {
    return _localizedValues[locale.languageCode]!['publishUserStory']!;
  }

  static String get publishStoryInstructions {
    return _localizedValues[locale.languageCode]!['publishStoryInstructions']!;
  }

  static String get labelNoPassagesAvailable {
    return _localizedValues[locale.languageCode]!['labelNoPassagesAvailable']!;
  }

  static String get labelShowMarkdownSource {
    return _localizedValues[locale.languageCode]!['labelShowMarkdownSource']!;
  }

  static String get labelShowMarkdownRendered {
    return _localizedValues[locale.languageCode]!['labelShowMarkdownRendered']!;
  }

  static String get labelConvertToMarkdown {
    return _localizedValues[locale.languageCode]!['labelConvertToMarkdown']!;
  }

  static String get labelEditStory {
    return _localizedValues[locale.languageCode]!['labelEditStory']!;
  }

  static String get labelInstructionsForUploadingStory {
    return _localizedValues[locale.languageCode]!
        ['labelInstructionsForUploadingStory']!;
  }

  static String get labelOpenInBrowser {
    return _localizedValues[locale.languageCode]!['labelOpenInBrowser']!;
  }

  static String get labelFileIsBeingUploaded {
    return _localizedValues[locale.languageCode]!['labelFileIsBeingUploaded']!;
  }

  static String get labelShareActions {
    return _localizedValues[locale.languageCode]!['labelShareActions']!;
  }

  static String get labelShareToTwitter {
    return _localizedValues[locale.languageCode]!['labelShareToTwitter']!;
  }

  static String get labelShareToFacebook {
    return _localizedValues[locale.languageCode]!['labelShareToFacebook']!;
  }

  static String get labelUserStoriesCatalog {
    return _localizedValues[locale.languageCode]!['labelUserStoriesCatalog']!;
  }

  static String get labelInstructionsForUploadingStoryToPurgatory {
    return _localizedValues[locale.languageCode]!
        ['labelInstructionsForUploadingStoryToPurgatory']!;
  }

  static String get labelUploadedPurgatoryStoryInstructions {
    return _localizedValues[locale.languageCode]!
        ['labelUploadedPurgatoryStoryInstructions']!;
  }

  static String get labelUploading {
    return _localizedValues[locale.languageCode]!['labelUploading']!;
  }

  static String get shareStoryToPdf {
    return _localizedValues[locale.languageCode]!['shareStoryToPdf']!;
  }
}

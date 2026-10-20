#!/usr/bin/env python3
"""Generate i18n/strings.csv from the Flutter app's Localizations.dart.

Only the keys the reader uses are exported; NEW_STRINGS holds strings that exist
only in the Godot version. Run from the godot/ folder:
    python3 -I tools/extract_strings.py ../locadeserta/lib/models/Localizations.dart
"""
import csv
import re
import sys

LANGS = ("en", "uk")
KEYS = (
    "apptitle", "version", "start", "startstory", "lookingforheroes", "reset",
    "showstorydetails", "translationnotready", "menu", "backtostories", "backtomenu",
    "authors", "next", "theend", "theendstartoverquestion", "labelback",
    "darkThemeLabel", "lightThemeLabel", "labelSiteLink",
)
NEW_STRINGS = {
    "classicAnimationsOn": {"en": "Classic look: on", "uk": "Класичний вигляд: увімк."},
    "classicAnimationsOff": {"en": "Classic look: off", "uk": "Класичний вигляд: вимк."},
    # Home and story screens of the thin design.
    "home_tagline": {"en": "Interactive stories of the Wild Fields", "uk": "Інтерактивні історії Дикого Поля"},
    "home_continue": {"en": "Continue reading", "uk": "Продовжити читання"},
    "home_begin": {"en": "Start reading", "uk": "Почати читати"},
    "home_stories": {"en": "Stories", "uk": "Історії"},
    "filter_all": {"en": "All", "uk": "Усі"},
    "filter_new": {"en": "New", "uk": "Нові"},
    "filter_reading": {"en": "Reading", "uk": "Читаю"},
    "filter_finished": {"en": "Finished", "uk": "Прочитані"},
    "filter_empty": {"en": "Nothing here yet", "uk": "Тут поки порожньо"},
    "meta_minutes": {"en": "%d min", "uk": "%d хв"},
    "meta_endings": {"en": "Endings %d/%d", "uk": "Кінцівки %d/%d"},
    "status_finished": {"en": "Finished", "uk": "Прочитано"},
    "story_continue": {"en": "Continue · %d%%", "uk": "Продовжити · %d%%"},
    "story_restart": {"en": "Start over", "uk": "Почати спочатку"},
    "stat_minutes": {"en": "min read", "uk": "хв читання"},
    "stat_choices": {"en": "choices", "uk": "виборів"},
    "stat_endings": {"en": "endings", "uk": "кінцівки"},
    "endings_title": {"en": "Endings", "uk": "Кінцівки"},
    "ending_alive": {"en": "Survived", "uk": "Вижив"},
    "ending_dead": {"en": "Died", "uk": "Загинув"},
    "ending_open": {"en": "Open ending", "uk": "Відкритий фінал"},
    "ending_hidden": {"en": "Not found yet", "uk": "Ще не знайдено"},
    "story_in_en": {"en": "In English", "uk": "Англійською"},
    "story_in_uk": {"en": "In Ukrainian", "uk": "Українською"},
    "settings_title": {"en": "Settings", "uk": "Налаштування"},
    "settings_theme": {"en": "Theme", "uk": "Тема"},
    "theme_light": {"en": "Light", "uk": "Світла"},
    "theme_dark": {"en": "Dark", "uk": "Темна"},
    "theme_system": {"en": "System", "uk": "Системна"},
    "settings_language": {"en": "Language", "uk": "Мова"},
    "settings_text_size": {"en": "Story text size", "uk": "Розмір тексту історій"},
    "settings_classic": {"en": "Classic look", "uk": "Класичний вигляд"},
    "settings_classic_hint": {"en": "The original design and pictures", "uk": "Оригінальний дизайн та ілюстрації"},
    "settings_haptics": {"en": "Vibration", "uk": "Вібрація"},
}
ENTRY = re.compile(r"'(\w+)':\s*(['\"])(.*?)(?<!\\)\2\s*,", re.S)


def block(source, lang):
    start = source.index(f"'{lang}': {{")
    end = source.index("\n    },", start)
    return source[start:end]


def main():
    source = open(sys.argv[1], encoding="utf-8").read()
    table = {lang: dict((k, v.replace("\\'", "'")) for k, _, v in ENTRY.findall(block(source, lang)))
             for lang in LANGS}
    with open("i18n/strings.csv", "w", encoding="utf-8", newline="") as out:
        writer = csv.writer(out)
        writer.writerow(["keys", *LANGS])
        for key in KEYS:
            writer.writerow([key, *(table[lang][key] for lang in LANGS)])
        for key, values in NEW_STRINGS.items():
            writer.writerow([key, *(values[lang] for lang in LANGS)])


if __name__ == "__main__":
    main()

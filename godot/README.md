# Дике Поле / Loca Deserta: Godot 4 version

Offline interactive-fiction reader for Android and iOS. It's a port of the Flutter app in `../locadeserta`, without the server and the editor. See `../GODOT_MIGRATION_PLAN.md`.

## Run, test, build

```sh
godot --path .                                   # run on desktop (412×915 phone-sized window)
godot --headless --path . -s tests/run_tests.gd  # engine tests: every branch of every story + save/restore
godot --headless --path . -s tests/khotyn_art_test.gd # full Khotyn art coverage + saved passages + animation
godot --path . -- --effects=/tmp/effects        # includes original / new Khotyn drawing / cover comparison
godot --path . -- --tour=/tmp/shots [--classic] [--dark]   # scripted walk that saves screenshots
godot --path . -- --input-test [--classic]               # taps and swipes with real touch events
godot --headless --path . --export-debug "Android" build/android/locadeserta-debug.apk
```

- **Android (Play):** preset *Android (Play AAB)*. Install the build template once (`godot --headless --path . --install-android-build-template`). Then put the **original upload keystore** into the preset (`keystore/release*`). Without it Play rejects the update. `version/code` must stay above the Flutter build (126).
- **iOS:** preset *iOS*. Set `application/app_store_team_id` and export on macOS with Xcode. Replace `icon.png` with a 1024×1024 icon before submitting; the current one is the 192 px launcher icon.

## Layout

| Path | What |
|---|---|
| `addons/gladstories/` | GDScript port of the gladstoriesengine 0.3.2 runtime (`GsStory`, `GsPage`, …) |
| `core/` | autoloads: `AppPrefs` (settings, `user://saves/<story>.json`), `BackgroundImages` (picture choice + animation specs), `StoryLibrary`, `Platform` |
| `anim/` | Flutter curves, `StoryImage` + shader, `SlideableButton`, `VerticalPager`, Material hero arc |
| `ui/` | theme (black / white), scaffold with app bar + menu, router (route transitions, hero flights) |
| `screens/` | landing, catalog (+ waiting), story card, details, reader |
| `assets/` | story JSON (unchanged from Flutter) |
| `images/` | original photo/sketch pairs, `stories/<story>/` generated pictures, `manifest.json` |
| `art/` | image style guide, per-story prompts and character bibles, Astra export |
| `tools/` | prompt listing/validation/export, manifest builder, string extraction |

## Home, story screens and paper reader

`screens/home_screen.gd`, `story_row.gd`, `story_screen.gd`, `settings_sheet.gd`; widgets in `ui/components/thin_widgets.gd`, `pressable.gd` and `line_icon.gd`.

- **Paper style:** warm, subtly textured paper, sepia ink and bundled Noto Serif (including Ukrainian). Dark mode uses a warm dark sheet. Filters are underlined text tabs, and reader passages, pictures and actions have no enclosing borders.
- **Reading:** new passages write themselves onto the page, with brief punctuation pauses and stable line wrapping. *Show full passage* skips the animation without advancing. Saved history appears immediately; reset starts a fresh animation. Choices appear when the passage is fully visible.
- **Home:** wordmark and settings, a *Continue reading* card (or a welcome card), filters (*All / New / Reading / Finished*), and the stories on a timeline by year. The rail dot shows the status: outline = new, ring = reading, filled = finished. Each row shows the reading time, endings found / total, and a progress line.
- **Story page:** the list thumbnail flies into a full-bleed cover. Then year and language, title, author, reading time / choices / endings, the description, endings found (without telling which choices lead there), and *Read*, *Continue · N%* or *Start over*.
- **Settings sheet:** theme (light / dark / system), language, story text size, vibration, classic look.
- **Classic look** switches the whole app back to the original Flutter screens and pictures.
- Reading time is one average playthrough at 1,100 characters per minute. Progress is the share of an average playthrough read so far. Endings are recorded when the reader reaches them (`AppPrefs.endings_found`).

## Pictures and their animation

Each story node with an `imageType` has a stable id, `<story>/<page path>/<node index>` (e.g. `kodak_night/r.0.1/38`). The page path is the sequence of choice indices from the root.

**Two looks**, switchable in the landing menu (*Classic look*):

| | Classic (parity with Flutter) | New (default) |
|---|---|---|
| Pictures | random photo/sketch pairs per theme | the generated picture for that exact node, or a pool pair if none |
| Passage | photo → sketch cross-fade, linear 6 s, Flutter's two-opacity compositing | reveal (3.2 s), then a slow Ken Burns move (14 s) and an ambient effect |
| Catalog card | sketch → photo, 4 s | generated story cover |

**New-look reveals** (`reveal` in the prompt entry):
- `sketch`: a pencil drawing computed from the photo is "painted over" by the photo along a noise mask. This keeps the original game's signature look with a single image file.
- `develop`: darkroom print: paper → sepia → full color, shadows first.
- `ink`: an ink-bleed mask spreads the picture over paper with a dark edge, for shots, deaths and decisions.
- `fade`: a plain fade.

**Motion:** `push_in` toward `focus`, `pull_out`, `pan_left/right`, `tilt_up/down`, or `static`, at most 8 % zoom.

**Ambient effects** (inside `ambient_region`): `fire` (warm flicker), `mist` (drifting fog), `water` (ripple and glints), `wind` (grass/reed sway), `rain`, `snow`, `smoke`, `dust`, `night`.

All of it is one shader (`anim/story_image.gdshader`) and needs no extra assets. The pencil treatment samples neighboring pixels; measure its rendering cost on target phones.

**Khotyn artwork:** all 32 passages are original sepia/graphite illustrations in the style of the three opening drawings, with fine organic linework and ivory paper margins. They use `ink`, static composition and no ambient distortion; no pencil filter is applied. The approved cover remains hyperrealistic and full color. The passage prompts record the three visual reference files.

**Ostannij artwork:** all 15 illustrated passages and the photographic cover are complete. The passage drawings follow the Westerveld-inspired sepia/graphite style, with static ink reveal and no ambient distortion.

### Adding generated pictures (Astra)

1. `python3 -I tools/export_prompts.py`. It writes `art/prompts/export/astra_{characters,covers,scenes}.csv` and `astra_all.jsonl`, skipping pictures that already exist.
2. Generate the **character sheets first** and use them as references for the scenes, so faces stay consistent within a story. Then generate covers and scenes. Output: 4:3, about 1440×1080.
3. Save each picture at its `file` path (`.jpg`, `.png` or `.webp`).
4. `python3 -I tools/build_image_manifest.py`. The game picks up the new pictures and their animation metadata.

Prompts follow `art/STYLE_GUIDE.md`. `tools/validate_prompts.py <story>` checks a prompt file against the story.

## Behaviour differences from the Flutter app (intentional)

- Story nodes tagged `steppe` get pictures (the Dart engine dropped the tag).
- The random picture pool also advances after a choice, so the same picture doesn't repeat across it.
- Progress is saved as a path into the bundled story, not as a copy of the page; it survives app updates that don't change the story's structure.
- Dead-end pages without an ending (six in *After the Battle*) offer *Start over?* instead of leaving the reader without buttons.
- The catalog → details hero never flew in Flutter (the tags differed). That is kept.

**1550–1553 artwork:** `pereprava` (22 passages), `hunting_bears` (13), and `fire_in_steppe` (16) have complete sepia/graphite illustrated editions with static ink reveals and three ultra-realistic full-color covers. Prompts, character references and branch continuity notes are under `art/prompts/`.

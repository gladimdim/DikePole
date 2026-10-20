# Loca Deserta / Dike Pole → Godot 4 migration plan

Status: proposal, rev. 2 (reader only, fully offline) · Source analysed: `master` @ `cb0743b` (Flutter 3.0 upgrade, May 2022)

**Scope:** the Godot version is a **fully offline interactive-fiction reader**. Every story ships inside the app and runs on the device. There is **no server and no editor**. Targets: **Android + iOS**.

> **Status (2026-10-20):** the project is in `godot/` (Godot 4.7.2); see `godot/README.md`.
> - **Done:** M0 (skeleton, assets, export presets; the Android debug APK builds), M1 (engine port; 2,206 checks over every branch of all 11 stories and save/restore at every node), most of M2 (curves, cross-fade, slideable button, diagonal and platform route transitions, hero arc, carousel with revolver shell, auto-scroll, menu blur), M3 (all reader screens, themes, UA/EN, autosave).
> - **Images:** story-specific prompts for all 413 image nodes, plus 11 covers and 105 character sheets (`godot/art/`). The new image animation system (reveal, Ken Burns, ambient effects) is driven by per-image metadata, with the original look kept as "Classic look".
> - **Still open:** Dart differential test (needs the Dart 2.19 SDK); side-by-side comparison with recordings of the Flutter app; release signing (original keystore, iOS team); generating the images.
> - **Found while porting:** A9 never fired in Flutter (the card and details hero tags differ), so it is kept that way. `after_the_battle` has 6 dead-end pages with no ending, which now offer *Start over?*.

---

## 1. What is in the repo, and what moves

| Path | What it is | In the Godot effort? |
|---|---|---|
| `locadeserta/lib/` | Flutter app "Loca Deserta". Android/iOS id `gladimdim.locadeserta`, plus a web build | **Reader part only** (see §1.2) |
| `locadeserta/assets/stories/*.json` + `story_catalog.json` | 11 Ukrainian stories in GladStories JSON (~1.7k passages, ~275k chars) | Copy as-is |
| `locadeserta/images/background/**` | Photo (`c_N.jpg`) + pencil-sketch (`N.jpg`) pairs, 7 themes, plus `cossack_0` | Copy the referenced pairs (see §8) |
| `locadeserta/images/other/` | Icons for the "other games" links | No (row removed) |
| `locadeserta/fonts/` | Roboto, Raleway (has Cyrillic) | Copy |
| `gladstoriesengine` 0.3.2 (pub.dev) | Story engine, pure Dart + `rxdart` | **Port the runtime part to GDScript** |
| `server/` | Dart backend (upload, community catalog, HTML pages) | **No.** Not used by the Godot app |
| `DikePole.html` | 3-passage Twine prototype | No |

### 1.1 Kept: the reader

- **Landing screen:** site link (locadeserta.com), version, cossack image cross-fade, *Start*, UA/ENG radio, menu: dark/light theme. (The "other games" row was removed on request.)
- **Catalog:** stories from `story_catalog.json` sorted by `year` ("Після Битви" filtered out), vertical card carousel with *More details* / *Read*.
- **Story details:** expanded card, authors, description.
- **Story view:** scrolling history (passage text in a bordered box, optional image above), *Next* or choice buttons, *Start over?* at an ending. Menu: *Back to stories*, *Reset*.
- **Autosave** of reading progress on every step, restored when the story is reopened.
- Waiting/loading screen.

### 1.2 Removed

| Removed | Flutter files that are **not** ported |
|---|---|
| Share passed story (upload, link, Twitter/Facebook) | `views/upload_passed_story_view.dart`, `server/server.dart` |
| Community catalog ("purgatory") | `views/purgatory_list_view.dart`, `views/publish_story_to_purgatory_view.dart` |
| Story editor / creator | `creator/**` (except reused UI ideas), `views/story_edit_view.dart`, `views/story_graph_view.dart`, `import_gladstories_view.dart`, `views/story_json_export_view.dart`, `creator/components/share_to_pdf_screen.dart` |
| Convert to Markdown (its image links point at locadeserta.com) | `views/export_to_markdown_view.dart`, `models/markdown_generator.dart` |
| PDF export (already commented out) | `export_pdf_view.dart`, `models/pdf_creator.dart`, `models/story_history.dart` |
| The whole backend | `server/` |

UI changes this causes (intentional, not regressions):
- The catalog loses the *Create story* and *User stories catalog* buttons above the carousel, so the carousel gets the full height.
- The story menu goes down to *Back* and *Reset*; "Edit story", "Share" and "Convert to Markdown" are gone.
- The end-of-story row shows only *Start over?*, at full width.

Dropped dependencies: `http`, `share`, `pdf`, `path_provider`, `tuple`, `flutter_markdown`, `flutter_simple_treeview`, `flutter_slidable`; `rxdart` is replaced by a Godot signal.

---

## 2. Key decisions

| Decision | Recommendation | Why |
|---|---|---|
| Engine | Latest **Godot 4.x stable** (4.5+) | `PropertyTweener.set_custom_interpolator`, `Input.vibrate_handheld(ms, amplitude)`, single-threaded web export |
| Language | **GDScript** | Works on every exporter, web included |
| Renderer | `Compatibility` | 2D UI app; best for low-end phones and web |
| Location | New folder `godot/` in this repo, branch `godot-migration` | The Flutter app stays shippable until parity |
| Coordinates | Stretch mode `canvas_items`, aspect `expand`, base size ≈ **412×915** | 1 Godot unit ≈ 1 Flutter logical px, so animation distances match exactly |
| Network | **None.** No `INTERNET` permission | Everything is bundled; external links open in the system browser via `OS.shell_open` |
| Store identity | Same `gladimdim.locadeserta`, original keystore, `version/code` > 126 | Ships as an update to the existing listing |

---

## 3. Target project layout

```
godot/
  project.godot
  addons/gladstories/          # engine port: RefCounted classes, no nodes
    gs_story.gd  gs_page.gd  gs_page_node.gd  gs_page_next.gd
    gs_history_item.gd  gs_image_type.gd
  core/                        # autoloads
    app_prefs.gd               # theme, language, per-story progress (user://)
    story_library.gd           # loads catalog + story JSON from res://
    background_images.gd       # random photo/sketch pools per ImageType
    router.gd                  # screen stack, transitions, Android back
    platform.gd                # haptics, open URL, ?lang= on web
  anim/
    flutter_curves.gd
    crossfade_image.tscn/.gd/.gdshader
    slideable_button.tscn/.gd
    hero_layer.gd
    vertical_pager.gd
  ui/
    theme_dark.tres  theme_light.tres  fonts/
    components/  bordered_panel  fat_button  app_bar_custom  narrow_scaffold  revolver_shell  story_card
  screens/
    landing  waiting  catalog  story_details  reader
  assets/stories/  assets/story_catalog.json
  images/  images/manifest.json
  i18n/translations.csv
  tests/                       # GUT or gdUnit4
```

---

## 4. Phase 1: Port the GladStories runtime to GDScript

Port only what the reader uses. That's roughly 350 of the 850 Dart lines.

| Dart (`gladstoriesengine.dart`) | GDScript | Port? |
|---|---|---|
| `Story`, `Page`, `PageNode`, `PageNext`, `HistoryItem`, `EndType`, `ImageType` | `GsStory`, `GsPage`, … (`class_name … extends RefCounted`) | ✅ |
| `historyChanges` (`BehaviorSubject`) | `signal history_changed(history)` + `history` property | ✅ |
| `ImageResolver` | `Callable(type) -> {photo, sketch}` | ✅ |
| `doContinue`, `goToNextPage`, `canContinue`, `reset`, `isTheEnd`, `getCurrentNode/Text` | snake_case equivalents, same semantics | ✅ |
| `Story.fromJson`, `Page.fromMap`, `PageNode.fromMap`, `imageTypeFromString` | load story JSON from `res://` | ✅ |
| `toStateJson` / restore with `currentPage` + `history` | **new compact save format** (below) | ✅ (redesigned) |
| `addNode…`, `removeNode…`, `addNextPageWithText`, `findParentOfPage`, `generate`, `toJson` | editor-only | ❌ |
| `convertToMarkDown`, `MarkdownDocument` | sharing only | ❌ |

### 4.1 Save format (device-only, so it can be simpler and more robust)

With no server reading it, we don't need Dart's `toStateJson` layout. Dart stored a full *copy* of the current page subtree, which detached it from `root`. Store a pointer into the bundled story instead:

```json
{
  "v": 1,
  "story": "assets/stories/hunting_bears.json",
  "path": [0, 1],          // choice index taken on each page from root
  "nodeIndex": 3,          // currentIndex on the current page
  "history": [ {"text": "...", "imagePath": ["images/.../c_4.jpg", "images/.../4.jpg"]}, ... ]
}
```

- `history` keeps the exact images the reader already saw, since images are chosen at random.
- On load: walk `path` from `root`. If the story JSON changed in an app update and the path is invalid, fall back to a fresh start instead of crashing.
- Key the save by `storyPath`, not title. Titles could collide or be renamed.

### 4.2 Godot JSON pitfalls
- `JSON.parse_string` returns **every number as float**. Cast `year`, `nodeIndex` and `path` items with `int()`.
- Cyrillic text: read and write UTF-8 (`FileAccess.get_as_text()` / `store_string`).

### 4.3 Behavioural quirks of the original: preserve or fix

| # | Quirk | Effect today | Suggestion |
|---|---|---|---|
| Q1 | `imageTypeFromString` has no `'steppe'` case | 4 nodes in `fire_in_steppe` and `zustrich_v_stepu` show **no image** | Fix (STEPPE → river pool, as intended) |
| Q2 | STEPPE uses the river pool, COSSACKS uses the camp pool | By design | Preserve |
| Q3 | The random pool advances only on *Next*, not after a choice | The same picture can appear twice in a row across a choice | Fix: advance after every image resolve |
| Q4 | Saved `currentPage` is a detached copy | Fragile restore | Fixed by §4.1 |
| Q5 | Choice text goes into history as a plain item; `null` text shows "The End" | n/a | Preserve |
| Q6 | No-repeat random until the pool is exhausted, then reset | n/a | Preserve |

### 4.4 Tests
- Port the runtime-relevant cases from the package's `test/gladstoriesengine_test.dart`.
- **Differential test:** a small Dart script, run with the real 0.3.2 package and a deterministic image resolver, walks *every branch* of all 11 stories and dumps the transcript (texts, image types, end types). The GDScript port must produce identical output, with any Q1/Q3 fixes switched off for this test.
- Save/restore test: interrupt every branch at every node, reload, and continue. The transcript must be identical.

Done when: every branch of all 11 stories matches the Dart transcripts and save/restore is lossless.

---

## 5. Phase 2: Animation parity kit

Before porting anything, **record reference videos** of the current Flutter build on Android, iOS and web for each item below. They are the ground truth for frame-by-frame comparison, and they're the only reliable source for the platform-default route transitions, which differ between Flutter versions.

### 5.1 Exact Flutter curves
`anim/flutter_curves.gd`: a cubic-bezier solver equivalent to Flutter's `Cubic.transform`, plugged into tweens via `set_custom_interpolator()` / `tween_method`. Godot's `TRANS_*`/`EASE_*` are only approximations.

| Flutter curve | Control points |
|---|---|
| `Curves.easeInOut` | (0.42, 0.0, 0.58, 1.0) |
| `Curves.linearToEaseOut` | (0.35, 0.91, 0.33, 0.97) |
| `Curves.easeOutBack` | (0.175, 0.885, 0.32, 1.275) |
| `Curves.fastOutSlowIn` | (0.4, 0.0, 0.2, 1.0) |

### 5.2 Inventory → Godot implementation

| # | Animation (source) | Exact spec | Godot implementation |
|---|---|---|---|
| A1 | **Image cross-fade** `TweenImage` (`animations/fade_images.dart`) | Two stacked images, opacity `1-v`/`v`, `v` 0→1 **linear**, plays **once** when first shown. Landing cossack **4 s** photo→sketch · waiting screen **2 s** · catalog card & details **4 s** sketch→photo · story passage **6 s** photo→sketch | `CrossfadeImage`: shader `mix(tex_a, tex_b, progress)`, tween `progress` on first visibility. New history items fade on their own; old ones never restart |
| A2 | **Slideable button** (`animations/slideable_button.dart`) | Tap → translateX 0 → **+2 × screen width**, **200 ms** `easeInOut` → **then** fire the action → reverse 200 ms | Tween the child `position.x`; `await finished` → emit `pressed` → reverse. Ignore taps mid-animation |
| A3 | **Diagonal route** `SlideRightNavigation` (catalog → story) | New screen slides from **(0.697, 0.717) × screen size** (`Offset.fromDirection(0.8)`) to 0, **300 ms linear**; reverse on back; old screen stays still | `Router.push(screen, SLIDE_DIAGONAL)` |
| A4 | **Named routes** (landing → catalog, catalog → details) | `MaterialPageRoute` platform default: Cupertino slide on iOS, Flutter 3.0 default on Android. **Confirm from the recordings** | `Router.push(screen, PLATFORM_DEFAULT)` |
| A5 | **Catalog appearance** (`main_menu.dart`) | Catalog column translateX **1000 px → 0**, **2000 ms** `linearToEaseOut` | One tween on `position.x` |
| A6 | **Card carousel** `TransformingPageView` | Vertical pager, `viewportFraction 0.8`, snapping, card x-offset **100 px × \|page − index\|** | `VerticalPager`: drag, snap tween (tune against the recording), per-frame offsets |
| A7 | **Revolver shell** (`components/revolver_shell.dart`) | At `page − index ∈ (0.5, 1]` the card collapses to [image @ `1-v`, title @ `v`], bottom-aligned; the layout swap cross-fades **100 ms** | Two child layouts, toggle on threshold, 100 ms modulate fade |
| A8 | **Hero "CossackHero"** (landing image → waiting screen) | Shared-element flight **300 ms**, `fastOutSlowIn`, **arc path** (`MaterialRectArcTween`) | `HeroLayer` on a top `CanvasLayer`: snapshot the source rect + texture, hide the endpoints, tween along the arc, reveal the target |
| A9 | **Hero "CatalogView"+title** (card image → details image) | same as A8 | same |
| A10 | **Story auto-scroll** (`story_view.dart`) | **300 ms** delay → scroll to bottom over **50 ms** `easeOutBack` (overshoot clamped) | `ScrollContainer`: wait for layout, tween `scroll_vertical` |
| A11 | **App bar menu** (`app_bar_custom.dart`, `narrow_scaffold.dart`) | Instant expand 40 → 40 + 50·n px; backdrop **blur σ 1.5** + **20 % black** scrim; tap the scrim to close | `ColorRect` + `hint_screen_texture` blur shader |
| A12 | **Tap feedback** | Material ripple; haptics **light** on *Next*, **medium** on a choice (not on web) | Ripple shader / StyleBox pulse; `Input.vibrate_handheld()` (Android: VIBRATE permission) |

Proportional layout from `MediaQuery`: choice/next buttons = **7.5 % of screen height**, catalog card image = **1/3 height**, waiting image = **50 % height**, all borders **3 px** in the primary color, rounded cossack image radius **20**.

Done when: side-by-side playback against the recordings shows no visible difference for A1–A12.

---

## 6. Phase 3: UI shell, theme, fonts

- **Themes:** dark (black bg / white primary) and light (white / black) `Theme` resources, swapped at the root and persisted.
- **Typography:** story text **Raleway-Bold 18**, headlines Roboto bold 20, buttons bold 20. The Flutter theme names `Montserrat`, but it isn't bundled, so users actually see Roboto. Roboto is declared with only the Regular file, so its bold is synthetic. Match it with `FontVariation.variation_embolden`.
- **Components:** `BorderedPanel` (StyleBoxFlat, 3 px border), `FatButton` (bordered + slideable), `AppBarCustom` (back + title + *Menu ▾*), `NarrowScaffold`.
- **Router:** screen stack, transitions A3/A4, hero hooks, Android back button (`NOTIFICATION_WM_GO_BACK_REQUEST`), immersive fullscreen on Android.

---

## 7. Phase 4: Reader screens

Order: `landing` → `waiting` → `catalog` (A5–A7) → `story_details` (A9) → `reader` (A1, A2, A10, A12).

Reader logic is a direct port of `PassageState`, minus sharing:
- Append a `PassageItemView` per `history_changed` **incrementally** (don't rebuild the list).
- *Next* → light haptic → `do_continue()` → autosave.
- Choice → medium haptic → `go_to_next_page(choice)` → autosave.
- Ending → *Start over?* → `reset()` → clear the save.
- Menu *Reset* reloads the story from `res://` and resets it, matching what `GameView` does.

Localization and settings:
- `LDLocalizations` → a script extracts only the keys the reader uses into `i18n/translations.csv` (`keys,en,uk`). Default `uk`. `TranslationServer.set_locale()`, `tr()`.
- On web, `?lang=` is read via `JavaScriptBridge.eval("location.search")`.
- `AppPrefs` keeps `isDarkTheme`, `languageCode` and per-story progress in `user://`.

Performance: load textures with `ResourceLoader.load_threaded_request`, preload the landing pool on catalog entry (as `precacheImage` does today), and don't keep all images resident on mobile.

**Existing users:** Flutter's SharedPreferences can't be read after the update, so **in-progress reading positions reset once**. Nothing else is lost, since stories are bundled. Optional: show a one-time "progress was reset with the new version" note.

---

## 8. Images: now and "generated later"

Findings:
- Each background is a **pair**: `c_N.jpg` = color photo, `N.jpg` = pencil sketch with a paper border. These are *different artwork*, not desaturations (RMSE 0.27–0.45 vs grayscale), so a shader can't stand in for the sketches.
- Pool sizes are hard-coded (`boat 18, forest 10, bulrush 12, river 21, landing 8, camp 15`). **`boat/` and `river/` each hold one more pair than the max**, so `boat/18` and `river/21` are never shown.
- `images/background/river/*_original.jpg`: 14 unreferenced files, **34 MB of the 58 MB**. Don't copy them.
- Sizes are mixed (500×375 … 1298×863).

Plan:
1. **Parity build:** copy only referenced pairs; import as lossy WebP (≈ 0.8), max 1080 px wide.
2. **Data-driven pools:** `images/manifest.json` (theme → `[{photo, sketch}]`) replaces the hard-coded counts, so new images are drop-in (this also makes the two hidden pairs reachable).
3. **Generation (later):** per-theme style sheet and prompts (XVII-century Zaporozhian cossacks: Dnipro, bulrush, steppe, camp, boat, forest, landing; 4:3; consistent palette; no anachronisms). Each image needs a color version **and** a matching sketch version (generated, or a deterministic pencil-filter pass so pairs always line up). A script resizes, compresses, updates the manifest and renders a contact sheet for review.
   *This session has no image-generation model. Options: render through the connected Blender MCP, use an external image model with my pipeline scripts, or commission art.*
4. New themes (e.g. a real STEPPE pool) = manifest entry + `imageTypeFromString` mapping, compatible with the existing story JSON.

---

## 9. Phase 5: Optional enhancements ("even better")

Behind a **Settings → "Classic animations"** toggle, so strict parity is always available.

- **Ink-bleed reveal:** the photo↔sketch transition uses a brush/noise mask instead of a flat fade (same `CrossfadeImage`, new mode).
- **Ken Burns:** slow pan/zoom on passage images during their 6 s fade.
- **Typewriter text** for new passages (`visible_ratio` tween); a tap completes it.
- **Card parallax** in the carousel.
- **Ambient audio per `ImageType`** (river, camp fire, wind in bulrush, forest), cross-faded. Biggest atmosphere gain for the effort.
- **Particles:** embers for `camp`, mist for `river`/`bulrush` (`CPUParticles2D` for web/Compatibility).
- **Distinct DEAD vs ALIVE endings** (the engine already exposes `endType`).

---

## 10. Phase 6: Export & release

- **Android:** `gladimdim.locadeserta`, **original upload keystore**, `version/code` > 126, AAB, target SDK at the current Play requirement (check that Godot's min SDK doesn't drop current users on SDK 24). Permissions: VIBRATE only. Use the `gplay-*` skills for preflight and a staged rollout (internal → beta → production).
- **iOS:** bundle `gladimdim.locadeserta`, same team/certs.
- **Web (if kept):** single-threaded export, custom HTML shell (favicons + analytics from `locadeserta/web/index.html`), `?lang=` support. Mind the first-load size; consider the image pack as a separate PCK.
- **Desktop:** nearly free with Godot, if wanted.
- Retire the Flutter app once the Godot build is live in production.

---

## 11. Milestones & rough sizing

| # | Milestone | Size | Exit criteria |
|---|---|---|---|
| M0 | Reference recordings, Godot skeleton, asset copy, export presets | S | Empty app runs on Android/iOS(/web) |
| M1 | GladStories runtime in GDScript + differential & save tests | M | All 11 stories match the Dart transcripts |
| M2 | Animation parity kit A1–A12 | M | Side-by-side matches the recordings |
| M3 | Reader screens, themes, i18n, autosave | M | Every story playable end-to-end, progress persists |
| M4 | Store release (internal → staged) | S–M | Installs as an update over the Flutter version |
| M5 | Enhancements + generated images | M–L | Toggleable, smooth on low-end devices |

---

## 12. Open questions

1. Ship as an **update** to the existing listings? That needs the original Android keystore and iOS certificates.
2. Q1 (missing steppe images), Q3 (repeat images after a choice) and the two hidden image pairs: **preserve** for strict parity, or **fix**?
3. Keep the **web** build?
4. ~~Keep the external links?~~ The "other games" row is removed; only the locadeserta.com link remains.
5. English stories: the UI is bilingual but the catalog is Ukrainian only. Planned?

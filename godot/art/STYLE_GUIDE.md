# Dike Pole: image style guide (Astra image generation)

Every story image is an **ultra-realistic photograph** that reads like a still from a big-budget historical film shot on location in Ukraine. One image per story node that has an `imageType`, plus one cover per story.

## 1. Output spec

| | |
|---|---|
| Aspect | **4:3 landscape** (the reader shows images full-width above the text) |
| Size | 1440×1080 or the nearest 4:3 the tool offers. The game imports at max 1080 px wide |
| Format | JPG/WebP, sRGB |
| File name | exactly the `file` field of the prompt entry, e.g. `images/stories/kodak_night/r.1_n12.jpg` |
| Safe area | keep the subject inside the central 80 %: the Ken Burns animation crops up to 8 % at the edges |

## 2. Fixed style tail (append to every prompt)

> ultra-realistic photograph, cinematic historical film still, shot on location in Ukraine, natural light, authentic 17th-century materials (wool, linen, leather, iron, wood), natural skin texture with pores and weathering, subtle film grain, muted earthy color palette, shallow depth of field, 35mm lens, 4:3

## 3. Fixed negative prompt

> text, letters, caption, watermark, logo, signature, frame, border, modern objects, plastic, zippers, sunglasses, wristwatch, power lines, asphalt, cars, modern buildings, fantasy armor, plate armor (unless stated), horned helmets, anime, cartoon, illustration, painting, 3d render, CGI look, video game, oversaturated, HDR halo, plastic skin, airbrushed, extra fingers, deformed hands, extra limbs, duplicate faces, gore, blood pools, exposed organs, dismemberment

## 4. Historical bible

**Place:** Wild Fields (Дике Поле) and Zaporizhzhia, 1550s–1650s. The lower Dnipro with rapids and islands, *plavni* (endless reed and bulrush marshes), feather-grass steppe (kovyla) with burial mounds (kurgans), ravines (balky), oak/pine/birch forests, sloboda villages of whitewashed clay huts with thatched roofs, wooden palisades.

**Zaporozhian Cossacks:** shaved head with a long forelock (*oseledets/chupryna*) or cropped hair under a fur-trimmed *kalpak* hat; long drooping mustache, often no beard; linen shirt; very wide *sharovary* trousers (red, blue, dark green wool); *zhupan* or *kuntush* coat; wide colored sash; leather boots (often red/yellow); weapons: curved *shablia* sabre, *samopal* matchlock/flintlock musket, pistols in the sash, powder horn, bandolier of charges, *rohach* boar spear for hunting. No plate armor; occasionally a mail shirt or a misiurka helmet on officers.
**Chaika:** long narrow oared Cossack boat, ~18 m, no deck, bundles of reeds lashed along the sides, a single mast with a square sail, 10–15 oars a side.
**Camp (tabir/kish):** wagons in a circle, cooking cauldrons on tripods, campfires, horses on tethers, canvas or felt tents, smoke.
**Crimean Tatars:** light horsemen, quilted kaftans, sheepskin or fur caps, composite bows and quivers, curved sabres, lassos, small sturdy steppe horses.
**Ottoman Turks (Khotyn 1621):** janissaries in long coats with the tall white *börk* cap, muskets, bronze cannons, large camp with tents and banners.
**Polish-Lithuanian army (1648/1651):** hussars with wings only where the text explicitly says so; otherwise haiduks in blue coats, dragoons, registered Cossacks, noble cavalry in fur-trimmed coats.
**Kodak fortress (1635):** star-shaped earthwork fort with bastions, palisade and ditch on a Dnipro cliff; garrison of German/Western mercenaries (morion helmets, buff coats, pikes, matchlocks) under French officer Jean Marion.

## 5. Tone & content rules

- Violence is **implied**: the raised sabre, the musket flash, the smoke, the fallen figure seen from a distance. No gore, no close-ups of wounds. Death scenes are quiet and respectful. The game is rated for teens on the stores.
- Animals (bears, wolves, horses) are anatomically correct and photographed like wildlife photography.
- Night scenes are lit by moonlight, campfire or torches. Keep them readable: no pure black frames.
- People look like real Ukrainians of the period: weathered, sunburnt, varied ages. Not models.

## 6. Character consistency

Each story has a **character sheet** (`<story_id>.bible.json`) with a fixed visual description for every recurring character, e.g.:

> Ivan Sulyma: 45-year-old Zaporozhian otaman, broad weathered face, grey long mustache, black forelock, scar over left eyebrow, crimson zhupan, black sash, kalpak with fox fur

Paste that exact description into every prompt where the character appears. If Astra supports a reference image / character lock, generate a **character portrait** first (`<story_id>/char_<name>`) and use it as the reference.

## 7. Prompt structure

```
[shot type], [who + what they are doing], [where], [time of day / light / weather], [mood], [camera], <style tail>
```

Shot vocabulary: *wide establishing shot, medium shot, close-up, over-the-shoulder, low-angle, high-angle, aerial view, POV through reeds/branches*.

## 8. Animation metadata (read by the game)

Every prompt entry carries hints for `anim/story_image.gdshader` + `anim/story_image.gd`:

| field | values | meaning |
|---|---|---|
| `motion.type` | `push_in`, `pull_out`, `pan_left`, `pan_right`, `tilt_up`, `tilt_down`, `static` | slow Ken Burns move while the passage is on screen |
| `motion.focus` | `[x, y]` in 0..1 | where the subject is; `push_in` zooms toward it |
| `ambient` | `none`, `fire`, `mist`, `water`, `wind`, `rain`, `snow`, `smoke`, `dust`, `night` | overlay effect: fire flicker, drifting mist, water shimmer, wind (grass/reed sway), rain streaks, snowfall, rising smoke, dust motes, moonlight breathing |
| `ambient_region` | `[x, y, w, h]` in 0..1 (optional) | where the effect applies (e.g. the water in the lower third) |
| `reveal` | `sketch`, `develop`, `ink`, `fade` | how the image appears: pencil sketch → photo, darkroom develop, ink-bleed mask, plain fade |

Pick `reveal: sketch` by default (it keeps the original game's signature pencil-sketch ↔ photo look). Use `develop` for night/fire scenes, `ink` for dramatic moments (shots, deaths, decisions) and `fade` for quiet transitions.

## 9. Prompt entry format (`art/prompts/<story_id>.jsonl`, one JSON object per line)

```json
{"id":"kodak_night/r.1/12","file":"images/stories/kodak_night/r.1_n12.jpg","story":"kodak_night","theme":"boat","source_text":"<original passage text>","prompt":"<full prompt incl. style tail>","negative_prompt":"<fixed negative prompt>","aspect_ratio":"4:3","characters":["ivan_sulyma"],"motion":{"type":"push_in","focus":[0.55,0.45]},"ambient":"water","ambient_region":[0,0.6,1,0.4],"reveal":"sketch"}
```

The cover uses id `<story_id>/cover` and file `images/stories/<story_id>/cover.jpg`. It's the story's most iconic moment without spoilers of the ending.

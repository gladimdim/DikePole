#!/usr/bin/env python3
"""Export the prompts as batch files for the Astra image generator.

Writes into art/prompts/export/:
  astra_characters.csv  character reference sheets (generate first; use them as
                        reference images if Astra supports it)
  astra_covers.csv      one cover per story
  astra_scenes.csv      every story node picture
  astra_all.jsonl       everything above, one JSON object per line
Columns: file, id, story, aspect_ratio, width, height, prompt, negative_prompt, characters.
Skips pictures that already exist unless --all is given. Run from the godot/ folder.
"""
import csv
import glob
import json
import os
import sys

WIDTH, HEIGHT = 1440, 1080
STYLE_TAIL = ("ultra-realistic photograph, cinematic historical film still, shot on location in Ukraine, "
              "natural light, authentic 17th-century materials (wool, linen, leather, iron, wood), natural skin "
              "texture with pores and weathering, subtle film grain, muted earthy color palette, shallow depth of "
              "field, 35mm lens, 4:3")
CHARACTER_PROMPT = ("Character reference sheet, the same person shown three times side by side on a plain light grey "
                    "studio backdrop: front view full body, three-quarter view full body, and a close-up portrait of "
                    "the face. {description}. Even soft studio light, neutral expression, sharp detail on face, "
                    "costume and weapons. ") + STYLE_TAIL
OUT_DIR = "art/prompts/export"
COLUMNS = ("file", "id", "story", "aspect_ratio", "width", "height", "prompt", "negative_prompt", "characters")


def exists(file):
    stem = os.path.splitext(file)[0]
    return any(os.path.exists(stem + ext) for ext in (".jpg", ".jpeg", ".png", ".webp"))


def row(entry):
    return {
        "file": entry["file"], "id": entry["id"], "story": entry["story"],
        "aspect_ratio": entry["aspect_ratio"], "width": WIDTH, "height": HEIGHT,
        "prompt": entry["prompt"], "negative_prompt": entry["negative_prompt"],
        "characters": ",".join(entry.get("characters", [])),
    }


def main():
    include_existing = "--all" in sys.argv
    scenes, covers, characters = [], [], []
    negative = None
    for path in sorted(glob.glob("art/prompts/*.jsonl")):
        with open(path, encoding="utf-8") as f:
            for line in f:
                if not line.strip():
                    continue
                entry = json.loads(line)
                negative = negative or entry["negative_prompt"]
                if not include_existing and exists(entry["file"]):
                    continue
                (covers if entry["id"].endswith("/cover") else scenes).append(row(entry))
    for path in sorted(glob.glob("art/prompts/*.bible.json")):
        with open(path, encoding="utf-8") as f:
            bible = json.load(f)
        story = bible["story"]
        for name, description in bible.get("characters", {}).items():
            file = f"images/stories/{story}/char_{name}.jpg"
            if not include_existing and exists(file):
                continue
            characters.append({
                "file": file, "id": f"{story}/char_{name}", "story": story, "aspect_ratio": "4:3",
                "width": WIDTH, "height": HEIGHT,
                "prompt": CHARACTER_PROMPT.format(description=description.rstrip(".")),
                "negative_prompt": negative, "characters": name,
            })
    os.makedirs(OUT_DIR, exist_ok=True)
    for name, rows in (("characters", characters), ("covers", covers), ("scenes", scenes)):
        with open(f"{OUT_DIR}/astra_{name}.csv", "w", encoding="utf-8", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=COLUMNS)
            writer.writeheader()
            writer.writerows(rows)
    with open(f"{OUT_DIR}/astra_all.jsonl", "w", encoding="utf-8") as f:
        for r in characters + covers + scenes:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")
    print(f"characters {len(characters)}, covers {len(covers)}, scenes {len(scenes)} -> {OUT_DIR}/")


if __name__ == "__main__":
    main()

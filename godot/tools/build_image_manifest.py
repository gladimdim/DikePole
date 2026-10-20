#!/usr/bin/env python3
"""Build images/manifest.json, the index core/background_images.gd reads at runtime.

- pools: the original photo (c_N) / sketch (N) pairs per theme folder. legacy_size is
  how many of them the Flutter app used (it hard-coded the counts).
- nodes / covers: generated story pictures found under images/stories/<story id>/,
  with their animation metadata taken from art/prompts/<story id>.jsonl.

Run from the godot/ folder after adding or removing pictures:
    python3 -I tools/build_image_manifest.py
"""
import glob
import json
import os
import re

POOLS = ("boat", "bulrush", "camp", "forest", "landing", "river")
LEGACY_SIZE = {"boat": 18, "forest": 10, "bulrush": 12, "river": 21, "landing": 8, "camp": 15}
IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png", ".webp")
ANIMATION_KEYS = ("reveal", "motion", "ambient", "ambient_region")


def pools():
    result = {}
    for pool in POOLS:
        folder = f"images/background/{pool}"
        numbers = sorted(int(m.group(1)) for f in os.listdir(folder)
                         if (m := re.fullmatch(r"c_(\d+)\.jpg", f)) and os.path.exists(f"{folder}/{m.group(1)}.jpg"))
        result[pool] = {
            "legacy_size": LEGACY_SIZE[pool],
            "images": [{"photo": f"res://{folder}/c_{n}.jpg", "sketch": f"res://{folder}/{n}.jpg"} for n in numbers],
        }
    return result


def prompt_entries():
    entries = {}
    for path in glob.glob("art/prompts/*.jsonl"):
        with open(path, encoding="utf-8") as f:
            for line in f:
                if line.strip():
                    entry = json.loads(line)
                    entries[os.path.splitext(entry["file"])[0]] = entry
    return entries


def generated():
    entries = prompt_entries()
    nodes, covers = {}, {}
    for path in sorted(glob.glob("images/stories/*/*")):
        stem, ext = os.path.splitext(path)
        if ext.lower() not in IMAGE_EXTENSIONS:
            continue
        entry = entries.get(stem)
        if entry is None:
            print(f"warning: {path} has no prompt entry, skipped")
            continue
        spec = {"image": f"res://{path}"}
        spec.update({k: entry[k] for k in ANIMATION_KEYS if k in entry})
        if entry["id"].endswith("/cover"):
            covers[entry["story"]] = spec
        elif "/char_" not in entry["id"]:
            nodes[entry["id"]] = spec
    return nodes, covers


def main():
    nodes, covers = generated()
    manifest = {"pools": pools(), "nodes": nodes, "covers": covers}
    with open("images/manifest.json", "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=1)
    sizes = {p: len(v["images"]) for p, v in manifest["pools"].items()}
    print(f"pools {sizes}, generated node images {len(nodes)}, covers {len(covers)}")


if __name__ == "__main__":
    main()

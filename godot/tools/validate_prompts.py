#!/usr/bin/env python3
"""Validate art/prompts/<story_id>.jsonl against the story and STYLE_GUIDE.md.

Checks: every image node of the story has exactly one entry, a cover exists,
file names follow the id, and the animation metadata uses known values.

Usage: validate_prompts.py <story_id> [<story_id> ...]
Run from the godot/ folder.
"""
import json
import os
import sys

MOTIONS = {"push_in", "pull_out", "pan_left", "pan_right", "tilt_up", "tilt_down", "static"}
AMBIENTS = {"none", "fire", "mist", "water", "wind", "rain", "snow", "smoke", "dust", "night"}
REVEALS = {"sketch", "develop", "ink", "fade"}
REQUIRED = ("id", "file", "story", "theme", "prompt", "negative_prompt", "aspect_ratio", "motion", "ambient", "reveal")


def expected_ids(story_id):
    with open(f"assets/stories/{story_id}.json", encoding="utf-8") as f:
        story = json.load(f)
    ids = {f"{story_id}/cover"}
    stack = [(story["root"], "r")]
    while stack:
        page, path = stack.pop()
        for idx, node in enumerate(page.get("nodes") or []):
            if node.get("imageType"):
                ids.add(f"{story_id}/{path}/{idx}")
        for i, nxt in enumerate(page.get("next") or []):
            stack.append((nxt.get("nextPage") or {}, f"{path}.{i}"))
    return ids


def file_for(entry_id):
    story_id, rest = entry_id.split("/", 1)
    if rest == "cover" or rest.startswith("char_"):
        return f"images/stories/{story_id}/{rest}.jpg"
    path, idx = rest.rsplit("/", 1)
    return f"images/stories/{story_id}/{path}_n{idx}.jpg"


def in_unit(values, count):
    return isinstance(values, list) and len(values) == count and all(
        isinstance(v, (int, float)) and 0 <= v <= 1 for v in values)


def validate(story_id):
    errors = []
    seen = set()
    path = f"art/prompts/{story_id}.jsonl"
    if not os.path.exists(path):
        return [f"{path} missing"]
    with open(path, encoding="utf-8") as f:
        for n, line in enumerate(f, 1):
            if not line.strip():
                continue
            try:
                e = json.loads(line)
            except json.JSONDecodeError as ex:
                errors.append(f"line {n}: bad JSON ({ex})")
                continue
            where = f"line {n} ({e.get('id')})"
            for key in REQUIRED:
                if key not in e:
                    errors.append(f"{where}: missing {key}")
            if e.get("id") in seen:
                errors.append(f"{where}: duplicate id")
            seen.add(e.get("id"))
            if e.get("id"):
                stem, ext = os.path.splitext(e.get("file", ""))
                expected_stem = os.path.splitext(file_for(e["id"]))[0]
                if stem != expected_stem or ext.lower() not in {".jpg", ".jpeg", ".png", ".webp"}:
                    errors.append(f"{where}: file should use stem {expected_stem} and a supported image extension")
            if e.get("aspect_ratio") != "4:3":
                errors.append(f"{where}: aspect_ratio must be 4:3")
            motion = e.get("motion") or {}
            if motion.get("type") not in MOTIONS:
                errors.append(f"{where}: motion.type {motion.get('type')!r}")
            if not in_unit(motion.get("focus"), 2):
                errors.append(f"{where}: motion.focus must be [x, y] in 0..1")
            if e.get("ambient") not in AMBIENTS:
                errors.append(f"{where}: ambient {e.get('ambient')!r}")
            if "ambient_region" in e and not in_unit(e["ambient_region"], 4):
                errors.append(f"{where}: ambient_region must be [x, y, w, h] in 0..1")
            if e.get("reveal") not in REVEALS:
                errors.append(f"{where}: reveal {e.get('reveal')!r}")
            if len(e.get("prompt", "")) < 120:
                errors.append(f"{where}: prompt suspiciously short")
    want = expected_ids(story_id)
    extra = {i for i in seen - want if not i.split("/", 1)[1].startswith("char_")}
    for missing in sorted(want - seen):
        errors.append(f"missing entry {missing}")
    for unknown in sorted(extra):
        errors.append(f"unknown id {unknown}")
    if not os.path.exists(f"art/prompts/{story_id}.bible.json"):
        errors.append(f"art/prompts/{story_id}.bible.json missing")
    return errors


def main():
    failed = False
    for story_id in sys.argv[1:]:
        errors = validate(story_id)
        print(f"{story_id}: {'OK' if not errors else f'{len(errors)} problem(s)'}")
        for err in errors:
            print("   ", err)
        failed |= bool(errors)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
